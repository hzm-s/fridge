# typed: false
module ProductHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_product, :current_scrum_team_member_role
  end

  def current_product_id
    raise 'not implemented'
  end

  def current_product
    @__current_product ||= Dao::Product.find_by(id: current_product_id)
  end

  def current_scrum_team
    @__current_scrum_team ||= fetch_scrum_team(current_user.person_id, current_product_id)
  end

  def current_scrum_team_member_role
    @__current_scrum_team_member_role ||= current_scrum_team.role(current_user.person_id.to_s)
  end

  private

  def fetch_scrum_team(person_id, product_id)
    ScrumTeamQuery.call(person_id.to_s, product_id.to_s)
  end
end
