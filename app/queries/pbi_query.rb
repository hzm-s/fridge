# typed: true
module PbiQuery
  class << self
    def call(id)
      rel = Dao::Pbi.eager_load(:criteria).find(id)
      Wrapper.new(rel)
    end
  end

  class Wrapper < SimpleDelegator
    def status
      @__status ||= Pbi::Statuses.from_string(super)
    end
  end
end
