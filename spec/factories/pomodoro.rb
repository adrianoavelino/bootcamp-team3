FactoryBot.define do
  factory :pomodoro do
    status { :finished }
    date { Time.now }
    task
  end
end
