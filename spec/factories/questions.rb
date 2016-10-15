FactoryGirl.define do
  factory :question do
    title "My question title"
    body "My question body"
  end

  factory :question2, class: Question do
    title "The second question title"
    body "The second question body"
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
