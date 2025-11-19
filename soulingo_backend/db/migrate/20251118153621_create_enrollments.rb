class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.string :status, null: false, default: 'active'
      t.integer :progress_percent, null: false, default: 0
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :enrollments, [:user_id, :course_id], unique: true
    add_index :enrollments, [:course_id, :status]
  end
end
