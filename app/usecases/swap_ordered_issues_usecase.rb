# typed: strict
require 'sorbet-runtime'

class SwapOrderedIssuesUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(OrderRepository::AR, Plan::OrderRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, to_index: Integer).void}
  def perform(product_id, issue_id, to_index)
    order = @repository.find_by_product_id(product_id)
    order.swap_issues(issue_id, order.issues.at(to_index))
    @repository.store(order)
  end
end
