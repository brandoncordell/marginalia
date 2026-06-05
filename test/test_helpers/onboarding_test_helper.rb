# frozen_string_literal: true

module OnboardingTestHelper
  def reset_onboarding!(step: 'welcome', onboarded: false)
    User.delete_all
    Setting.delete_all
    Setting.create!(
      operating_system: 'darwin/arm64',
      docker: false,
      onboarding_step: step,
      onboarded_at: onboarded ? Time.current : nil
    )
    Current.reset
  end

  def advance_onboarding_to!(step)
    reset_onboarding!
    until Current.setting.onboarding_step == step
      next_step = Current.setting.advance!
      flunk "could not reach onboarding step #{step}" unless next_step
    end
    Current.reset
  end

  def valid_account_params
    {
      first_name: 'Grace',
      last_name: 'Hopper',
      email_address: 'grace@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include OnboardingTestHelper
end

ActiveSupport.on_load(:action_controller_test_case) do
  include OnboardingTestHelper
end
