require 'rails_helper'

describe AnswersController do

  describe 'POST #create' do
    let(:question) { create(:question) }
    login_user

    context 'with valid attributes' do
      let(:params) do
        {
          answer:      attributes_for(:answer),
          question_id: question.id,
          format: :js
        }
      end

      it 'saves the answer to database' do
        expect { post :create, params: params }.to change(question.answers.where(user: @user), :count).by(1)
      end

      it 'renders create template' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:params) do
        {
          answer:      attributes_for(:invalid_answer),
          question_id: question.id,
          format: :js
        }
      end

      it 'does not save the answer to database' do
        expect { post :create, params: params }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    login_user

    context 'is author' do
      let(:question) { @user.questions.create(title: 'My question title', body: 'My question body') }
      let(:answer)   { question.answers.create(body: 'My answer body', user_id: @user.id) }
      let(:params) do
        {
          id:          answer.id,
          answer:      { body: 'New answer body' },
          format: :js
        }
      end

      it 'assings the requested answer to @answer' do
        patch :update, params: params
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: params
        answer.reload
        expect(answer.body).to eq 'New answer body'
      end

      it 'renders update template' do
        patch :update, params: params
        expect(response).to render_template :update
      end
    end

    context 'is not author' do
      let(:user)     { create(:user) } 
      let(:question) { user.questions.create(title: 'My question title', body: 'My question body') }
      let!(:answer)   { question.answers.create(body: 'My answer body', user_id: user.id) }
      let(:params) do
        {
          id:          answer.id,
          answer:      { body: 'New answer body' },
          format: :js
        }
      end

      it 'does not change answer attributes' do
        patch :update, params: params
        answer.reload
        expect(answer.body).to_not eq 'New answer body'
      end
    end    
  end

  describe 'DELETE #destroy' do
    login_user
    
    context 'is author' do
      let(:question) { @user.questions.create(title: 'My question title', body: 'My question body') }
      let!(:answer)   { question.answers.create(body: 'My answer body', user_id: @user.id) }

      it 'deletes answer from database' do
        expect { delete :destroy, params: { id: answer.id, format: :js } }.to change(question.answers, :count).by(-1)
      end

      it 'renders delete template' do
        delete :destroy, params: { id: answer.id, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'is not author' do
      let(:user)     { create(:user) } 
      let(:question) { user.questions.create(title: 'My question title', body: 'My question body') }
      let!(:answer)   { question.answers.create(body: 'My answer body', user_id: user.id) }

      it 'does not delete answer from database' do
        expect { delete :destroy, params: { id: answer.id, format: :js } }.to_not change(Answer, :count)
      end
    end
  end
end
