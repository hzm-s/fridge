# typed: true
module IssueQuery
  class << self
    def call(id)
      rel = Dao::Issue.eager_load(:criteria).find(id)
      Wrapper.new(rel)
    end
  end

  class Wrapper < SimpleDelegator
    def status
      @__status ||= Issue::Statuses.from_string(super)
    end
  end
end
