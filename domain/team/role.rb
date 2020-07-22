# typed: strict
require 'sorbet-runtime'

module Team
  module Role
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(T::Array[Symbol])}
    def available_actions_for_pbi
    end

    class << self
      extend T::Sig

      sig {returns(ProductOwner)}
      def product_owner
        ProductOwner.new
      end

      sig {returns(Developer)}
      def developer
        Developer.new
      end

      sig {returns(ScrumMaster)}
      def scrum_master
        ScrumMaster.new
      end
    end
  end
end
