class ChangeDefaultFioToUsers < ActiveRecord::Migration
  def change
    change_column :users, :fio, :string, :default => ""
  end
end
