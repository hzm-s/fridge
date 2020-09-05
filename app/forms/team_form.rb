# typed: false
class TeamForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :product_id, :name
  attr_accessor :domain_objects

  validates :product_id,
    presence: true,
    domain_object: { object_class: Product::Id, method: :from_string, allow_blank: true }

  validates :name,
    presence: true,
    length: { maximum: 50 }
end
