class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.string :name
      t.string :city
      t.string :email
      t.string :company

      t.timestamps null: false
    end
  end
end
