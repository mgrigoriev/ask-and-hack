require 'rails_helper'

# Пользователь, находясь на странице вопроса, может написать ответ на вопрос
feature 'Create answer', %q{
  In order to help another user
  As User
  I want to create the answer to the question
} do 

  background do
    @question = create(:question)
  end

  scenario 'User creates the answer with valid data' do
    visit question_path @question
    fill_in 'Your Answer', with: 'My answer to the question'
    click_on 'Submit'
    expect(page).to have_content('My answer to the question')
  end

  scenario 'User creates the answer with invalid data'
end