# typed: false
class ReleaseForm
  include ActiveModel::Model

  attr_accessor :description

  validates :description,
    presence: true,
    length: { maximum: 100 }, allow_blank: true
end
