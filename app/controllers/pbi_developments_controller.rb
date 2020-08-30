# typed: false
class PbiDevelopmentsController < ApplicationController
  def create
    StartPbiDevelopmentUsecase.perform(pbi_id)

    @pbi = PbiQuery.call(pbi_id.to_s)
    flash.now[:notice] = feedback_message('pbi.start_development')
    render :show
  end

  def destroy
    AbortPbiDevelopmentUsecase.perform(pbi_id)

    @pbi = PbiQuery.call(pbi_id.to_s)
    flash.now[:notice] = feedback_message('pbi.abort_development')
    render :show
  end

  private

  def pbi_id
    @__pbi_id ||= Pbi::Id.from_string(params[:id])
  end
end
