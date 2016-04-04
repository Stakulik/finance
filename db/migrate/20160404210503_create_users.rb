class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fio, null: false, limit: 30
      t.string :email, null: false, limit: 20
      t.string :phone, limit: 20

      t.timestamps null: false
    end
  end
end
