require_relative '../feature_helper'

feature 'Cancel vote for question', %q{
  In order to have ability to change my vote
  As Authenticated User
  I'd like to cancel my vote to the question
} do
  scenario 'User cancels his vote for the question'
  scenario 'User tries to change other user\'s vote for the question'
  scenario 'Non-authenticated user tries to change someones vote for the question'
end