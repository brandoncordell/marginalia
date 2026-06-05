# frozen_string_literal: true

# Disabled until metadata provider settings are added to +Setting+.
#
# module Onboarding
#   class MetadataController < BaseController
#     STEP = 'metadata'
#
#     def show; end
#
#     def update
#       Current.setting.assign_attributes(metadata_params)
#
#       if Current.setting.save
#         advance_and_redirect!
#       else
#         render :show, status: :unprocessable_content
#       end
#     end
#
#     private
#
#     def metadata_params
#       params.expect(setting: %i[metadata_provider metadata_api_token])
#     end
#   end
# end
