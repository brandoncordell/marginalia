# lib/server_sizing.rb
#
# Auto-sizes Puma workers for the host, respecting container (cgroup) limits.
# Plain Ruby, no Rails dependencies — safe to require from config/puma.rb,
# which is evaluated before the Rails app boots.
#
# Resolution order for worker count: WEB_CONCURRENCY env var, else auto-detect.

require 'etc'

# ServerSizing is a module that provides methods for auto-sizing the number of Puma workers for the host,
# respecting container (cgroup) limits. This will hopefully allow us to utilize more of the hardware
# on small servers.
module ServerSizing
  module_function

  # Hard ceiling for auto-detection. A self-hoster who genuinely wants more
  # sets WEB_CONCURRENCY explicitly.
  MAX_AUTO_WORKERS = 4

  # Rough RAM budget per Puma worker (MB). Conservative for a Rails app.
  MB_PER_WORKER = 256

  # Reserve for the OS / other processes before dividing memory among workers.
  RESERVED_MB = 128

  def workers
    Integer(ENV['WEB_CONCURRENCY'] || auto_workers)
  end

  def threads
    Integer(ENV['RAILS_MAX_THREADS'] || 3)
  end

  # Limited by BOTH cpu and memory: take whichever allows fewer workers.
  def auto_workers
    by_cpu = Etc.nprocessors # honors cgroup CPU quota on Ruby 3.x
    by_mem = [(available_memory_mb - RESERVED_MB) / MB_PER_WORKER, 1].max
    [by_cpu, by_mem].min.clamp(1, MAX_AUTO_WORKERS)
  end

  # Container memory limit if one is set, otherwise host RAM.
  def available_memory_mb
    container_memory_mb || host_memory_mb
  end

  def container_memory_mb
    v2 = '/sys/fs/cgroup/memory.max' # cgroup v2
    v1 = '/sys/fs/cgroup/memory/memory.limit_in_bytes' # cgroup v1
    bytes =
      if File.exist?(v2) && (raw = File.read(v2).strip) != 'max'
        raw.to_i
      elsif File.exist?(v1)
        File.read(v1).to_i
      end
    return nil if bytes.nil? || bytes <= 0 || bytes > 2**60 # >2^60 == "unlimited"

    bytes / (1024 * 1024)
  rescue StandardError
    nil
  end

  def host_memory_mb
    kb = File.read('/proc/meminfo')[/MemTotal:\s+(\d+)/, 1].to_i
    kb.positive? ? kb / 1024 : 1024
  rescue StandardError
    1024 # safe fallback if /proc isn't readable (e.g. non-Linux dev box)
  end
end
