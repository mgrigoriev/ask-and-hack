require_relative '../feature_helper'

feature 'Add comment to answer', %q{
  In order to discuss the answer
  As Authenticated User
  I'd like to be able to comment answer
} do

  it_behaves_like 'Commentable element' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }
    given(:comments_selector) { "#comments-answer-#{answer.id}" }
  end
end
