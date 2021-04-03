# typed: false
class CreateIssueForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :type, :description, :release_number
  attr_accessor :domain_objects

  validates :type,
    presence: true,
    domain_object: { object_class: Issue::Types, method: :from_string, message: t_domain_error(Issue::InvalidType), allow_blank: true }

  validates :description,
    presence: true,
    domain_object: { object_class: Issue::Description, message: t_domain_error(Issue::InvalidDescription), allow_blank: true }

  validates :release_number,
    numericality: { only_integer: true }, allow_blank: true
end
