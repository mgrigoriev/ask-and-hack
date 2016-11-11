require 'rails_helper'

describe CommentsController do

  describe 'Comments for questions' do
    describe 'POST #create' do
      let(:question) { create(:question) }
      login_user

      context 'with valid attributes' do
        let(:params) do
          {
            comment:     { body: 'My comment' },
            question_id: question.id, format: :js
          }
        end

        it 'saves the comment to database' do
          expect { post :create, params: params }.to change(question.comments.where(user: @user), :count).by(1)
        end

        it 'renders create template' do
          post :create, params: params
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            comment:     { body: ' ' },
            question_id: question.id, format: :js
          }
        end

        it 'does not save the comment to database' do
          expect { post :create, params: params }.to_not change(Comment, :count)
        end

        it 'renders create template' do
          post :create, params: params
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'Comments for answers' do
    describe 'POST #create' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question) }
      login_user

      context 'with valid attributes' do
        let(:params) do
          {
            comment:     { body: 'My comment' },
            answer_id: answer.id, format: :js
          }
        end

        it 'saves the comment to database' do
          expect { post :create, params: params }.to change(answer.comments.where(user: @user), :count).by(1)
        end

        it 'renders create template' do
          post :create, params: params
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            comment:     { body: ' ' },
            answer_id: answer.id, format: :js
          }
        end

        it 'does not save the comment to database' do
          expect { post :create, params: params }.to_not change(Comment, :count)
        end

        it 'renders create template' do
          post :create, params: params
          expect(response).to render_template :create
        end
      end
    end
  end

end
