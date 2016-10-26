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
    attach_file 'File', "#{Rails.root}/spec/feature/feature_helper.rb"
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'feature_helper.rb', href: '/uploads/attachment/file/1/feature_helper.rb'
    end
  end
end