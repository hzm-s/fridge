# typed: false
module SharedDomainSupport
  def activity_set(entries)
    Activity::Set.from_symbols(entries)
  end
end

RSpec.configure do |c|
  c.include SharedDomainSupport
end
