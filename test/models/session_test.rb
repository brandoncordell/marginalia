# frozen_string_literal: true

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  test 'belongs to a user' do
    session = users(:one).sessions.create!
    assert_equal users(:one), session.user
  end

  test 'is invalid without a user' do
    session = Session.new
    assert_not session.valid?
  end
end
