class ProductBacklogItemForm
  include ActiveModel::Model

  attr_accessor :product_id, :content
  attr_accessor :domain_objects

  validates :product_id,
    presence: true,
    domain_object: { object_class: Product::ProductId, method: :from_string }

  validates :content,
    presence: true,
    domain_object: { object_class: Pbi::Content, method: :from_string, message: I18n.t('domain.errors.messages.pbi.content') }
end
