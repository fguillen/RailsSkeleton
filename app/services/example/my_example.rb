class Example::MyExample < ApplicationService
  attr_reader :message
  attr_reader :result

  def initialize(message)
    @message = message
    @success = false
    @result = nil
  end

  def perform
    @result = @message
    @success = true

    self
  end

  def success?
    @success
  end
end
