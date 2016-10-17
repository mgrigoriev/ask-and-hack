require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As User
  I want to be able to ask questions
} do

  background do
    visit questions_path  
    click_on 'Ask question'
  end

  scenario 'User creates question with valid data' do
    fill_in 'Title', with: 'My question title'
    fill_in 'Description', with: 'My question body'
    click_on 'Submit'

    expect(page).to have_content 'Question added successfully'
    expect(page).to have_content 'My question title'
    expect(page).to have_content 'My question body'   
    expect(page).to have_current_path(/\/questions\/[0-9]+\/?$/)
  end

  scenario 'User creates question with invalid data' do
    click_on 'Submit'

    expect(page).to have_css '.error_explanation'
    expect(page).to have_css '.field_with_errors'    
  end
  
end
