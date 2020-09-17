# typed: true
module IssueQuery
  class << self
    def call(id)
      rel = Dao::Issue.eager_load(:criteria).find(id)
      Wrapper.new(rel)
    end
  end

  class Wrapper < SimpleDelegator
    def product_id
      dao_product_id
    end

    def status
      @__status ||= Issue::Statuses.from_string(super)
    end
  end
end
