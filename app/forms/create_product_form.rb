# typed: false
class CreateProductForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :name, :description, :role
  attr_accessor :domain_objects

  validates :name,
    presence: true,
    length: { in: 1..50, allow_blank: true }

  validates :description,
    length: { in: 1..200, allow_blank: true }

  validates :role,
    presence: true,
    domain_object: { object_class: Team::Role, method: :from_string, message: t_domain_error(Team::InvalidRole), allow_blank: true }
end
