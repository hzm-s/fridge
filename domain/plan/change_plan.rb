# typed: strict
require 'sorbet-runtime'

module Plan
  class ChangePlan
    extend T::Sig

    sig {params(roles: Team::RoleSet).void}
    def initialize(roles)
      @roles = roles
    end

    sig {params(plan: Plan, from: Pbi::Id, to: Pbi::Id).returns(Plan)}
    def change_item_priority(plan, from, to)
      sorted = plan.release_by_item(from).change_item_priority(from, to)
      renew_plan(plan, [sorted])
    end

    sig {params(plan: Plan, from: Pbi::Id, release_number: Integer, to: T.nilable(Pbi::Id)).returns(Plan)}
    def reschedule(plan, from, release_number, to)
      dropped = plan.release_by_item(from).drop_item(from)
      appended = plan.release_of(release_number).plan_item(from)
      tmp_plan = renew_plan(plan, [dropped, appended])

      return tmp_plan unless to

      change_item_priority(tmp_plan, from, to)
    end

    private

    sig {params(plan: Plan, releases: T::Array[Release]).returns(Plan)}
    def renew_plan(plan, releases)
      plan.tap do |p|
        releases.each { |r| p.update_release(@roles, r) }
      end
    end
  end
end
