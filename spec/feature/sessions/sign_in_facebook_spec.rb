require_relative '../feature_helper'

feature 'Signing in using facebook account', %q{
  In order to ask questions or give answer without long sign up
  As User
  I want be able to sign in using my facebook account
 } do

  background { visit new_user_session_path }

  scenario "Facebook user tries to sign in" do
    mock_auth_hash
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Successfully authenticated from Facebook account')
  end

  scenario "Facebook user tries to sign in with invalid credentials" do
    mock_auth_invalid_hash
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Could not authenticate you from Facebook because "Credentials are invalid"')
  end
end
