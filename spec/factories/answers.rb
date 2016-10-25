FactoryGirl.define do
  factory :answer do
    user
    question
    body "My answer text"
    best false
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
