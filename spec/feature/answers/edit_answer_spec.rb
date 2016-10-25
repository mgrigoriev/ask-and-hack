require_relative '../feature_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given(:author)   { create(:user) }
  given(:stranger) { create(:user) }  
  given(:question) { create(:question, user: author) }
  given!(:answer)   { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'edit answer'
    end
  end

  describe 'Authenticated user' do

    scenario 'sees link to Edit', js: true do
      sign_in author
      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      sign_in author
      visit question_path(question)
      within '.answers' do
        click_on 'edit'
        fill_in 'Your Answer', with: 'edited answer'
        click_on 'Save changes'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "tries to edit other user's answer", js: true do
      sign_in stranger
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'edit'
      end          
    end
  end
end