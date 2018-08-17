FactoryBot.define do
  factory :auction do
    sequence(:title) { |n| "title #{n}" }
    sequence(:description) { |n| "data or computer instructions #{n}" }
    user
  end
end
