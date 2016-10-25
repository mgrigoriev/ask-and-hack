require_relative '../feature_helper'

feature 'Delete question', %q{
  In order to remove my question from website
  As Author of the question
  I want to delete the question 
} do 

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Author deletes the question' do
    sign_in(question.user)
    visit question_path(question)
    click_link 'delete'
    expect(page).to have_content 'Question deleted successfully'
    expect(page).to_not have_content question.title
  end

  scenario 'Non-author tries to delete the question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'delete'
  end

  scenario 'Non-authenticated user tries to delete the question' do
    visit question_path(question)
    expect(page).to_not have_link 'delete'
  end  
end