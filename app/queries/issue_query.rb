# typed: false
module IssueQuery
  class << self
    def call(id)
      rel = Dao::Issue.eager_load(:criteria).find(id)
      IssueStruct.new(rel)
    end
  end
end
