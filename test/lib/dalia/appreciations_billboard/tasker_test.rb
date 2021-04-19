require "test_helper"

class TaskerTest < ActiveSupport::TestCase
  def test_invoke
    ScrapStats::ScrapStats::Tasker.expects(:method_name).returns("RESULT")
    assert_equal("RESULT", ScrapStats::ScrapStats::Tasker.invoke(:method_name))
  end
end
