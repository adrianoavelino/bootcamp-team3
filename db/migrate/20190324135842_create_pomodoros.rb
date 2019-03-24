class CreatePomodoros < ActiveRecord::Migration[5.2]
  def change
    create_table :pomodoros do |t|
      t.references :task, foreign_key: true
      t.integer :status
      t.datetime :date

      t.timestamps
    end
  end
end
