require 'rails_helper'

feature 'create question', %q{
  In order to get answer from community
  As User
  I want to be able to ask questions
} do

  scenario 'User creates question' do
    visit questions_path
    
    click_on 'Ask question'
    fill_in 'Title', with: 'My question title'
    fill_in 'Description', with: 'My question body'
    click_on 'Submit'

    expect(page).to have_content 'Question added successfully'
    expect(page).to have_content 'My question title'
    expect(page).to have_content 'My question body'   
    expect(path).to have_current_path(/\/question\/[0-9]+/) 
  end
  
end
