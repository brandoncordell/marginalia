# frozen_string_literal: true

require 'test_helper'

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test 'the sign-in page renders' do
    get new_session_path
    assert_response :success
  end

  test 'an unauthenticated request to a protected page redirects to sign-in' do
    get root_path
    assert_redirected_to new_session_path
  end

  test 'signing in with valid credentials starts a session' do
    post session_path, params: { email_address: @user.email_address, password: 'password' }

    assert_redirected_to root_path
    assert cookies[:session_id].present?, 'expected a signed session cookie to be set'
  end

  test 'after signing in the protected page is reachable' do
    post session_path, params: { email_address: @user.email_address, password: 'password' }
    get root_path
    assert_response :success
  end

  test 'the navbar shows the current user and a sign out control when signed in' do
    sign_in_as(@user)
    get root_path

    assert_select 'nav' do
      assert_select 'form[action=?][method=?]', session_path, 'post' do
        assert_select "input[name='_method'][value='delete']", count: 1
      end
    end
    assert_includes response.body, @user.full_name
    assert_includes response.body, @user.initials
  end

  test 'the navbar omits the user menu when signed out' do
    get new_session_path

    assert_select 'form[action=?] input[value=?]', session_path, 'delete', count: 0
  end

  test 'signing in is case/whitespace insensitive on the email' do
    post session_path, params: { email_address: '  ONE@EXAMPLE.COM ', password: 'password' }
    assert_redirected_to root_path
  end

  test 'signing in with invalid credentials does not start a session' do
    post session_path, params: { email_address: @user.email_address, password: 'wrong' }

    assert_redirected_to new_session_path
    assert cookies[:session_id].blank?, 'expected no session cookie on failed sign-in'
  end

  test 'a signed-in user can sign out' do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to new_session_path
    assert cookies[:session_id].blank?, 'expected the session cookie to be cleared'
  end

  test 'after signing out protected pages redirect to sign-in again' do
    sign_in_as(@user)
    delete session_path

    get root_path
    assert_redirected_to new_session_path
  end
end
