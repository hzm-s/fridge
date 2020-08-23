# typed: strict
require 'sorbet-runtime'

class AddFeatureUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @feature_repository = T.let(FeatureRepository::AR, Feature::FeatureRepository)
    @product_backlog_repository = T.let(ProductBacklogRepository::AR, ProductBacklog::ProductBacklogRepository)
  end

  sig {params(product_id: Product::Id, description: Feature::Description).returns(Feature::Id)}
  def perform(product_id, description)
    feature = Feature::Feature.create(product_id, description)

    product_backlog = fetch_product_backlog(product_id)
    product_backlog.add_item(feature.id)

    transaction do
      @feature_repository.add(feature)
      @product_backlog_repository.update(product_backlog)
    end

    feature.id
  end

  private

  sig {params(product_id: Product::Id).returns(ProductBacklog::ProductBacklog)}
  def fetch_product_backlog(product_id)
    product_backlog = @product_backlog_repository.find_by_product_id(product_id)
    return product_backlog if product_backlog

    ProductBacklog::ProductBacklog.create(product_id)
  end
end
