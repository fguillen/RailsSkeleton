class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout "application/layout"

  def health
    raise "No DB connection" unless ActiveRecord::Base.connection&.active?

    render :health
  end
end
