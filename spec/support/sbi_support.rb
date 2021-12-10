# typed: false
require_relative '../domain_support/sbi_domain_support'

module SbiSupport
  def resolve_sbi(pbi_id)
    resolve_sbi_id(pbi_id)
      .then { |sbi_id| SbiRepository::AR.find_by_id(sbi_id) }
  end

  def sbi_list_from_pbi(*pbi_ids)
    pbi_ids
      .map { |pbi_id| resolve_sbi_id(pbi_id) }
      .then { |sbi_ids| sbi_list(*sbi_ids) }
  end

  private

  def resolve_sbi_id(pbi_id)
    Dao::Sbi.select(:id).find_by!(dao_pbi_id: pbi_id.to_s).id
      .then { |id| Sbi::Id.from_string(id) }
  end
end

RSpec.configure do |c|
  c.include SbiSupport
end
