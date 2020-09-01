# typed: false
class TeamsController < ApplicationController
  def create
    form = TeamForm.new(permitted_params)

    form.valid?
    CreateTeamUsecase.perform(
      form.name,
      current_user.person_id,
      form.domain_objects[:role]
    )

    redirect_to home_path
  end

  private

  def permitted_params
    params.require(:form).permit(:name, :role)
  end
end
