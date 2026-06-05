# frozen_string_literal: true

module Onboarding
  # Account step controller for the onboarding wizard.
  class AccountsController < BaseController
    STEP = 'account'

    def show
      redirect_to Steps.path_for(Steps.next(STEP)) if User.exists?
      @user = User.new
    end

    def update
      redirect_to Steps.path_for(Steps.next(STEP)) and return if User.exists?

      @user = User.new(account_params)
      @user.admin = true

      if @user.save
        start_new_session_for(@user)
        advance_and_redirect!
      else
        render :show, status: :unprocessable_content
      end
    end

    private

    def account_params
      params.expect(user: %i[first_name last_name email_address password password_confirmation])
    end
  end
end
