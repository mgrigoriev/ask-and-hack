class SearchesController < ApplicationController
  include FulltextSearch

  authorize_resource class: false

  def show
    @results = get_results(params[:query], params[:context]) if params[:query]
  end
end
