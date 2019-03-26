FactoryBot.define do
  factory :task do
    description { FFaker::Lorem.word }
    status { [0,1].sample }
    date { Time.now }
    category { [1,2].sample }
    user
  end
end
