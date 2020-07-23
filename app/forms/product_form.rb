# typed: false
class ProductForm
  include ActiveModel::Model

  attr_accessor :name, :description, :member_role
  attr_accessor :domain_objects

  validates :name,
    presence: true,
    length: { in: 1..50, allow_blank: true }

  validates :description,
    length: { in: 1..200, allow_blank: true }

  validates :member_role,
    presence: true,
    domain_object: { object_class: Team::Role, by: -> (k, v) { k.from_string(v) }, message: I18n.t('errors.messages.inclusion'), allow_blank: true }
end
