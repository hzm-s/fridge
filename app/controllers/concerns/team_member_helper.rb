# typed: false
module TeamMemberHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_team_member, :current_team_member_roles,
      :can_update_release_plan?, :can_estimate_issue?
  end

  def current_team_member
    @__current_team_member = fetch_current_team_member
  end

  def current_team_member_roles
    current_team_member.roles
  end

  def can_update_release_plan?
    current_team_member_roles.can_update_release_plan?
  end

  def can_estimate_issue?
    current_team_member_roles.can_estimate_issue?
  end

  private

  def fetch_current_team_member
    raise 'current_user not implemented' unless respond_to?(:current_user, true)
    raise 'current_product_id not implemented' unless respond_to?(:current_product_id, true)

    TeamMemberQuery.call(current_product_id.to_s, current_user.person_id.to_s)
  end
end
