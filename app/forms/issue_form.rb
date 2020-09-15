# typed: false
class IssueForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :description
  attr_accessor :domain_objects

  validates :description,
    presence: true,
    domain_object: { object_class: Issue::Description, message: t_domain_error(Issue::InvalidDescription), allow_blank: true }
end
