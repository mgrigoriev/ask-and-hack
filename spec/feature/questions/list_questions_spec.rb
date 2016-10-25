require_relative '../feature_helper'

feature 'Browse list of questions', %q{
  In order to find an interesting question
  As User
  I want to be able to browse a list of questions
} do

  scenario 'User sees a list of question' do
    q1 = create(:question)
    q2 = create(:question2)

    visit questions_path
    expect(page).to have_link 'My question title', href: question_path(q1)
    expect(page).to have_link 'The second question title', href: question_path(q2)
  end
end