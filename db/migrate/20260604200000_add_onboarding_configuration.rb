# frozen_string_literal: true

class AddOnboardingConfiguration < ActiveRecord::Migration[8.1]
  def change
    change_table :settings, bulk: true do |t|
      t.string :library_path
      t.string :metadata_provider, null: false, default: 'open_library'
      t.string :metadata_api_token
    end
  end
end
