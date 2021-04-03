# typed: false
class FeatureEstimationsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  def update
    issue_id = Issue::Id.from_string(params[:id])
    point = build_point(params[:form][:point])
    EstimateFeatureUsecase.perform(issue_id, current_team_member_roles, point)

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
end
