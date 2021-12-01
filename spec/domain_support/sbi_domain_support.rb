# typed: false
module SbiDomainSupport
  def sbi_list(*sbi_ids)
    Shared::SortableList.new(sbi_ids)
  end
end

RSpec.configure do |c|
  c.include SbiDomainSupport
end
