# typed: false
class UpdateIssueForm
  include ActiveModel::Model
  extend I18nHelper

  attr_reader :type
  attr_accessor :description
  attr_accessor :domain_objects

  validates :description,
    presence: true,
    domain_object: { object_class: Shared::LongSentence, message: t_domain_error(Shared::InvalidLongSentence), allow_blank: true }

  def initialize(attrs)
    @type = attrs.delete(:type)
    super(attrs)
  end
end
