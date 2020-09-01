# typed: false
class HomesController < ApplicationController
  def show
    @teams = TeamListQuery.call(current_user.person_id.to_s)
  end
end
