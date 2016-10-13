FactoryGirl.define do
  factory :question do
    title "My question title"
    body "My question body"
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
