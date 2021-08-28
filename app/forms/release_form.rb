# typed: false
class ReleaseForm
  include ActiveModel::Model

  attr_accessor :title

  validates :title,
    presence: true,
    length: { maximum: 100 }, allow_blank: true
end
