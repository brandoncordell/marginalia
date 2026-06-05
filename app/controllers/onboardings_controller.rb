# frozen_string_literal: true

# First-run wizard. Single-page-feeling flow driven by `?step=`, but every step
# persists to `Setting.instance` (and creates the admin User) immediately, so the
# DB — not the session — is the source of truth. Refreshes and back/forward are safe.
#
#   GET   /onboarding?step=account|library|metadata|import|done   -> show that step
#   PATCH /onboarding        (step + fields in the body)          -> save it, advance
#
# Steps render inside a "onboarding" Turbo Frame, so advancing swaps just the frame.
class OnboardingsController < ApplicationController
  ONBOARDING_STEPS = Setting::ONBOARDING_STEPS

  allow_unauthenticated_access

  skip_before_action :check_onboarding_state
  before_action :load_settings
  before_action :redirect_if_complete

  def show
    @step  = view_step
    @user  = User.new
  end

  def update
    # Final step just stamps completion and drops you into the app.
    if step_param == 'done'
      @settings.update!(onboarded_at: Time.current)
      return redirect_to root_path # full-page (form targets _top)
    end

    if process_step
      redirect_to setup_path(step: next_step(step_param))
    else
      @step = step_param
      render :show, status: :unprocessable_content
    end
  end

  private

  def load_settings
    @settings = Setting.instance
  end

  def redirect_if_complete
    redirect_to root_path if @settings.onboarding_complete?
  end

  # --- which step to render -------------------------------------------------

  # Honor ?step= but never let it jump ahead of real progress; default to the
  # furthest step reached.
  def view_step
    requested = ONBOARDING_STEPS.include?(params[:step]) ? params[:step] : @settings.onboarding_step
    ONBOARDING_STEPS[[ONBOARDING_STEPS.index(requested), @settings.furthest_index].min]
  end

  def step_param
    ONBOARDING_STEPS.include?(params[:step]) ? params[:step] : @settings.onboarding_step
  end

  def next_step(step)
    ONBOARDING_STEPS[ONBOARDING_STEPS.index(step) + 1] || 'done'
  end

  # --- per-step handlers ----------------------------------------------------
  # Each returns true on success (and advances the onboarding) or false to re-render
  # the current step with errors.

  def process_step
    case step_param
    when 'account'  then save_account
    when 'library'  then save_library
    when 'metadata' then save_metadata
    when 'import'   then save_import
    else false
    end
  end

  def save_account
    @user = User.new(account_params)
    return false unless @user.save

    start_new_session_for(@user) # sign the admin in for the rest of the wizard
    @settings.advance_to('library')
    true
  end

  def save_library
    @settings.assign_attributes(library_params)
    # TODO: verify the directory exists and is writable; if not,
    #   @settings.errors.add(:library_path, "isn't writable") and return false
    return false unless @settings.save

    @settings.advance_to('metadata')
    true
  end

  def save_metadata
    @settings.assign_attributes(metadata_params)
    # TODO: ping the provider with the token to confirm it works before advancing.
    return false unless @settings.save

    @settings.advance_to('import')
    true
  end

  def save_import
    # Optional step. Skip, or hand the upload to a background job.
    if (file = params.dig(:setting, :goodreads_csv)).present?
      # TODO: ImportGoodreadsJob.perform_later(stored_path_for(file))
    end
    @settings.advance_to('done')
    true
  end

  # --- strong params --------------------------------------------------------

  def account_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end

  def library_params
    params.require(:setting).permit(:library_path)
  end

  def metadata_params
    params.require(:setting).permit(:metadata_provider, :metadata_api_token)
  end
end
