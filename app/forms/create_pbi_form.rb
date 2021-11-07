# typed: false
class CreatePbiForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :type, :description, :release_number
  attr_accessor :domain_objects

  validates :type,
    presence: true,
    domain_object: { object_class: Pbi::Types, method: :from_string, message: t_domain_error(Pbi::InvalidType), allow_blank: true }

  validates :description,
    presence: true,
    domain_object: { object_class: Shared::LongSentence, message: t_domain_error(Shared::InvalidLongSentence), allow_blank: true }

  validates :release_number,
    numericality: { only_integer: true }, allow_blank: true
end
