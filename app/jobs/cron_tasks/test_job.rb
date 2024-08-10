class CronTasks::TestJob < ApplicationJob
  def perform
    Rails.logger.debug "CronTask::TestJob: Hello World!"
  end
end
