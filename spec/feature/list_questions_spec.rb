require 'rails_helper'

feature 'View list of questions', %q{
  In order to find an interesting question
  As User
  I want to be able to see a list of questions
} do

  scenario 'User sees a list of question' do
    create(:question)
    visit questions_path
    expect(page).to have_content 'List of Questions'
    expect(page).to have_content 'My question title'
  end
end