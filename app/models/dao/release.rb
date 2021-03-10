# typed: false
class Dao::Release < ApplicationRecord
  def write(release)
    self.issues = release.issues.to_a.map(&:to_s)
  end
end
