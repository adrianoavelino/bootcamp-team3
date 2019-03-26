class Task < ApplicationRecord
  belongs_to :user
  has_many :pomodoros

  enum category: {
    work: 1,
    home: 2
  }

  validates :description, :status, :category, :date, :user_id, presence: true
end
