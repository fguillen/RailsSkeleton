class Notification::OnNewArticleNotificationService < ApplicationService
  attr_reader :article
  attr_reader :result

  def initialize(article)
    @article = article
    @success = false
    @result = nil
  end

  def perform
    self
    @success = true

    self
  end

  def success?
    @success
  end
end
