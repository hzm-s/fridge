# typed: false
module SharedDomainSupport
  def activity(name)
    Activity::Activity.from_symbol(name)
  end

  def activity_set(names)
    Activity::Set.from_symbols(names)
  end
end

RSpec.configure do |c|
  c.include SharedDomainSupport
end
