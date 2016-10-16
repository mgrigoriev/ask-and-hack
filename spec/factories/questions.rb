FactoryGirl.define do

  factory :question do
    title 'My question title'
    body 'My question body'

    factory :question_with_answers do
      transient do
        answer_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answer_count, question: question)
      end
    end
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
