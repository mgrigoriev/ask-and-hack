shared_examples_for 'Comments' do
  context 'with valid attributes' do
    it 'saves the comment to database' do
      expect { post :create, params: params }.to change(commentable.comments.where(user: @user), :count).by(1)
    end

    it 'renders create template' do
      post :create, params: params
      expect(response).to render_template :create
    end
  end

  context 'with invalid attributes' do
    it 'does not save the comment to database' do
      expect { post :create, params: params.merge(comment: { body: nil}) }.to_not change(Comment, :count)
    end

    it 'renders create template' do
      post :create, params: params
      expect(response).to render_template :create
    end
  end
end
