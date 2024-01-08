require "test_helper"

class Example::MyExampleTest < ActiveSupport::TestCase
  def test_perform
    result = Example::MyExample.perform("MESSAGE")

    assert_equal("MESSAGE", result)
  end
end
