FactoryGirl.define do
  factory :vote do
    votable { |v| v.association(:question) }
    user
    value 1
  end
end
