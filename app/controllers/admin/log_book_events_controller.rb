class Admin::LogBookEventsController < Admin::BaseController
  before_action :require_admin_user

  def index
    @log_book_events = LogBook::Event.by_recent
  end
end
