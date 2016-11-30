require_relative '../feature_helper'

feature 'Choose the best answer', %q{
  In order to inform other users
  As question author
  I want to choose the best answer to my question
} do


  given(:author)   { create(:user) }
  given(:stranger) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer1) { create(:answer, question: question, body: 'My answer 1', best: true) }
  given!(:answer2) { create(:answer, question: question, body: 'My answer 2') }


  scenario "Author changes the best answer to his question", js: true do
    sign_in(author)
    visit question_path(question)

    within "#answer-#{answer2.id}" do
      click_link 'make best'
      sleep 1
    end

    first_answer = page.find(:css, '.answer', match: :first)
    expect(first_answer.text).to have_content answer2.body
    expect(first_answer.text).to have_content 'best answer'

    within "#answer-#{answer1.id}" do
      expect(page).to_not have_content 'best answer'
    end
  end

  scenario "User tries to change the best answer to other user's question", js: true do
    sign_in(stranger)
    visit question_path(question)
    expect(page).to_not have_link 'make best'
  end
end
