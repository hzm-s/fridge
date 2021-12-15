# typed: false
module SbiDomainSupport
  def tasks(contents)
    contents.reduce(Sbi::TaskList.new) do |list, c|
      list.append(s_sentence(c))
    end
  end
end

RSpec.configure do |c|
  c.include SbiDomainSupport
end
