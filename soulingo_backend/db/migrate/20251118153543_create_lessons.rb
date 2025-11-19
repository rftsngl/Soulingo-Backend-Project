class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :order_index, null: false
      t.text :description
      t.string :video_url
      t.integer :expected_duration_minutes

      t.timestamps
    end

    add_index :lessons, [:course_id, :order_index]
  end
end
