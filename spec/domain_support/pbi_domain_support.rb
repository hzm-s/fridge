# typed: false
module PbiDomainSupport
  def acceptance_criteria(contents)
    contents.map { |c| s_sentence(c) }
      .then { |c| Pbi::AcceptanceCriteria.new(c) }
  end

  def issue_list(*issue_ids)
    Issue::List.new(issue_ids)
  end

  def pbi_list(*pbi_ids)
    Shared::SortableList.new(pbi_ids)
  end
end

RSpec.configure do |c|
  c.include PbiDomainSupport
end
