# typed: strict
require 'sorbet-runtime'

module Plan
  class AppendItem
    extend T::Sig

    sig {params(pbi_repository: Pbi::PbiRepository, plan_repository: PlanRepository).void}
    def initialize(pbi_repository, plan_repository)
      @pbi_repository = pbi_repository
      @plan_repository = plan_repository
    end

    sig {params(roles: Team::RoleSet, plan: Plan, release: Release, item: Pbi::Pbi).returns(Pbi::Pbi)}
    def append(roles, plan, release, item)
      release.plan_item(item.id)
      plan.update_release(roles, release)

      @pbi_repository.store(item)
      @plan_repository.store(plan)

      item
    end
  end
end
