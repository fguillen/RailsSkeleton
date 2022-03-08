class Guest::BaseController < ApplicationController
  include ApplicationHelper

  layout "guest/base"

  helper_method :namespace
end
