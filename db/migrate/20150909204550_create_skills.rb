class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :coaches_skills, id: false do |t|
      t.belongs_to :coach, index: true
      t.belongs_to :skill, index: true
    end
  end
end
