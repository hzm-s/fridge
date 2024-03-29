# typed: strict
require 'sorbet-runtime'

module Pbi
  class Pbi
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, type: Types, description: Shared::LongSentence).returns(T.attached_class)}
      def draft(product_id, type, description)
        new(Id.create, product_id, type, Statuses::Preparation, description, StoryPoint.unknown, AcceptanceCriteria.new)
      end

      sig {params(
        id: Id,
        product_id: Product::Id,
        type: Types,
        status: Statuses,
        description: Shared::LongSentence,
        size: StoryPoint,
        acceptance_criteria: AcceptanceCriteria
      ).returns(T.attached_class)}
      def from_repository(id, product_id, type, status, description, size, acceptance_criteria)
        new(id, product_id, type, status, description, size, acceptance_criteria)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Types)}
    attr_reader :type

    sig {returns(Statuses)}
    attr_reader :status

    sig {returns(Shared::LongSentence)}
    attr_reader :description

    sig {returns(StoryPoint)}
    attr_reader :size

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(
      id: Id,
      product_id: Product::Id,
      type: Types,
      status: Statuses,
      description: Shared::LongSentence,
      size: StoryPoint,
      acceptance_criteria: AcceptanceCriteria
    ).void}
    def initialize(id, product_id, type, status, description, size, acceptance_criteria)
      @id = id
      @product_id = product_id
      @type = type
      @status = status
      @description = description
      @size = size
      @acceptance_criteria = acceptance_criteria
    end
    private_class_method :new

    sig {params(description: Shared::LongSentence).void}
    def modify_description(description)
      @description = description
    end

    sig {params(acceptance_criteria: AcceptanceCriteria).void}
    def prepare_acceptance_criteria(acceptance_criteria)
      @acceptance_criteria = acceptance_criteria
      update_status_by_preparation
    end

    sig {params(roles: Team::RoleSet, size: StoryPoint).void}
    def estimate(roles, size)
      Activity.check_permission!(:estimate_pbi, [roles])

      @size = size
      update_status_by_preparation
    end

    sig {params(roles: Team::RoleSet).void}
    def assign_to_sprint(roles)
      Activity.check_permission!(:assign_pbi_to_sprint, [roles])

      @status = @status.assign_to_sprint
    end

    sig {params(roles: Team::RoleSet).void}
    def revert_from_sprint(roles)
      Activity.check_permission!(:revert_pbi_from_sprint, [roles])

      @status = @status.revert_from_sprint
    end

    private

    sig {void}
    def update_status_by_preparation
      @status = @status.update_by_preparation(@type, @acceptance_criteria, @size)
    end
  end
end
