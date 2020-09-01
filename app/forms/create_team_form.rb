# typed: false
class CreateTeamForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :name, :role
  attr_accessor :domain_objects

  validates :name,
    presence: true,
    length: { maximum: 50 }

  validates :role,
    presence: true,
    domain_object: { object_class: Team::Role, by: ->(k, v) { k.from_string(v) }, message: t_domain_error(Team::InvalidRole), allow_blank: true }
end
