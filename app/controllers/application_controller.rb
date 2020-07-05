class ApplicationController < ActionController::Base
  helper_method :current_user_products

  def current_user_products
    @__products ||= fetch_current_user_products
  end

  def fetch_current_user_products
    Dao::Product.all
  end
end
