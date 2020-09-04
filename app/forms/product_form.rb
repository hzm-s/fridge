# typed: false
class ProductForm
  include ActiveModel::Model

  attr_accessor :name, :description
  attr_accessor :domain_objects

  validates :name,
    presence: true,
    length: { in: 1..50, allow_blank: true }

  validates :description,
    length: { in: 1..200, allow_blank: true }
end
