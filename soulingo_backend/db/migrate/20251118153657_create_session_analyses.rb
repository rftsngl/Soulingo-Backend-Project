class CreateSessionAnalyses < ActiveRecord::Migration[8.0]
  def change
    create_table :session_analyses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.integer :overall_score
      t.integer :fluency_score
      t.integer :grammar_score
      t.integer :pronunciation_score
      t.text :feedback_text
      t.string :recorded_video_url
      t.text :raw_transcript
      t.datetime :session_started_at
      t.datetime :session_ended_at

      t.timestamps
    end

    add_index :session_analyses, [:user_id, :lesson_id]
  end
end
