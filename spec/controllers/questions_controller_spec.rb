require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }

  describe 'GET #new' do
    it 'assigns new quastion to @quastion' do
      get :new
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders view new' do
      get :new
      expect(response).to render_template :new
    end
  end
end