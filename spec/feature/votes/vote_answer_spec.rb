require_relative '../feature_helper'

feature 'Vote answer', %q{
  In order to express my attitude towards the answer
  As Authenticated User
  I'd like to give the answer my positive or negative vote
} do

  let(:user)     { create(:user) }
  let(:question) { create(:question) }
  let!(:answer)  { create(:answer, question: question) }

  let(:other_question) { create(:question) }
  let!(:his_answer)    { create(:answer, question: other_question, user: user) }

  scenario 'User votes up the answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("a-vote-up-#{answer.id}")

    within '.a_rating_val' do
      expect(page).to have_text('1')
    end
  end

  scenario 'User votes down the answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("a-vote-down-#{answer.id}")

    within '.a_rating_val' do
      expect(page).to have_text('-1')
    end
  end

  scenario 'User votes up and then cancels his vote', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("a-vote-up-#{answer.id}")
    sleep 1
    click_on("a-vote-up-#{answer.id}")

    within '.a_rating_val' do
      expect(page).to have_text('0')
    end
  end

  scenario 'User votes up and then votes down', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("a-vote-down-#{answer.id}")
    sleep 1
    click_on("a-vote-down-#{answer.id}")

    within '.a_rating_val' do
      expect(page).to have_text('-1')
    end
  end

  scenario 'User tries to vote his own answer', js: true do
    sign_in(user)
    visit question_path(other_question)

    click_on("a-vote-up-#{his_answer.id}")

    expect(page).to have_text("You can't vote for your own post")
  end

  scenario 'Non-authentivated user tries to vote the question', js: true do
    visit question_path(question)

    click_on("a-vote-up-#{answer.id}")

    expect(page).to have_text("You need to sign in or sign up before continuing")
  end
end
