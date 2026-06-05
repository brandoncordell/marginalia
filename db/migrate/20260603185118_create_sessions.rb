# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions do |t|
      t.timestamps

      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent
    end
  end
end
