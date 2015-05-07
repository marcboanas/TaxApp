class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :reset_sent_at, :datetime
    add_column :users, :reset_digest, :string
    add_column :users, :activated_at, :datetime
    add_column :users, :activated, :boolean
    add_column :users, :admin, :boolean
    add_column :users, :activation_digest, :string
    add_column :users, :remember_digest, :string
  end
end
