# typed: strict
require 'sorbet-runtime'

module Roadmap
  class ChangeRoadmap
    extend T::Sig

    sig {params(roles: Team::RoleSet).void}
    def initialize(roles)
      @roles = roles
    end

    sig {params(roadmap: Roadmap, from: Pbi::Id, to: Pbi::Id).returns(Roadmap)}
    def change_item_priority(roadmap, from, to)
      sorted = roadmap.release_by_item(from).change_item_priority(from, to)
      renew_roadmap(roadmap, [sorted])
    end

    sig {params(roadmap: Roadmap, from: Pbi::Id, release_number: Integer, to: T.nilable(Pbi::Id)).returns(Roadmap)}
    def reschedule(roadmap, from, release_number, to)
      dropped = roadmap.release_by_item(from).drop_item(from)
      appended = roadmap.release_of(release_number).plan_item(from)
      tmp_roadmap = renew_roadmap(roadmap, [dropped, appended])

      return tmp_roadmap unless to

      change_item_priority(tmp_roadmap, from, to)
    end

    private

    sig {params(roadmap: Roadmap, releases: T::Array[Release]).returns(Roadmap)}
    def renew_roadmap(roadmap, releases)
      roadmap.tap do |p|
        releases.each { |r| p.update_release(@roles, r) }
      end
    end
  end
end
