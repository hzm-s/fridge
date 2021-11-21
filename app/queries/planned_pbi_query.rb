# typed: strict
require 'sorbet-runtime'

class PlannedPbiQuery
  extend T::Sig

  class << self
    extend T::Sig

    sig {params(plan: Plan::Plan, release_number: Integer, index: Integer).returns(T.nilable(Pbi::Id))}
    def call(plan, release_number, index)
      new(plan).call(release_number, index)
    end
  end

  sig {params(plan: Plan::Plan).void}
  def initialize(plan)
    @plan = plan
  end

  sig {params(release_number: Integer, index: Integer).returns(T.nilable(Pbi::Id))}
  def call(release_number, index)
    release = find_release(release_number)
    return nil unless release

    release.items.to_a[index]
  end

  private

  sig {params(number: Integer).returns(T.nilable(Plan::Release))}
  def find_release(number)
    @plan.release_of(number)
  rescue Plan::ReleaseNotFound
    nil
  end
end
