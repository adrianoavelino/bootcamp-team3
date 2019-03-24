class Task < ApplicationRecord
  belongs_to :user
  has_many :pomodoros

  enum category: [:work, :home]
end
