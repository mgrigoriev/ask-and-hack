require_relative '../feature_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of the question
  I'd like to be able to edit my question
} do

  given(:author)   { create(:user) }
  given(:stranger) { create(:user) }  
  given(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'edit'
    end
  end

  describe 'Authenticated user' do

    scenario 'sees link to Edit', js: true do
      sign_in author
      visit question_path(question)

      within '.question' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'tries to edit his question', js: true do
      sign_in author
      visit question_path(question)
      
      within '.question' do
        click_on 'edit'
        fill_in 'Title', with: 'Edited question title'
        fill_in 'Description', with: 'Edited question body'
        click_on 'Save changes'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body        
        expect(page).to have_content 'Edited question title'
        expect(page).to have_content 'Edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in stranger
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_link 'edit'
      end          
    end
  end
end