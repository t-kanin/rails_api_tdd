class ArticlesController < ApplicationController 
  include Paginable

  before_action :set_article, only: [:show]

  def index 
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end 

  def show 
  end 

  private 

  def set_article 
    @article = Article.find(params[:id])
  end 

  def serializer
    ArticleSerializer
  end 

end 