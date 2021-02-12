# typed: false
module ProductHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_product, :current_team_member
  end

  def current_product_id
    raise 'not implemented'
  end

  def current_product
    @__current_product ||= Dao::Product.find_by(id: current_product_id)
  end
end
