# typed: false
module ProductHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_product
  end

  def current_product
    @__current_product ||= fetch_current_product
  end

  def fetch_current_product
    raise 'current_product_id is not implemented' unless respond_to?(:current_product_id, true)

    Dao::Product.find_by(id: current_product_id.to_s)
  end
end
