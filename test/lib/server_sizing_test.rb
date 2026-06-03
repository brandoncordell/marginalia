# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/server_sizing'

# Minitest 6 dropped the bundled `minitest/mock` (and `Object#stub`), so we
# provide a tiny, self-contained equivalent: temporarily replace a singleton
# method for the duration of the block, then restore the original.
class Object
  def stub(name, value_or_callable = nil)
    meta = singleton_class
    saved = :"__stub_saved_#{name}__"
    meta.send(:alias_method, saved, name)
    impl = value_or_callable.respond_to?(:call) ? value_or_callable : ->(*) { value_or_callable }
    meta.send(:define_method, name) { |*args, **kwargs, &blk| impl.call(*args, **kwargs, &blk) }
    yield
  ensure
    meta.send(:remove_method, name)
    meta.send(:alias_method, name, saved)
    meta.send(:remove_method, saved)
  end
end

class ServerSizingTest < ActiveSupport::TestCase
  CGROUP_V2 = '/sys/fs/cgroup/memory.max'
  CGROUP_V1 = '/sys/fs/cgroup/memory/memory.limit_in_bytes'
  MB = 1024 * 1024

  setup do
    @original_env = ENV.to_hash
  end

  teardown do
    ENV.replace(@original_env)
  end

  # --- #workers ----------------------------------------------------------

  test 'workers honors WEB_CONCURRENCY when set' do
    ENV['WEB_CONCURRENCY'] = '8'
    assert_equal 8, ServerSizing.workers
  end

  test 'workers does not clamp an explicit WEB_CONCURRENCY above MAX_AUTO_WORKERS' do
    ENV['WEB_CONCURRENCY'] = '32'
    assert_equal 32, ServerSizing.workers
  end

  test 'workers falls back to auto_workers when WEB_CONCURRENCY is unset' do
    ENV.delete('WEB_CONCURRENCY')
    ServerSizing.stub(:auto_workers, 3) do
      assert_equal 3, ServerSizing.workers
    end
  end

  test 'workers raises for a non-integer WEB_CONCURRENCY' do
    ENV['WEB_CONCURRENCY'] = 'not-a-number'
    assert_raises(ArgumentError) { ServerSizing.workers }
  end

  # --- #threads ----------------------------------------------------------

  test 'threads defaults to 3 when RAILS_MAX_THREADS is unset' do
    ENV.delete('RAILS_MAX_THREADS')
    assert_equal 3, ServerSizing.threads
  end

  test 'threads honors RAILS_MAX_THREADS when set' do
    ENV['RAILS_MAX_THREADS'] = '12'
    assert_equal 12, ServerSizing.threads
  end

  test 'threads raises for a non-integer RAILS_MAX_THREADS' do
    ENV['RAILS_MAX_THREADS'] = 'lots'
    assert_raises(ArgumentError) { ServerSizing.threads }
  end

  # --- #auto_workers -----------------------------------------------------

  test 'auto_workers clamps to MAX_AUTO_WORKERS when cpu and memory are plentiful' do
    Etc.stub(:nprocessors, 16) do
      ServerSizing.stub(:available_memory_mb, 64_000) do
        assert_equal ServerSizing::MAX_AUTO_WORKERS, ServerSizing.auto_workers
      end
    end
  end

  test 'auto_workers is limited by cpu when memory is plentiful' do
    Etc.stub(:nprocessors, 2) do
      ServerSizing.stub(:available_memory_mb, 64_000) do
        assert_equal 2, ServerSizing.auto_workers
      end
    end
  end

  test 'auto_workers is limited by memory when cpus are plentiful' do
    # (512 - 128) / 256 == 1 worker by memory
    Etc.stub(:nprocessors, 16) do
      ServerSizing.stub(:available_memory_mb, 512) do
        assert_equal 1, ServerSizing.auto_workers
      end
    end
  end

  test 'auto_workers never drops below 1 even with tiny memory' do
    Etc.stub(:nprocessors, 8) do
      ServerSizing.stub(:available_memory_mb, 64) do
        assert_equal 1, ServerSizing.auto_workers
      end
    end
  end

  # --- #available_memory_mb ---------------------------------------------

  test 'available_memory_mb prefers the container limit when present' do
    ServerSizing.stub(:container_memory_mb, 2048) do
      ServerSizing.stub(:host_memory_mb, 16_384) do
        assert_equal 2048, ServerSizing.available_memory_mb
      end
    end
  end

  test 'available_memory_mb falls back to host memory when no container limit' do
    ServerSizing.stub(:container_memory_mb, nil) do
      ServerSizing.stub(:host_memory_mb, 16_384) do
        assert_equal 16_384, ServerSizing.available_memory_mb
      end
    end
  end

  # --- #container_memory_mb ---------------------------------------------

  test 'container_memory_mb reads the cgroup v2 limit' do
    stub_files(exist: [CGROUP_V2], reads: { CGROUP_V2 => (512 * MB).to_s }) do
      assert_equal 512, ServerSizing.container_memory_mb
    end
  end

  test 'container_memory_mb treats cgroup v2 "max" as no limit and falls back to v1' do
    reads = { CGROUP_V2 => 'max', CGROUP_V1 => (256 * MB).to_s }
    stub_files(exist: [CGROUP_V2, CGROUP_V1], reads: reads) do
      assert_equal 256, ServerSizing.container_memory_mb
    end
  end

  test 'container_memory_mb returns nil when cgroup v2 is "max" and v1 is absent' do
    stub_files(exist: [CGROUP_V2], reads: { CGROUP_V2 => 'max' }) do
      assert_nil ServerSizing.container_memory_mb
    end
  end

  test 'container_memory_mb falls back to cgroup v1 when v2 is absent' do
    stub_files(exist: [CGROUP_V1], reads: { CGROUP_V1 => (1024 * MB).to_s }) do
      assert_equal 1024, ServerSizing.container_memory_mb
    end
  end

  test 'container_memory_mb returns nil when no cgroup files exist' do
    stub_files(exist: [], reads: {}) do
      assert_nil ServerSizing.container_memory_mb
    end
  end

  test 'container_memory_mb returns nil for a non-positive limit' do
    stub_files(exist: [CGROUP_V2], reads: { CGROUP_V2 => '0' }) do
      assert_nil ServerSizing.container_memory_mb
    end
  end

  test 'container_memory_mb treats an absurdly large limit as unlimited' do
    stub_files(exist: [CGROUP_V2], reads: { CGROUP_V2 => (2**61).to_s }) do
      assert_nil ServerSizing.container_memory_mb
    end
  end

  test 'container_memory_mb swallows errors and returns nil' do
    File.stub(:exist?, ->(*) { raise Errno::EACCES }) do
      assert_nil ServerSizing.container_memory_mb
    end
  end

  # --- #host_memory_mb ---------------------------------------------------

  test 'host_memory_mb parses MemTotal from /proc/meminfo' do
    meminfo = "MemTotal:        2048000 kB\nMemFree:          512000 kB\n"
    File.stub(:read, meminfo) do
      assert_equal 2000, ServerSizing.host_memory_mb
    end
  end

  test 'host_memory_mb falls back to 1024 when MemTotal is missing' do
    File.stub(:read, "MemFree:  512000 kB\n") do
      assert_equal 1024, ServerSizing.host_memory_mb
    end
  end

  test 'host_memory_mb falls back to 1024 when /proc/meminfo cannot be read' do
    File.stub(:read, ->(*) { raise Errno::ENOENT }) do
      assert_equal 1024, ServerSizing.host_memory_mb
    end
  end

  private

  # Stubs File.exist? / File.read so only the listed paths "exist" and return
  # the given contents. Any unexpected read raises, surfacing logic mistakes.
  def stub_files(exist:, reads:, &)
    File.stub(:exist?, ->(path) { exist.include?(path) }) do
      File.stub(:read, ->(path) { reads.fetch(path) }, &)
    end
  end
end
