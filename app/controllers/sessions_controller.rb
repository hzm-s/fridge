class SessionsController < ApplicationController
  before_action :require_guest
end
