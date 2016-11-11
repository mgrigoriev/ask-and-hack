require_relative '../feature_helper'

feature 'Add comment to answer', %q{
  In order to discuss the answer
  As Authenticated User
  I'd like to be able to comment answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:comments_selector) { "#comments-answer-#{answer.id}" }

  scenario 'Unauthenticated user tries to create comment' do
    visit question_path(question)

    expect(page).to_not have_link 'add a comment'
  end

  context 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
      within comments_selector do
        click_link 'add a comment'
      end
    end

    scenario 'with valid data', js: true do
        fill_in 'Your comment', with: 'My comment'
        click_on 'Post Comment'
      within comments_selector do
        expect(page).to have_content 'My comment'
      end
    end

    scenario 'with invalid data', js: true do
      click_on 'Post Comment'
      within comments_selector do
        expect(page).not_to have_content 'My comment'
      end
    end
  end

  context "mulitple sessions" do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
 
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within comments_selector do
          click_link 'add a comment'
          fill_in 'Your comment', with: 'My comment'
          click_on 'Post Comment'
          expect(page).not_to have_content 'My comment'
        end
      end

      Capybara.using_session('guest') do
        within comments_selector do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end
end
