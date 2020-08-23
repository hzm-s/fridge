# typed: true
module FeatureQuery
  class Struct < SimpleDelegator
    def status
      @__status ||= Feature::Statuses.from_string(super)
    end
  end

  class << self
    def call(id)
      rel = Dao::Feature.eager_load(:criteria).find(id)
      Struct.new(rel)
    end
  end
end
