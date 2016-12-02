require_relative '../feature_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  it_behaves_like('Attachable element') do
    given(:user)        { create(:user) }
    given(:path)        { question_path create(:question) }
    given(:field_title) { '' }
    given(:field_body)  { 'Your Answer' }
    given(:submit)      { 'Post Your Answer' }
    given(:selector)    { '.answers' }
  end
end
