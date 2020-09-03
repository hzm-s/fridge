# typed: true
module ProductListQuery
  class << self
    def call(person_id)
      Dao::Product.where(owner_id: person_id)
    end
  end
end
