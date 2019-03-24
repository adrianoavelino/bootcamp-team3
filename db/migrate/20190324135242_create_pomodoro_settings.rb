class CreatePomodoroSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :pomodoro_settings do |t|
      t.references :user, foreign_key: true
      t.integer :duration
      t.integer :short_break
      t.integer :long_break

      t.timestamps
    end
  end
end
