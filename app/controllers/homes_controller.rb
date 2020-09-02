# typed: false
class HomesController < ApplicationController
  def show
    @development = DevelopmentListQuery.call(current_user.person_id.to_s)
  end
end
