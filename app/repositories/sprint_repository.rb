# typed: strict
require 'sorbet-runtime'

module SprintRepository
  class AR
    class << self
      extend T::Sig
      include Sprint::SprintRepository

      sig {override.params(product_id: Product::Id).returns(Integer)}
      def next_sprint_number(product_id)
        Dao::Sprint.find_by(dao_product_id: product_id.to_s).number + 1
      end

      sig {override.params(sprint: Sprint::Sprint).void}
      def store(sprint)
        Dao::Sprint.new(id: sprint.id.to_s).tap do |dao|
          dao.write(sprint)
          dao.save!
        end
      end
    end
  end
end
