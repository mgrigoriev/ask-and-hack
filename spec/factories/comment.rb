FactoryGirl.define do
  factory :question_comment, class: 'Comment' do
    user
    association :commentable, factory: :question
    body "My comment to question"
  end

  factory :answer_comment, class: 'Comment' do
    user
    association :commentable, factory: :answer
    body "My comment to answer"
  end
end
