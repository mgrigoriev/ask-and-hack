require_relative '../feature_helper'

feature 'Delete answer', %q{
  In order to remove my answer from website
  As Author of the answer
  I want to delete the answer 
} do 

  given(:author)   { create(:user) }
  given(:stranger) { create(:user) }  
  given(:question) { create(:question, user: author) }
  given!(:answer)   { create(:answer, question: question, user: author) }

  scenario 'Author deletes the answer', js: true do
    sign_in(answer.user)
    visit question_path(question)
    within '.answers' do
      click_link 'delete'
      page.evaluate_script('window.confirm = function() { return true; }')
      expect(page).to_not have_content('My answer text')
    end
  end

  scenario 'Non-author tries to delete the answer' do
    sign_in(stranger)
    visit question_path answer.question
    within '.answers' do
      expect(page).to_not have_link 'delete'
    end
  end

  scenario 'Non-authenticated user tries to delete the answer' do
    visit question_path answer.question
    within '.answers' do
      expect(page).to_not have_link 'delete'
    end
  end
end