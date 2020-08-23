# typed: false
class FeatureDevelopmentsController < ApplicationController
  def create
    StartFeatureDevelopmentUsecase.perform(feature_id)

    @feature = FeatureQuery.call(feature_id.to_s)
    flash.now[:notice] = feedback_message('feature.start_development')
    render :show
  end

  def destroy
    AbortFeatureDevelopmentUsecase.perform(feature_id)

    @feature = FeatureQuery.call(feature_id.to_s)
    flash.now[:notice] = feedback_message('feature.abort_development')
    render :show
  end

  private

  def feature_id
    @__feature_id ||= Feature::Id.from_string(params[:id])
  end
end
