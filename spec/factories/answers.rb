FactoryGirl.define do
  factory :answer do
    question
    body "My answer text"
  end

  factory :invalid_answer, class: Answer do
    body nil
  end  
end
