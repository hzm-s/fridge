# typed: false
class TeamForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :name, :role
  attr_accessor :domain_objects

  validates :role,
    presence: true,
    domain_object: { object_class: Team::Role, by: ->(k, v) { k.from_string(v) }, allow_blank: true }
end
