# typed: false
class AcceptanceCriterionForm
  include ActiveModel::Model

  attr_accessor :content
  attr_accessor :domain_objects

  validates :content,
    presence: true,
    domain_object: { object_class: Pbi::AcceptanceCriterion, allow_blank: true }
end
