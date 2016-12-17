ThinkingSphinx::Index.define :comment, with: :active_record do
  #fileds
  indexes body
  indexes user.email, as: :author, sortable: true

  # attributes
  has commentable_id, commentable_type, user_id, created_at, updated_at
  has '3', as: :model_order, type: :integer
end
