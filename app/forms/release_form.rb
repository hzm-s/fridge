# typed: false
class ReleaseForm
  include ActiveModel::Model

  attr_accessor :title

  validates :title,
    presence: true,
    length: { in: 1..50, allow_blank: true }
end
