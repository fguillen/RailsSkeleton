class Admin::ArticlesController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.order_by_recent.page(params[:page]).per(10)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to [:admin, @article], notice: t("controllers.articles.create.success")
    else
      flash.now[:alert] = t("controllers.articles.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to [:admin, @article], notice: t("controllers.articles.update.success")
    else
      flash.now[:alert] = t("controllers.articles.update.error")
      render action: :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to :admin_articles, notice: t("controllers.articles.destroy.success")
  end

  protected

  def article_params
    params.require(:article).permit(:front_user_id, :title, :body)
  end

  private

  def load_article
    @article = Article.find(params[:id])
  end
end
