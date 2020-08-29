# typed: false
class PbiDevelopmentsController < ApplicationController
  def create
    StartPbiDevelopmentUsecase.perform(feature_id)

    @feature = PbiQuery.call(feature_id.to_s)
    flash.now[:notice] = feedback_message('feature.start_development')
    render :show
  end

  def destroy
    AbortPbiDevelopmentUsecase.perform(feature_id)

    @feature = PbiQuery.call(feature_id.to_s)
    flash.now[:notice] = feedback_message('feature.abort_development')
    render :show
  end

  private

  def feature_id
    @__feature_id ||= Pbi::Id.from_string(params[:id])
  end
end
