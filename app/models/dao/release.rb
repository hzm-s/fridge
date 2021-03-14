# typed: false
class Dao::Release < ApplicationRecord
  class << self
    def read(daos)
      Plan::Plan.from_repository(
        daos.first.read_product_id,
        daos.map(&:read)
      )
    end
  end

  def write(release)
    self.issues = release.issues.to_a.map(&:to_s)
  end

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read
    Plan::Release.from_repository(
      number.to_i,
      issues.map { |i| Issue::Id.from_string(i) }.then { |l| Plan::IssueList.new(l) }
    )
  end
end
