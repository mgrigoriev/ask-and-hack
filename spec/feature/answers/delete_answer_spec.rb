require_relative '../feature_helper'

feature 'Delete answer', %q{
  In order to remove my answer from website
  As Author of the answer
  I want to delete the answer 
} do 

  given(:author)   { create(:user) }
  given(:stranger) { create(:user) }  
  given(:question) { create(:question, user: author) }
  given(:answer)   { create(:answer, question: question, user: author) }

  scenario 'Author deletes the answer' do
    sign_in(answer.user)
    visit question_path(answer.question)
    click_link 'delete answer'
    expect(page).to have_content 'Answer deleted successfully'
    expect(page).to_not have_content answer.body
  end

  scenario 'Non-author tries to delete the answer' do
    sign_in(stranger)
    visit question_path answer.question
    expect(page).to_not have_link 'delete answer'
  end

  scenario 'Non-authenticated user tries to delete the answer' do
    visit question_path answer.question
    expect(page).to_not have_link 'delete answer'
  end
end