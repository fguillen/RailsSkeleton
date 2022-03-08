class Guest::ArticlesController < Guest::BaseController
  before_action :load_article, only: [:show]

  def index
    @articles = Article.order_by_recent.page(params[:page]).per(10)
  end

  def show; end

  private

  def load_article
    @article = Article.find(params[:id])
  end
end
