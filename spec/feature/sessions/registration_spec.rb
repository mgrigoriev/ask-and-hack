require_relative '../feature_helper'

feature 'Registration (sign up)', %q{
  In order to have an ability to ask questions and give answers
  As User
  I want be able to register
 } do

  background { visit new_user_registration_path }

  scenario "User signs up with valid data" do
    fill_in 'Email', with: 'new@example.com'    
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'You have signed up successfully'
  end

  scenario 'User signs up with invalid data' do
    click_on 'Sign up'
    expect(page).to_not have_content 'You have signed up successfully'
    expect(page).to have_css '.field_with_errors'
  end
end