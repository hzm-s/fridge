# typed: false
module PbiQuery
  class << self
    def call(id)
      dao = Dao::Pbi.eager_load(:criteria).find(id)
      PbiStruct.new(dao)
    end
  end
end
