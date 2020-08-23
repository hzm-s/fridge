# typed: false
class FeatureDevelopmentsController < ApplicationController
  def create
    StartFeatureDevelopmentUsecase.perform(feature_id)

    @feature = FeatureQuery.call(feature_id.to_s)
    flash.now[:notice] = feedback_message('feature.assigned')
    render :show
  end

  def destroy
    CancelProductBacklogItemAssignmentUsecase.perform(pbi_id)

    @item = ProductBacklogItemQuery.call(pbi_id.to_s)
    flash.now[:notice] = feedback_message('pbi.cancel_assignment')
    render :show
  end

  private

  def feature_id
    @__feature_id ||= Feature::Id.from_string(params[:id])
  end
end
