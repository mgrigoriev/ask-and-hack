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

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the question to database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end