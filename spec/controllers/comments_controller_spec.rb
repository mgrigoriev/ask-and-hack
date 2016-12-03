require 'rails_helper'

describe CommentsController do

  describe 'Comments for questions' do
    describe 'POST #create' do
      login_user

      it_behaves_like 'Comments' do
        let(:commentable) { create(:question) }
        let(:params) { { comment: { body: 'My comment' }, question_id: commentable.id, format: :js } }
      end
    end
  end

  describe 'Comments for answers' do
    describe 'POST #create' do
      login_user

      it_behaves_like 'Comments' do
        let(:commentable) { create(:answer) }
        let(:params) { { comment: { body: 'My comment' }, answer_id: commentable.id, format: :js } }
      end
    end
  end
end
