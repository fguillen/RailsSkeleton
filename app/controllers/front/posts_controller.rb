class Front::PostsController < Front::BaseController
  before_action :load_post, only: [:show, :edit, :update, :destroy]
  before_action :require_front_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :validate_current_front_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order_by_recent
  end

  def show; end

  def new
    @post = Post.new(front_user: current_front_user)
  end

  def create
    @post = Post.new(post_params)
    @post.front_user = current_front_user

    if @post.save
      redirect_to [:front, @post], notice: t("controllers.posts.create.success")
    else
      flash.now[:alert] = t("controllers.posts.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to [:front, @post], notice: t("controllers.posts.update.success")
    else
      flash.now[:alert] = t("controllers.posts.update.error")
      render action: :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to :front_posts, notice: t("controllers.posts.destroy.success")
  end

  protected

  def post_params
    params.require(:post).permit(:front_user_id, :title, :body, :tag_list)
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end

  def validate_current_front_user
    if @post.front_user != current_front_user
      redirect_to [:front, @post], alert: t("controllers.front.access_not_authorized")
      false
    end
  end
end
