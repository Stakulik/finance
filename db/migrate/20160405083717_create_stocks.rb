class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string  :name, null: false, limit: 30
      t.integer :amount, default: 0
      t.integer :portfolio_id, null: false

      t.timestamps null: false
    end
  end
end
