require_relative '../feature_helper'

feature 'Create question', %q{
  In order to get answer from community
  As Authenticated User
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'User creates question with valid data' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'My question title'
    fill_in 'Description', with: 'My question body'
    click_on 'Post Your Question'

    expect(page).to have_content 'Question added successfully'
    expect(page).to have_content 'My question title'
    expect(page).to have_content 'My question body'
    expect(page).to have_current_path(/\/questions\/[0-9]+\/?$/)
  end

  scenario 'User creates question with invalid data' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    click_on 'Post Your Question'

    expect(page).to have_content 'prevented this form from being submited'
    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  context "mulitple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
 
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'My question title'
        fill_in 'Description', with: 'My question body'
        click_on 'Post Your Question'
        expect(page).to have_content 'My question title'
        expect(page).to have_content 'My question body'
      end

      Capybara.using_session('guest') do
        # puts "Console messages"
        # puts page.driver.console_messages
        expect(page).to have_content 'My question title'
      end
    end
  end
end
