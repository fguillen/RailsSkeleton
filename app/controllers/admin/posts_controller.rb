class Admin::PostsController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.order_by_recent
  end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to [:admin, @post], notice: t("controllers.posts.create.success")
    else
      flash.now[:alert] = t("controllers.posts.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    Rails.logger.debug "params: #{post_params.inspect}"
    if @post.update(post_params)
      redirect_to [:admin, @post], notice: t("controllers.posts.update.success")
    else
      flash.now[:alert] = t("controllers.posts.update.error")
      render action: :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to :admin_posts, notice: t("controllers.posts.destroy.success")
  end

  protected

  def post_params
    params.require(:post).permit(:front_user_id, :title, :body)
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end
end
