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

  scenario 'User adds file while asking the question' do
    fill_in 'Title', with: 'My question title'
    fill_in 'Description', with: 'My question text'
    attach_file 'File', "#{Rails.root}/spec/feature/feature_helper.rb"
    click_on 'Post Your Question'

    within ".question" do
      expect(page).to have_link 'feature_helper.rb', href: '/uploads/attachment/file/1/feature_helper.rb'
    end
  end
end