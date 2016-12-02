require_relative '../feature_helper'

feature 'Delete file attached to the answer', %q{
  In order to remove wrong attachment
  As Answer's Author
  I'd like to be able to delete file attached to my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your Answer', with: 'My answer to the question'
    attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_1.txt"
    click_on 'Post Your Answer'
  end

  it_behaves_like 'Attachment deletable element' do
    given(:stranger) { create(:user) }
    given(:path) { question_path(question) }
  end
end
