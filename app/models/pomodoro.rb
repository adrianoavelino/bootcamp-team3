class Pomodoro < ApplicationRecord
  belongs_to :task

  enum status: {
    finished: 1,
    canceled: 0
  }
end
