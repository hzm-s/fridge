# typed: false
class SprintBacklogsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  private

  def current_product_id
    params[:product_id]
  end
end
