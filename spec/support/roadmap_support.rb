# typed: false
require_relative '../domain_support/roadmap_domain_support'

module RoadmapSupport
  include RoadmapDomainSupport

  def roadmap_of(product_id)
    RoadmapRepository::AR.find_by_product_id(product_id)
  end

  def update_roadmap(product_id)
    roadmap = RoadmapRepository::AR.find_by_product_id(product_id)
    yield(roadmap)
    RoadmapRepository::AR.store(roadmap)
  end

  def update_release(product_id, release_number)
    update_roadmap(product_id) do |roadmap|
      release = roadmap.release_of(release_number)
      new_release = yield(release)
      roadmap.update_release(team_roles(:po), new_release)
    end
  end

  def append_release(product_id, number = nil, title: nil)
    roadmap = roadmap_of(product_id)
    return if number && find_release_by_number(roadmap, number)

    AppendReleaseUsecase.perform(team_roles(:po), product_id, name(title))
      .then { roadmap_of(product_id).releases.last }
  end

  private

  def find_release_by_number(roadmap, number)
    roadmap.release_of(number)
  rescue Roadmap::ReleaseNotFound
    nil
  end
end

RSpec.configure do |c|
  c.include RoadmapSupport
end
