# typed: false
module TeamSupport
  def resolve_team(product_id)
    Dao::Team.find_by(dao_product_id: product_id.to_s)
      .yield_self { |t| Team::Id.from_string(t.id) }
      .yield_self { |id| TeamRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include TeamSupport
end
