require "test_helper"

class Admin::LogBookEventsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    LogBook.muted = true
    post = FactoryBot.create(:post)
    LogBook.muted = false

    log_book_event_1 = FactoryBot.create(:log_book_event, historizable: post)
    log_book_event_2 = FactoryBot.create(:log_book_event, historizable: post)

    get :index

    assert_template "admin/log_book_events/index"
    assert_primary_keys([log_book_event_2, log_book_event_1], assigns(:log_book_events))
  end
end
