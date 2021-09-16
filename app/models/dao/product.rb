# typed: false
class Dao::Product < ApplicationRecord
  has_many :teams, class_name: 'Dao::Team', foreign_key: :dao_product_id, dependent: :destroy

  def read
    Product::Product.from_repository(
      read_id,
      read_name,
      read_description,
    )
  end

  def write(product)
    self.attributes = {
      name: product.name,
      description: product.description,
    }
  end

  def owner
    Person::Id.from_string(owner_id)
  end

  private

  def read_id
    Product::Id.from_string(id)
  end

  def read_name
    Shared::Name.new(name)
  end

  def read_description
    Shared::ShortSentence.new(description)
  end
end
