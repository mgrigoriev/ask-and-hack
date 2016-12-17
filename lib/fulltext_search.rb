module FulltextSearch

  CONTEXTS = ['Questions', 'Answers', 'Comments', 'Users']

  def get_results(query, context)
    query = ThinkingSphinx::Query.escape(query)
    klasses = [context.singularize.constantize] if CONTEXTS.include?(context)
    @results = ThinkingSphinx.search(query, classes: klasses, order: 'model_order ASC') if query.present?
  end
end
