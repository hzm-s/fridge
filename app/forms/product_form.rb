class ProductForm
  include ActiveModel::Model

  attr_accessor :name, :description

  validates :name,
    presence: true,
    length: { in: 1..50, allow_blank: true }

  validates :description,
    length: { in: 1..200, allow_blank: true }
end
