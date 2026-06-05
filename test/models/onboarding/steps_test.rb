# frozen_string_literal: true

require 'test_helper'

module Onboarding
  class StepsTest < ActiveSupport::TestCase
    include Rails.application.routes.url_helpers

    test '.next walks the onboarding sequence' do
      assert_equal 'account', Steps.next('welcome')
      assert_equal 'library', Steps.next('account')
      assert_equal 'import', Steps.next('library')
      assert_equal 'done', Steps.next('import')
      assert_nil Steps.next('done')
    end

    test '.next returns nil for unknown steps' do
      assert_nil Steps.next('metadata')
    end

    test '.path_for maps each active step to a route' do
      assert_equal onboarding_welcome_path, Steps.path_for('welcome')
      assert_equal onboarding_account_path, Steps.path_for('account')
      assert_equal onboarding_library_path, Steps.path_for('library')
      assert_equal onboarding_import_path, Steps.path_for('import')
      assert_equal onboarding_completion_path, Steps.path_for('done')
    end

    test '.path_for falls back to the onboarding entry for unknown steps' do
      assert_equal onboarding_root_path, Steps.path_for('metadata')
    end
  end
end
