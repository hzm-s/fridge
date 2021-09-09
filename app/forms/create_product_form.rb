# typed: false
class CreateProductForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :name, :description, :roles
  attr_accessor :domain_objects

  validates :name,
    presence: true,
    domain_object: { object_class: Shared::Name, message: t_domain_error(Shared::InvalidName), allow_blank: true }

  validates :description,
    length: { in: 1..200, allow_blank: true }

  validates :roles, team_roles: true
end
