# typed: false
class MembersController < ApplicationController
  include TeamHelper

  before_action :store_referer
  before_action :require_user, only: [:new]

  helper_method :available_team_roles

  def new
    @form = TeamMemberForm.new
  end

  def create
    @form = TeamMemberForm.new(permitted_params)
    team_id = Team::Id.from_string(params[:team_id])

    if @form.valid? && (error = add_team_member(team_id, @form)).blank?
      redirect_to products_path
    else
      @form.errors.add(:base, error)
      render :new
    end
  end

  private

  def add_team_member(team_id, form)
    AddTeamMemberUsecase.perform(team_id, current_user.person_id, form.domain_objects[:roles])
  rescue Team::InvalidNewMember => e
    t_domain_error(e)
  else
    nil
  end

  def permitted_params
    params.require(:form).permit(roles: [])
  end

  def store_referer
    unless signed_in?
      session[:referer] = new_team_member_path(team_id: params[:team_id])
    end
  end
end
