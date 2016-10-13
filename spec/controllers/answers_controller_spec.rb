require 'rails_helper'
require 'pp'

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
          answer:      attributes_for(:answer).merge( { question_id: question.id } ), 
          question_id: question.id
        }
      end

      it 'saves the answer to database' do
        expect { post :create, params: params }.to change(Answer, :count).by(1)
      end

      # Предполагается, что после добавления ответа — редирект на страницу вопроса (со списком ответов)
      it 'redirects to questions#show view' do
        post :create, params: params
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do 
      let(:params) do
        { 
          answer:      attributes_for(:invalid_answer).merge( { question_id: question.id } ), 
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
