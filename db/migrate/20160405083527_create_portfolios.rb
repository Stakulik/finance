class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string  :name, null: false, limit: 30
      t.string  :description, limit: 200
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
