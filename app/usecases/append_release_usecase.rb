# typed: strict
require 'sorbet-runtime'

class AppendReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, name: String).void}
  def perform(product_id, name)
    plan = @repository.find_by_product_id(product_id)
    scheduled = plan.scheduled.append(Plan::Release.new(name))
    plan.update_scheduled(scheduled)
    @repository.store(plan)
  end
end
