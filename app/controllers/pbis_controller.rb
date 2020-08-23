# typed: false
class PbisController < ApplicationController
  include ProductHelper

  before_action :require_user

  helper_method :current_product_id

  def index
    @releases = ProductBacklogQuery.call(params[:product_id])
    @form = FeatureForm.new
  end

  private

  def current_product_id
    params[:product_id]
  end
end
