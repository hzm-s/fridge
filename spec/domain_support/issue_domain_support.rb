# typed: false
module IssueDomainSupport
  def acceptance_criteria(contents)
    contents.map { |c| s_sentence(c) }
      .then { |c| Issue::AcceptanceCriteria.new(c) }
  end

  def issue_list(*issue_ids)
    Issue::List.new(issue_ids)
  end
end

RSpec.configure do |c|
  c.include IssueDomainSupport
end
