require_relative '../feature_helper'

feature 'Signing in', %q{
  In order to ask questions or give answer
  As User
  I want be able to sign in
 } do

  given(:user)       { create(:user) }

  scenario "Existing user tries to sign in" do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Non-existing user try to sign in' do
    user.email = 'wrong@example.com'
    sign_in(user)
    expect(page).to have_content 'Invalid Email or password'
  end
end