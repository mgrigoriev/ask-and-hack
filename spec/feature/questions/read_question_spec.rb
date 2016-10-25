require_relative '../feature_helper'

feature 'Read question and answers', %q{
  In order to find useful information
  As User
  I want to be able to read question and answers
} do

  scenario 'User reads question and answers' do
    question = create(:question_with_answers)
    
    visit question_path question
    expect(page).to have_content question.title
    expect(page).to have_content question.body      
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end