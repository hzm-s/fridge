# typed: false
module ReleaseDomainSupport
  def issue_list(*issue_ids)
    Release::IssueList.new(issue_ids)
  end
end

RSpec.configure do |c|
  c.include ReleaseDomainSupport
end
