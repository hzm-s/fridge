# typed: false
module TeamMemberHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_team_member
  end

  def current_team_member(person_id)
    @__current_team_member ||=
      TeamMemberQuery.call(current_product.id.to_s, person_id)
  end
end
