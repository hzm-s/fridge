class TeamMembersController < ApplicationController
  include ProductHelper

  before_action :store_referer
  before_action :require_user, only: [:new]

  helper_method :available_team_roles

  def create
    product_id = Product::Id.from_string(current_product_id)
    role = Team::Role.from_string(params[:role])
    AddTeamMemberUsecase.perform(product_id, current_user.id, role)
  rescue Team::InvalidNewMember => e
    @error = t_domain_error(e)
    render :new
  end

  private

  def current_product_id
    params[:product_id]
  end

  def store_referer
    unless signed_in?
      session[:referer] = new_product_team_member_path(product_id: current_product_id)
    end
  end

  def available_team_roles
    Product::Id.from_string(current_product_id)
      .yield_self { |id| ProductRepository::AR.find_by_id(id) }
      .yield_self { |p| p.team.available_roles }
  end
end
