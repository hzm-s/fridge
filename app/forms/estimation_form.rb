# typed: false
class EstimationForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :size
  attr_accessor :domain_objects

  validates :size,
    presence: true,
    domain_object: {
      object_class: Pbi::StoryPoint,
      by: ->(klass, v) { v == '?' ? klass.unknown : klass.new(v.to_i) },
      message: t_domain_error(Pbi::InvalidStoryPoint),
      allow_blank: true
    }
end
