# typed: false
class ReleaseForm
  include ActiveModel::Model

  attr_writer :title

  validates :title,
    presence: true,
    length: { maximum: 100 }, allow_blank: true

  def title
    return nil if @title.blank?

    @title
  end
end
