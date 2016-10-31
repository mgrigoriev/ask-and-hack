require_relative '../feature_helper'

feature 'Vote question', %q{
  In order to express my attitude towards the question
  As Authenticated User
  I'd like to give the question my positive or negative vote
} do
  
  let(:user)         { create(:user) }
  let(:question)     { create(:question) }
  let(:his_question) { create(:question, user: user) }

  scenario 'User votes up the question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("q-vote-up-#{question.id}")
    
    within '.q_rating_val' do
      expect(page).to have_text('1')
    end
  end

  scenario 'User votes down the question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("q-vote-down-#{question.id}")
    
    within '.q_rating_val' do
      expect(page).to have_text('-1')
    end
  end

  scenario 'User votes up and then cancels his vote', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("q-vote-up-#{question.id}")
    sleep 1
    click_on("q-vote-up-#{question.id}")

    within '.q_rating_val' do
      expect(page).to have_text('0')
    end
  end

  scenario 'User votes up and then votes down', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("q-vote-up-#{question.id}")
    sleep 1
    click_on("q-vote-down-#{question.id}")
    
    within '.q_rating_val' do
      expect(page).to have_text('-1')
    end
  end

  scenario 'User tries to vote his own question', js: true do
    sign_in(user)
    visit question_path(his_question)

    click_on("q-vote-up-#{his_question.id}")
    
    expect(page).to have_text("You can't vote for your own post")
  end

  scenario 'Non-authentivated user tries to vote the question', js: true do
    visit question_path(question)

    click_on("q-vote-up-#{question.id}")
    
    expect(page).to have_text("You need to sign in or sign up before continuing")
  end
end