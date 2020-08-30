# typed: false
class PbiForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :description
  attr_accessor :domain_objects

  validates :description,
    presence: true,
    domain_object: { object_class: Pbi::Description, message: t_domain_error(Pbi::InvalidDescription), allow_blank: true }
end
