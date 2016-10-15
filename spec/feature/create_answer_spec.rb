require 'rails_helper'

# Пользователь, находясь на странице вопроса, может написать ответ на вопрос
feature 'Create answer', %q{
  In order to help another user
  As User
  I want to create the answer to the question
} do 

  scenario 'User creates the answer with valid data'
  scenario 'User creates the answer with invalid data'
end