class Admin::ArticlesFiltersController < Admin::BaseController
  before_action :require_admin_user

  def new
    @articles_filter = ArticlesFilter.new()
  end

  def create
    Rails.logger.info("ArticlesFilterController.create")
    @articles_filter = ArticlesFilter.new(articles_filter_params)

    if @articles_filter.valid?
      render action: :show
    else
      Rails.logger.info("ArticlesFilterController.create. No valid")
      flash.now[:alert] = t("controllers.articles_filter.create.error")
      render action: :new
    end
  end

  protected

  def articles_filter_params
    params.require(:articles_filter).permit(:title, :tags, :tags_mode, :created_at_from, :created_at_to, :front_user_name)
  end
end
