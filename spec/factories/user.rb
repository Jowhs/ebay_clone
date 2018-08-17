FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "John#{n}"}
    password '1a1dc91c907325c69271ddf0c944bc72' # 'pass'
  end
end
