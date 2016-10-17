require 'rails_helper'

describe QuestionsController do

  describe 'GET #index' do
    let(:q1) { create(:question) } 
    let(:q2) { create(:question2) }

    before { get :index }

    it 'assigns questions to include q1, q2' do
      expect(assigns(:questions)).to include(q1, q2)
    end

    it 'renders view index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question_with_answers) { create(:question_with_answers) }
    
    before { get :show, params: {id: question_with_answers.id} } 

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq(question_with_answers)
    end

  end

  describe 'GET #new' do
    login_user
    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders view new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves the question to database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question to database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 'renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user
    
    context 'is author' do
      let(:question) { @user.questions.create(title: 'My question title', body: 'My question body') }
      before { question }

      it 'deletes question from database' do
        expect { delete :destroy, params: { id: question.id } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to questions_path
      end
    end

    context 'is not author' do
      let(:question) { create(:user).questions.create(title: 'My question title', body: 'My question body') }
      before { question }

      it 'does not delete question from database' do
        expect { delete :destroy, params: { id: question.id } }.to_not change(Question, :count)
      end
    end
  end
end