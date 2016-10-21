require_relative '../feature_helper'

feature 'Edit answer', %q{
  In order to fix mistakes
  As Author
  I want to be able to edit the answer
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) } 
  
end