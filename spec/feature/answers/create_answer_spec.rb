require 'rails_helper'

# Пользователь, находясь на странице вопроса, может написать ответ на вопрос
feature 'Create answer', %q{
  In order to help another user
  As Authenticated User
  I want to create the answer to the question
} do 

  given(:user) { create(:user) }

  scenario 'User creates the answer with valid data' do
    sign_in(user)
    visit question_path(create(:question))
    fill_in 'Your Answer', with: 'My answer to the question'
    click_on 'Submit'
    expect(page).to have_content('My answer to the question')
  end

  scenario 'User creates the answer with invalid data' do
    sign_in(user)
    visit question_path(create(:question))
    click_on 'Submit'
    expect(page).to have_content 'prevented this form from being submited'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(create(:question))
    fill_in 'Your Answer', with: 'My answer to the question'
    click_on 'Submit'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end  

end