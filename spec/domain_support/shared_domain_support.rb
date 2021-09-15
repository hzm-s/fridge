# typed: false
module SharedDomainSupport
  def s_sentence(content)
    Shared::ShortSentence.new(content)
  end

  def l_sentence(content)
    Shared::LongSentence.new(content)
  end

  def name(content)
    return nil unless content

    Shared::Name.new(content)
  end

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
