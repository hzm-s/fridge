# typed: strict
require 'sorbet-runtime'

class AppendIssueToOrderUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(OrderRepository::AR, Plan::OrderRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id).void}
  def perform(product_id, issue_id)
    order = @repository.find_by_product_id(product_id)
    order.append_issue(issue_id)
    @repository.store(order)
  end
end
