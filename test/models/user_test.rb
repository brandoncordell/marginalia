# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'downcases and strips email_address' do
    user = User.new(email_address: '  DOWNCASED@EXAMPLE.COM  ')
    assert_equal 'downcased@example.com', user.email_address
  end

  test 'requires a password to be set' do
    user = User.new(email_address: 'nopass@example.com', first_name: 'No', last_name: 'Pass')
    assert_not user.save, 'expected user without a password to be invalid'
  end

  test 'requires a first and last name' do
    user = User.new(email_address: 'noname@example.com', password: 'password')
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :first_name
    assert_includes user.errors.attribute_names, :last_name
  end

  test 'persists with a digested (not plaintext) password' do
    user = User.create!(
      email_address: 'secure@example.com', password: 'password', first_name: 'Grace', last_name: 'Hopper'
    )
    assert_not_equal 'password', user.password_digest
    assert user.authenticate('password'), 'expected the digest to verify the password'
  end

  test 'full_name joins first and last name' do
    assert_equal 'Ada Lovelace', users(:one).full_name
  end

  test 'full_name strips when one name is blank' do
    assert_equal 'Ada', User.new(first_name: 'Ada', last_name: '').full_name
    assert_equal 'Lovelace', User.new(first_name: '', last_name: 'Lovelace').full_name
  end

  test 'full_name is empty when both names are blank' do
    assert_equal '', User.new(first_name: '', last_name: '').full_name
  end

  test 'initials are the uppercased first letters of each name' do
    assert_equal 'AL', users(:one).initials
  end

  test 'initials uppercase lowercase names' do
    assert_equal 'AL', User.new(first_name: 'ada', last_name: 'lovelace').initials
  end

  test 'initials ignore surrounding whitespace' do
    assert_equal 'AL', User.new(first_name: '  ada  ', last_name: '  lovelace ').initials
  end

  test 'initials take only the first character of a multi-word name' do
    assert_equal 'GH', User.new(first_name: 'Grace Brewster', last_name: 'Hopper').initials
  end

  test 'initials skip a blank name component' do
    assert_equal 'A', User.new(first_name: 'Ada', last_name: '').initials
    assert_equal 'L', User.new(first_name: '', last_name: 'Lovelace').initials
  end

  test 'initials are empty when both names are blank' do
    assert_equal '', User.new(first_name: '', last_name: '').initials
  end

  test 'initials handle a non-ASCII first letter' do
    assert_equal 'ÉØ', User.new(first_name: 'élodie', last_name: 'øredev').initials
  end

  test 'authenticate_by returns the user with correct credentials' do
    user = users(:one)
    assert_equal user, User.authenticate_by(email_address: 'one@example.com', password: 'password')
  end

  test 'authenticate_by returns nil with an incorrect password' do
    assert_nil User.authenticate_by(email_address: 'one@example.com', password: 'wrong')
  end

  test 'authenticate_by normalizes the email address' do
    user = users(:one)
    assert_equal user, User.authenticate_by(email_address: '  ONE@EXAMPLE.COM ', password: 'password')
  end

  test 'destroying a user destroys its sessions' do
    user = users(:one)
    user.sessions.create!
    assert_difference -> { Session.count }, -1 do
      user.destroy
    end
  end
end
