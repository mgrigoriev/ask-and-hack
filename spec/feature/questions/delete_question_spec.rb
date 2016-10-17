require 'rails_helper'

feature 'Delete question', %q{
  In order to remove my question from website
  As Author of the question
  I want to delete the question 
} do 

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Author deletes the question' do
    sign_in(question.user)
    visit question_path question
    click_link 'delete question'
    expect(page).to have_content 'Question deleted successfully'
  end

  scenario 'Non-author tries to delete the question' do
    sign_in(user)
    visit question_path question
    expect(page).to_not have_link 'Delete'
  end
  
end