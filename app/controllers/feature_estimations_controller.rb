# typed: false
class FeatureEstimationsController < ApplicationController
  include ProductHelper

  helper_method :can_update_release_plan?

  def update
    issue_id = Issue::Id.from_string(params[:id])
    point = build_point(params[:form][:point])
    EstimateFeatureUsecase.perform(issue_id, point)

    @issue = IssueQuery.call(issue_id)
  end

  private

  def build_point(point)
    point_as_i = point == '?' ? nil : point.to_i
    Issue::StoryPoint.new(point_as_i)
  end

  def current_product_id
    IssueQuery.call(params[:id]).product_id
  end

  def can_update_release_plan?
    current_product_team_member(current_user.person_id)
      .roles
      .can_update_release_plan?
  end
end
