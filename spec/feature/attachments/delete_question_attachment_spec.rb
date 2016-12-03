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

  it_behaves_like 'Attachment deletable element' do
    given(:stranger) { create(:user) }
    given(:path) { '/questions/1' }
  end
end
