FactoryBot.define do
  factory :bid do
    sequence(:amount) { |n| 1000 + (n*100) }
    auction
    user
  end
end
