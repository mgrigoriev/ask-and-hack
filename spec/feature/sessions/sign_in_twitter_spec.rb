require_relative '../feature_helper'

feature 'Signing in using Twitter account', %q{
  In order to ask questions or give answer without long sign up
  As User
  I want be able to sign in using my Twitter account
 } do

  background { visit new_user_session_path }

  scenario "Twitter user tries to sign in, log out and sign in again" do
    mock_auth_hash
    clear_emails
    click_link 'Sign in with Twitter'

    fill_in 'email', with: 'test@example.com'
    click_button 'Save E-mail'
    expect(page).to have_content 'You will receive an email with instructions for how to confirm your email address in a few minutes'

    open_email('test@example.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Successfully authenticated from Twitter account'

    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully'

    visit user_twitter_omniauth_authorize_path
    expect(page).to have_content 'Successfully authenticated from Twitter account'
  end

  scenario "Twitter user tries to sign in with invalid credentials" do
    mock_auth_invalid_hash
    click_link 'Sign in with Twitter'
    expect(page).to have_content('Could not authenticate you from Twitter because "Credentials are invalid"')
  end
end
