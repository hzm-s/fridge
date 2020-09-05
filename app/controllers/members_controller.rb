# typed: false
class MembersController < ApplicationController
  before_action :store_referer
  before_action :require_user, only: [:new]

  helper_method :available_team_roles

  def create
    team_id = Team::Id.from_string(params[:team_id])
    role = Team::Role.from_string(params[:role])
    AddTeamMemberUsecase.perform(team_id, current_user.person_id, role)
  rescue Team::InvalidRole, Team::InvalidNewMember => e
    @error = t_domain_error(e)
    render :new
  else
    redirect_to products_path
  end

  private

  def store_referer
    unless signed_in?
      session[:referer] = new_team_member_path(team_id: params[:team_id])
    end
  end

  def available_team_roles
    Team::Id.from_string(params[:team_id])
      .yield_self { |id| TeamRepository::AR.find_by_id(id) }
      .yield_self { |t| t.available_roles }
  end
end
