require_relative '../feature_helper'

feature 'Delete file attached to the answer', %q{
  In order to remove wrong attachment
  As Answer's Author
  I'd like to be able to delete file attached to my answer
} do

  given(:user) { create(:user) }
  given(:stranger) { create(:user) }
  given(:question) { create(:question) }  

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your Answer', with: 'My answer to the question'
    attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_1.txt"
    click_on 'Post Your Answer'
  end

  scenario 'User deletes file attached to his answer', js: true do
    within '.attachments' do
      click_on '[x]'
    end
    expect(page).to_not have_link 'file_1.txt', href: '/uploads/attachment/file/1/file_1.txt'
  end

  scenario "User tries to delete file attached to other user's answer", js: true do
    sign_out
    sign_in(stranger)
    visit question_path(question)

    within '.attachments' do
      expect(page).to_not have_link '[x]'
    end
  end
end