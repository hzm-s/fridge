class TeamMembersController < ApplicationController
  include ProductHelper

  def index
    @invitation = App::TeamMemberInvitation.create_for_product(current_product_id)
  end

  def create
    product_id = Product::Id.from_string(current_product_id)
    role = Team::Role.from_string(params[:role])
    AddTeamMemberUsecase.perform(product_id, current_user.id, role)
  end

  private

  def current_product_id
    params[:product_id]
  end
end
