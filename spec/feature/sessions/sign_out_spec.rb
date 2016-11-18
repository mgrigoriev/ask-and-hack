require_relative '../feature_helper'

feature 'Signing out', %q{
  In order to close session
  As User
  I want be able to sign out
 } do

  given(:user) { create(:user) }
  background { sign_in(user) }

  scenario "Sign out" do
    expect(page).to have_link 'Log out'
    click_on 'Log out'
    expect(page).to have_link 'Log in'
    expect(page).to_not have_link 'Log out'
  end
end
