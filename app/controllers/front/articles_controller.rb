class Front::ArticlesController < Front::BaseController
  before_action :load_article, only: [:show, :edit, :update, :destroy]
  before_action :require_front_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :validate_current_front_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.order_by_recent
  end

  def show; end

  def new
    @article = Article.new(front_user: current_front_user)
  end

  def create
    @article = Article.new(article_params)
    @article.front_user = current_front_user

    if @article.save
      redirect_to [:front, @article], notice: t("controllers.articles.create.success")
    else
      flash.now[:alert] = t("controllers.articles.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to [:front, @article], notice: t("controllers.articles.update.success")
    else
      flash.now[:alert] = t("controllers.articles.update.error")
      render action: :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to :front_articles, notice: t("controllers.articles.destroy.success")
  end

  protected

  def article_params
    params.require(:article).permit(:front_user_id, :title, :body, :tag_list, :pic)
  end

  private

  def load_article
    @article = Article.find(params[:id])
  end

  def validate_current_front_user
    if @article.front_user != current_front_user
      redirect_to [:front, @article], alert: t("controllers.front.access_not_authorized")
      false
    end
  end
end
