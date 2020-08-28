# typed: strict
require 'sorbet-runtime'

class AddPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @product_backlog_repository = T.let(ProductBacklogRepository::AR, ProductBacklog::ProductBacklogRepository)
  end

  sig {params(product_id: Product::Id, description: Pbi::Description).returns(Pbi::Id)}
  def perform(product_id, description)
    pbi = Pbi::Pbi.create(product_id, description)

    product_backlog = fetch_product_backlog(product_id)
    product_backlog.add_item(pbi.id)

    transaction do
      @pbi_repository.add(pbi)
      @product_backlog_repository.update(product_backlog)
    end

    pbi.id
  end

  private

  sig {params(product_id: Product::Id).returns(ProductBacklog::ProductBacklog)}
  def fetch_product_backlog(product_id)
    product_backlog = @product_backlog_repository.find_by_product_id(product_id)
    return product_backlog if product_backlog

    ProductBacklog::ProductBacklog.create(product_id)
  end
end
