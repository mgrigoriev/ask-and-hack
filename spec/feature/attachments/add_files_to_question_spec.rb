require_relative '../feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  it_behaves_like('Attachable element') do
    given(:user)        { create(:user) }
    given(:path)        { new_question_path }
    given(:field_title) { 'Title' }
    given(:field_body)  { 'Description' }
    given(:submit)      { 'Post Your Question' }
    given(:selector)    { '.question' }
  end
end
