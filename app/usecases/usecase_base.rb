# typed: false
class UsecaseBase
  class NotAllowed < StandardError; end

  class << self
    def perform(*args)
      new.perform(*args)
    end
  end

  def transaction
    ApplicationRecord.transaction(joinable: false, requires_new: true) do
      yield
    end
  end

  def rollback
    raise ActiveRecord::Rollback
  end
end
