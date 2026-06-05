# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :settings do |t|
      t.timestamps

      # Onboarding
      t.datetime :onboarded_at
      t.string :onboarding_step, null: false, default: 'welcome'

      # System information
      t.string :operating_system, null: false
      t.boolean :docker, null: false, default: false
    end
  end
end
