FactoryBot.define do
  factory :pomodoro_setting do
    duration { 25 }
    short_break { 5 }
    long_break { 15 }
    user
  end
end
