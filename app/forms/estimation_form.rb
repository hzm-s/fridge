# typed: false
class EstimationForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :point

  validates :point,
    presence: true,
    domain_object: { object_class: Pbi::StoryPoint, message: t_domain_error(Pbi::InvalidStoryPoint), allow_blank: true }
end
