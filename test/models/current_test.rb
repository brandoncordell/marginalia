# frozen_string_literal: true

require 'test_helper'

class CurrentTest < ActiveSupport::TestCase
  test '.setting memoizes Setting.instance for the request' do
    Setting.delete_all
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false)

    assert_equal setting, Current.setting
    assert_same Current.setting, Current.setting
  ensure
    Current.reset
  end
end
