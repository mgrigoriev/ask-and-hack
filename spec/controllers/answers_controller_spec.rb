require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders view new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:params) do
        {
          answer:      attributes_for(:answer),
          question_id: question.id
        }
      end

      it 'saves the answer to database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'redirects to questions#show view' do
        post :create, params: params
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:params) do
        {
          answer:      attributes_for(:invalid_answer),
          question_id: question.id
        }
      end

      it 'does not save the answer to database' do
        expect { post :create, params: params }.to_not change(Answer, :count)
      end

      it 'renders new view' do
        post :create, params: params
        expect(response).to render_template :new
      end
    end
  end
end
