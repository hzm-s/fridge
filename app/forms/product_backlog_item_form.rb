class ProductBacklogItemForm
  include ActiveModel::Model

  attr_accessor :content
  attr_accessor :domain_objects

  validates :content,
    presence: true,
    domain_object: { object_class: Pbi::Content, method: :from_string, message: I18n.t('domain.errors.messages.pbi.content'), allow_blank: true }
end
