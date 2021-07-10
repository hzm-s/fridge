# typed: false
class AcceptanceCriterionForm
  include ActiveModel::Model

  attr_accessor :content

  validates :content, length: { minimum: 3, maximum: 500 }, allow_nil: true
end
