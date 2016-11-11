require_relative '../feature_helper'

feature 'Delete file attached to the question', %q{
  In order to remove wrong attachment
  As Question's Author
  I'd like to be able to delete file attached to my question
} do

  given(:user) { create(:user) }
  given(:stranger) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'My question title'
    fill_in 'Description', with: 'My question text'
    attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_1.txt"
    click_on 'Post Your Question'
  end

  scenario 'User deletes file attached to his question', js: true do
    within '.attachments' do
      click_on '[x]'
    end
    expect(page).to_not have_link 'file_1.txt', href: '/uploads/attachment/file/1/file_1.txt'
  end

  scenario "User tries to delete file attached to other user's question", js: true do
    sign_out
    sign_in(stranger)
    visit '/questions/1'

    within '.attachments' do
      expect(page).to_not have_link '[x]'
    end
  end
end