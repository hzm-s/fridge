# typed: false
class ReleaseForm
  include ActiveModel::Model
  extend I18nHelper

  attr_writer :title
  attr_writer :domain_objects

  validates :title,
    domain_object: { object_class: Shared::Name, message: t_domain_error(Shared::InvalidName), allow_blank: true }

  def domain_objects
    return { title: nil } unless @domain_objects

    @domain_objects
  end

  def title
    return nil if @title.blank?

    @title
  end
end
