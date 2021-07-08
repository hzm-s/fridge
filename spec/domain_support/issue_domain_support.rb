# typed: false
module IssueDomainSupport
  def issue_description(desc)
    Issue::Description.new(desc)
  end

  def acceptance_criterion(content)
    Issue::AcceptanceCriterion.new(1, content)
  end

  def acceptance_criteria(contents)
    Issue::AcceptanceCriteria.create.tap do |criteria|
      contents.each { |c| criteria.append(c) }
    end
  end

  def issue_list(*issue_ids)
    Issue::List.new(issue_ids)
  end
end

RSpec.configure do |c|
  c.include IssueDomainSupport
end
