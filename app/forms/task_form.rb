# typed: false
class TaskForm
  include ActiveModel::Model

  attr_accessor :content

  validates :content, length: { minimum: 2, maximum: 20 }, allow_blank: true
end
