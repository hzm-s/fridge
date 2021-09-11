# typed: false
module IssueDomainSupport
  def acceptance_criterion(content)
    Issue::AcceptanceCriterion.new(1, s_sentence(content))
  end

  def acceptance_criteria(contents, numbers_or_keyword = [])
    Issue::AcceptanceCriteria.create.tap do |criteria|
      contents.each { |c| criteria.append(s_sentence(c)) }

      satisfy_numbers =
        if numbers_or_keyword == :all
          criteria.to_a.map(&:number)
        else
          numbers_or_keyword
        end

      satisfy_numbers.each do |n|
        criterion = criteria.of(n)
        criterion.satisfy
        criteria.update(criterion)
      end
    end
  end

  def issue_list(*issue_ids)
    Issue::List.new(issue_ids)
  end
end

RSpec.configure do |c|
  c.include IssueDomainSupport
end
