# typed: false
require_relative '../domain_support/release_domain_support'

module ReleaseSupport
  include ReleaseDomainSupport

  def add_release(product_id, name)
    AppendReleaseUsecase.perform(team_roles(:po), product_id, name)
    ReleaseRepository::AR.find_by_product_id(product_id)
  end
end

RSpec.configure do |c|
  c.include ReleaseSupport
end
