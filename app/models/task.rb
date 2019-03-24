class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :categories, :pomodoros
end
