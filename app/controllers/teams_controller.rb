# typed: false
class TeamsController < ApplicationController
  def new
    @form = CreateTeamForm.new
  end

  def create
    @form = CreateTeamForm.new(create_params)

    if @form.valid?
      CreateTeamUsecase.perform(
        @form.name,
        current_user.person_id,
        @form.domain_objects[:role]
      )
      redirect_to home_path
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:form).permit(:name, :role)
  end
end
