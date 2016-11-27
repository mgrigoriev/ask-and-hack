class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :user_id
end
