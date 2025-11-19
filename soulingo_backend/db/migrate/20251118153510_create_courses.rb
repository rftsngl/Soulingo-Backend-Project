class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :title, null: false, limit: 120
      t.string :language_code, null: false
      t.string :level
      t.text :description
      t.boolean :is_published, null: false, default: false

      t.timestamps
    end

    add_index :courses, :language_code
    add_index :courses, :is_published
  end
end
