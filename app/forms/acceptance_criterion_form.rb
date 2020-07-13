class AcceptanceCriterionForm
  include ActiveModel::Model

  attr_accessor :content

  validates :content,
    presence: true,
    length: { in: 3..100, allow_blank: true }
end
