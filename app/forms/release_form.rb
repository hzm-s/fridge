# typed: false
class ReleaseForm
  include ActiveModel::Model

  attr_accessor :name

  validates :name,
    presence: true,
    length: { maximum: 50 }
end
