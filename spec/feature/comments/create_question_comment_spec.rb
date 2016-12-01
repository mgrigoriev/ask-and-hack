require_relative '../feature_helper'

feature 'Add comment to questiion', %q{
  In order to discuss the question
  As Authenticated User
  I'd like to be able to comment question
} do

  it_behaves_like 'Commentable element' do
    given(:user) { create(:user) }
    given!(:question) { create(:question) }
    given(:comments_selector) { "#comments-question-#{question.id}" }
  end
end
