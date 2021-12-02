# typed: strict
require 'sorbet-runtime'

module SprintRepository
  class AR
    class << self
      extend T::Sig
      include Sprint::SprintRepository

      sig {override.params(product_id: Product::Id).returns(Integer)}
      def next_sprint_number(product_id)
        previous = Dao::Sprint.where(dao_product_id: product_id.to_s).order(:number).first
        return 1 unless previous

        previous.number + 1
      end

      sig {override.params(product_id: Product::Id).returns(T.nilable(Sprint::Sprint))}
      def current(product_id)
        Dao::Sprint
          .where(dao_product_id: product_id.to_s, is_finished: false)
          .order(number: :desc)
          .first
          &.read
      end

      sig {override.params(id: Sprint::Id).returns(Sprint::Sprint)}
      def find_by_id(id)
        Dao::Sprint.find(id).read
      end

      sig {override.params(sprint: Sprint::Sprint).void}
      def store(sprint)
        Dao::Sprint.find_or_initialize_by(id: sprint.id.to_s).tap do |dao|
          dao.write(sprint)
          dao.save!
        end
      end
    end
  end
end
