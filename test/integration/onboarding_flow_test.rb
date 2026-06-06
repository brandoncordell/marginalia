# frozen_string_literal: true

require 'test_helper'

class OnboardingFlowTest < ActionDispatch::IntegrationTest
  test 'an unconfigured instance redirects to the welcome step' do
    reset_onboarding!

    get root_path

    assert_redirected_to onboarding_root_path
    follow_redirect!
    assert_redirected_to onboarding_welcome_path
    follow_redirect!
    assert_response :success
    assert_includes response.body, 'Welcome to Your Library'
  end

  test 'welcome step renders system check' do
    reset_onboarding!

    get onboarding_welcome_path

    assert_response :success
    assert_includes response.body, 'System check'
    assert_includes response.body, 'Get started'
  end

  test 'advancing from welcome moves to account' do
    reset_onboarding!

    patch onboarding_welcome_path

    assert_redirected_to onboarding_account_path
    assert_equal 'account', Setting.instance.onboarding_step
  end

  test 'cannot skip ahead to a step that has not been reached' do
    reset_onboarding!

    get onboarding_library_path

    assert_redirected_to onboarding_welcome_path
  end

  test 'account step renders the admin sign-up form' do
    advance_onboarding_to!('account')

    get onboarding_account_path

    assert_response :success
    assert_includes response.body, 'Create your account'
    assert_includes response.body, 'email_address'
  end

  test 'account form is progressively enhanced to gate the continue button' do
    advance_onboarding_to!('account')

    get onboarding_account_path

    assert_response :success
    # Stimulus form controller is wired onto the form so JS can disable submit.
    assert_select 'form#onboarding-account-form[data-controller=?]', 'form'
    assert_select 'form#onboarding-account-form[data-action*=?]', 'form#refresh'
    # Required attributes give the native (no-JS) baseline and feed checkValidity.
    assert_select 'input[name=?][required]', 'user[first_name]'
    assert_select 'input[name=?][required]', 'user[email_address]'
    assert_select 'input[name=?][required]', 'user[password]'
  end

  test 'account step re-renders with errors for invalid input' do
    advance_onboarding_to!('account')

    patch onboarding_account_path, params: {
      user: valid_account_params.merge(email_address: '', password_confirmation: 'mismatch')
    }

    assert_response :unprocessable_entity
    assert_includes response.body, 'error'
  end

  test 'creating the admin account advances to library and signs the user in' do
    advance_onboarding_to!('account')

    patch onboarding_account_path, params: { user: valid_account_params }

    assert_redirected_to onboarding_library_path
    assert User.exists?(admin: true)
    assert cookies[:session_id].present?
    assert_equal 'library', Setting.instance.onboarding_step
  end

  test 'account step skips ahead when an admin already exists' do
    advance_onboarding_to!('account')
    User.create!(
      valid_account_params.merge(admin: true).merge(
        password: 'password',
        password_confirmation: 'password'
      )
    )

    get onboarding_account_path

    assert_redirected_to onboarding_library_path
  end

  test 'library step renders and advances to import' do
    advance_onboarding_to!('library')

    get onboarding_library_path
    assert_response :success
    assert_includes response.body, 'Library location'

    patch onboarding_library_path

    assert_redirected_to onboarding_import_path
    assert_equal 'import', Setting.instance.onboarding_step
  end

  test 'import step can be skipped' do
    advance_onboarding_to!('import')

    get onboarding_import_path
    assert_response :success
    assert_includes response.body, 'Import from Goodreads'

    patch onboarding_import_path, params: { skip: 'Skip' }

    assert_redirected_to onboarding_completion_path
    assert_equal 'done', Setting.instance.onboarding_step
  end

  test 'completion step finishes onboarding' do
    advance_onboarding_to!('done')

    get onboarding_completion_path
    assert_response :success
    assert_includes response.body, "You're all set"

    post onboarding_completion_path

    assert_redirected_to root_path
    assert_predicate Setting.instance.reload, :onboarding_complete?
  end

  test 'completed instances cannot re-enter the wizard' do
    reset_onboarding!(step: 'done', onboarded: true)

    get onboarding_welcome_path

    assert_redirected_to root_path
  end

  test 'full wizard flow from welcome through completion' do
    reset_onboarding!

    patch onboarding_welcome_path
    follow_redirect!

    patch onboarding_account_path, params: { user: valid_account_params }
    follow_redirect!

    patch onboarding_library_path
    follow_redirect!

    patch onboarding_import_path, params: { skip: 'Skip' }
    follow_redirect!

    post onboarding_completion_path

    assert_redirected_to root_path
    assert_predicate Setting.instance.reload, :onboarding_complete?
    assert_equal 1, User.where(admin: true).count
  end

  test 'stepper only links to steps that have been reached' do
    advance_onboarding_to!('account')

    get onboarding_account_path

    assert_includes response.body, onboarding_welcome_path
    assert_includes response.body, onboarding_account_path
    assert_not_includes response.body, onboarding_import_path
  end

  test 'going back and continuing does not skip steps' do
    advance_onboarding_to!('import')

    get onboarding_library_path

    assert_equal 'library', Setting.instance.onboarding_step

    patch onboarding_library_path

    assert_redirected_to onboarding_import_path
    assert_equal 'import', Setting.instance.onboarding_step

    get onboarding_welcome_path

    assert_equal 'welcome', Setting.instance.onboarding_step

    patch onboarding_welcome_path

    assert_redirected_to onboarding_account_path
    assert_equal 'account', Setting.instance.onboarding_step
  end
end
