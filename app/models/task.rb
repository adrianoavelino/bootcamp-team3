class Task < ApplicationRecord
  belongs_to :user
  has_many :pomodoros, dependent: :destroy

  enum category: {
    work: 1,
    home: 2
  }

  validates :description, :status, :date, :user_id, presence: true
end
