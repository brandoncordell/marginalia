# frozen_string_literal: true

# Coverage is opt-in via bin/coverage (sets COVERAGE=true).
return unless ENV['COVERAGE'] == 'true'

require 'simplecov'

SimpleCov.start 'rails' do
  skip '/test/'
  skip '/config/'
  skip '/vendor/'
  skip '/bin/'
  skip '/lib/generators/'
  skip 'component_preview.rb'

  group 'Controllers', 'app/controllers'
  group 'Models', 'app/models'
  group 'Components', 'app/views/components'
  group 'Jobs', 'app/jobs'
  group 'Libraries', 'lib'
end
