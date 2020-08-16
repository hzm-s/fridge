# typed: strict
require 'sorbet-runtime'

class SortProductBacklogUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(product_id: Product::Id, from_id: Release::Id, item_id: Pbi::Id, to_id: Release::Id, position: Integer).void}
  def perform(product_id, from_id, item_id, to_id, position)
    all = @repository.find_plan_by_product_id(product_id)
    from = all.find { |r| r.id == from_id }
    to = all.find { |r| r.id == to_id }

    sorter = Release::ItemSorter.new(from, item_id, to, position)
    releases = sorter.sort

    transaction do
      releases.each do |release|
        @repository.update(release)
      end
    end
  end
end
