require_relative '../feature_helper'

feature 'Subscribe question', %q{
  In order to receive new answers by email
  As Authenticated User
  I want to be able to subscribe the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:his_question) { create(:question, user: user) }

  scenario 'Non-authenticated user tries to subscribe or unsubscribe' do
    visit question_path(question)

    expect(page).to_not have_link 'subscribe'
    expect(page).to_not have_link 'unsubscribe'
  end

  context 'Authenticated user' do
    scenario 'User subscribes, receives email and unsubscribes', js: true do
      sign_in(user)
      visit question_path(question)

      click_link 'subscribe'
      clear_emails
      create(:answer, question: question, body: 'Answer 1')
      open_email(user.email)

      expect(current_email).to have_content('Answer 1')

      click_link 'unsubscribe'
      clear_emails
      create(:answer, question: question, body: 'Answer 2')
      open_email(user.email)

      expect(current_email).to be_nil
      expect(page).to_not have_link 'unsubscribe'
      expect(page).to have_link 'subscribe'
    end

    scenario 'Author unsubscribes his question', js: true do
      sign_in(user)
      visit question_path(his_question)

      click_link 'unsubscribe'

      expect(page).to_not have_link 'unsubscribe'
      expect(page).to have_link 'subscribe'
    end
  end
end
