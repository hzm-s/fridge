# typed: false
class TaskForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :content
  attr_accessor :domain_objects

  validates :content,
    presence: true,
    domain_object: { object_class: Shared::ShortSentence, message: t_domain_error(Shared::InvalidShortSentence), allow_blank: true }

  def renew
    self.class.new
  end
end
