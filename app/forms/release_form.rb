# typed: false
class ReleaseForm
  include ActiveModel::Model

  attr_accessor :index, :name

  validates :name,
    presence: true,
    length: { maximum: 50 }

  def persisted?
    !!index
  end
end
