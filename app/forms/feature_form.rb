# typed: false
class FeatureForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :description
  attr_accessor :domain_objects

  validates :description,
    presence: true,
    domain_object: { object_class: Feature::Description, message: t_domain_error(Feature::InvalidDescription), allow_blank: true }
end
