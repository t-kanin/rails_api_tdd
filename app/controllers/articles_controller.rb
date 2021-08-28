class ArticlesController < ApplicationController 

  before_action :set_article, only: [:show]

  def index 
    articles = Article.recent
    paginated = paginator.call(
      articles, 
      params: pagination_params, 
      base_url: request.url
    ) 
    render json: serializer.new(paginated.items)
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

  def paginator 
    JSOM::Pagination::Paginator.new
  end 

  def pagination_params
    params.permit[:page]
  end 

end 