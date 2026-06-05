# frozen_string_literal: true

require_relative 'simplecov_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Minitest 6 loads plugins explicitly (see active_support/testing/autorun.rb).
# Without this, SimpleCov's at_exit hook never runs — Minitest's inner at_exit
# calls exit before other handlers — so only .resultset.json is written.
if ENV['COVERAGE'] == 'true' && defined?(Minitest) && Minitest.respond_to?(:load)
  Minitest.load :simplecov
end

require_relative 'test_helpers/session_test_helper'

module ActiveSupport
  class TestCase
    # Parallel workers skew SimpleCov results; bin/coverage runs single-process.
    parallelize(workers: :number_of_processors) unless ENV['COVERAGE'] == 'true'

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
