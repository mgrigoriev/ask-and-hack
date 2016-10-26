require_relative '../feature_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Your Answer', with: 'My answer to the question'

    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_1.txt"
    end

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_2.txt"
    end

    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'file_1.txt', href: '/uploads/attachment/file/1/file_1.txt'
      expect(page).to have_link 'file_2.txt', href: '/uploads/attachment/file/2/file_2.txt'
    end
  end
end