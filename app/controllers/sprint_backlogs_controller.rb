# typed: false
class SprintBacklogsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  def show
    @sprint = SprintRepository::AR.current(Product::Id.from_string(current_product_id))
  end

  private

  def current_product_id
    params[:product_id]
  end
end
