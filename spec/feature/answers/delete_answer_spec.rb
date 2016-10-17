require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove my answer from website
  As Author of the answer
  I want to delete the answer 
} do 

  given(:question) { create(:question_with_answers) }
  given(:answer) { question.answers.first }
  given(:user) { create(:user) }

  scenario 'Author deletes the answer' do
    sign_in(answer.user)
    visit question_path question
    click_link 'delete answer'
    expect(page).to have_content 'Answer deleted successfully'
  end

  scenario 'Non-author tries to delete the question' do
    sign_in(user)
    visit question_path question
    expect(page).to_not have_link 'delete answer'
  end
  
end