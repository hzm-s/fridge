# typed: false
module WorkDomainSupport
  def tasks(contents)
    contents.reduce(Work::TaskList.new) do |list, c|
      list.append(s_sentence(c))
    end
  end
end

RSpec.configure do |c|
  c.include WorkDomainSupport
end
