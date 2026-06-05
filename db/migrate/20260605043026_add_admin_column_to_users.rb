# frozen_string_literal: true

class AddAdminColumnToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    add_index :users, :admin, unique: true, where: 'admin = 1', name: 'index_users_on_single_admin'
  end
end
