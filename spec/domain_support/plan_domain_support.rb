# typed: false
module PlanDomainSupport
  def issue_list(*issue_ids)
    Plan::IssueList.new(issue_ids)
  end

  def release_list(releases)
    releases.map do |name, issues|
      Plan::Release.new(name, issues)
    end
      .then { |list| Plan::ReleaseList.new(list) }
  end
end

RSpec.configure do |c|
  c.include PlanDomainSupport
end
