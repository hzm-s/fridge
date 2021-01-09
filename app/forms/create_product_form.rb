# typed: false
class CreateProductForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :name, :description, :roles
  attr_accessor :domain_objects

  validates :name,
    presence: true,
    length: { in: 1..50, allow_blank: true }

  validates :description,
    length: { in: 1..200, allow_blank: true }

  validates :roles, team_roles: true
end
