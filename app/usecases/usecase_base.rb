class UsecaseBase
  class << self
    def perform(*args)
      new.perform(*args)
    end
  end

  def transaction(&block)
    ApplicationRecord.transaction(&block)
  end
end
