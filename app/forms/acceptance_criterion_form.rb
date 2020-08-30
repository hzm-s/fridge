# typed: false
class AcceptanceCriterionForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :content
  attr_accessor :domain_objects

  validates :content,
    presence: true,
    domain_object: { object_class: Pbi::AcceptanceCriterion, message: t_domain_error(Pbi::InvalidAcceptanceCriterion), allow_blank: true }
end
