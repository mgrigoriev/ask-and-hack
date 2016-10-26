require_relative '../feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds files while asking the question', js: true do
    fill_in 'Title', with: 'My question title'
    fill_in 'Description', with: 'My question text'

    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_1.txt"
    end

    click_on 'add file'
    sleep 1

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_2.txt"
    end    

    click_on 'Post Your Question'

    within ".question" do
      expect(page).to have_link 'file_1.txt', href: '/uploads/attachment/file/1/file_1.txt'
      expect(page).to have_link 'file_2.txt', href: '/uploads/attachment/file/2/file_2.txt'
    end
  end
end