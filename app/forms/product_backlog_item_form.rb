# typed: false
class ProductBacklogItemForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :content
  attr_accessor :domain_objects

  validates :content,
    presence: true,
    domain_object: { object_class: Pbi::Content, message: t_domain_error(Pbi::InvalidContent), allow_blank: true }
end
