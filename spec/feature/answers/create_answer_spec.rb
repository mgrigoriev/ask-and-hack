require_relative '../feature_helper'

feature 'Create answer', %q{
  In order to help another user
  As Authenticated User
  I want to create the answer to the question
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User creates the answer with valid data', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your Answer', with: 'My answer to the question'
    click_on 'Post Your Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer to the question'
    end
  end

  scenario 'User creates the answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)
    
    fill_in 'Your Answer', with: 'foo' 
    click_on 'Post Your Answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'prevented this form from being submited'
    expect(page).to have_content 'Body is too short'
    within('.answers', visible: false) do
      expect(page).to_not have_content 'foo'
    end
  end

  scenario 'Non-authenticated user tries to create answer', js: true do
    visit question_path(question)
    
    fill_in 'Your Answer', with: 'My answer to the question'
    click_on 'Post Your Answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing'
    within('.answers', visible: false) do
      expect(page).to_not have_content 'My answer to the question'
    end
  end

  context "mulitple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
 
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your Answer', with: 'My answer to the question'
        click_on 'Post Your Answer'
        within '.answers' do
          expect(page).to have_content 'My answer to the question'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'My answer to the question'
        end
      end
    end
  end  
end