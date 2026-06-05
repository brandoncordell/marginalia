# frozen_string_literal: true

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  test '#advance! moves to the next step in order' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false, onboarding_step: 'welcome')

    assert_equal 'account', setting.advance!
    assert_equal 'account', setting.onboarding_step
  end

  test '#advance! walks the full active sequence' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false, onboarding_step: 'welcome')

    Setting::ONBOARDING_STEPS[1..].each do |expected|
      assert_equal expected, setting.advance!
    end

    assert_nil setting.advance!
    assert_equal 'done', setting.onboarding_step
  end

  test '#advance! returns nil at the final step' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false, onboarding_step: 'done')

    assert_nil setting.advance!
    assert_equal 'done', setting.onboarding_step
  end

  test '#advance! uses the given step, not the stored furthest step' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false, onboarding_step: 'import')

    assert_equal 'account', setting.advance!(from: 'welcome')
    assert_equal 'account', setting.onboarding_step
  end

  test '#retreat! rewinds when revisiting an earlier step' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false, onboarding_step: 'import')

    setting.retreat!(from: 'library')

    assert_equal 'library', setting.onboarding_step
  end

  test '#retreat! is a no-op when already at or before the target step' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false, onboarding_step: 'library')

    setting.retreat!(from: 'library')
    setting.retreat!(from: 'import')

    assert_equal 'library', setting.onboarding_step
  end

  test '#furthest_index reflects the current onboarding step' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false, onboarding_step: 'import')

    assert_equal Setting::ONBOARDING_STEPS.index('import'), setting.furthest_index
  end

  test '#onboarding_complete? reflects onboarded_at' do
    setting = Setting.create!(operating_system: 'darwin/arm64', docker: false)

    assert_not setting.onboarding_complete?

    setting.update!(onboarded_at: Time.current)

    assert_predicate setting, :onboarding_complete?
  end
end
