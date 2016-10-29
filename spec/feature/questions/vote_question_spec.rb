require_relative '../feature_helper'

feature 'Vote question', %q{
  In order to express my attitude towards the question
  As Authenticated User
  I'd like to give the question my positive or negative vote
} do
  
  let(:user)         { create(:user) }
  let(:question)     { create(:question) }
  let(:his_question) { create(:question, user: user) }

  scenario 'User gives a positive vote to the question' do
    sign_in(user)
    visit question_path(question)
    expect('.rating-question').to have_text('0')

    click_on('.vote_up')
    
    expect('.rating-question').to have_text('1')
  end

  scenario 'User gives a negative vote to the question'
  scenario 'User tries to vote twice'
  scenario 'User tries to vote his own question'
  scenario 'Non-authentivated user tries to vote the question'
end