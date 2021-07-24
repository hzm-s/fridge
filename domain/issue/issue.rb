# typed: strict
require 'sorbet-runtime'

module Issue
  class Issue
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, type: Type, description: Description).returns(T.attached_class)}
      def create(product_id, type, description)
        new(
          Id.create,
          product_id,
          type,
          type.initial_status,
          description,
          StoryPoint.unknown,
          AcceptanceCriteria.create,
        )
      end

      sig {params(id: Id, product_id: Product::Id, type: Type, status: Status, description: Description, size: StoryPoint, acceptance_criteria: AcceptanceCriteria).returns(T.attached_class)}
      def from_repository(id, product_id, type, status, description, size, acceptance_criteria)
        new(id, product_id, type, status, description, size, acceptance_criteria)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Type)}
    attr_reader :type

    sig {returns(Status)}
    attr_reader :status

    sig {returns(Description)}
    attr_reader :description

    sig {returns(StoryPoint)}
    attr_reader :size

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(
      id: Id,
      product_id: Product::Id,
      type: Type,
      status: Status,
      description: Description,
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

    sig {params(description: Description).void}
    def modify_description(description)
      @description = description
    end

    sig {params(criteria: AcceptanceCriteria).void}
    def prepare_acceptance_criteria(criteria)
      @acceptance_criteria = criteria

      update_status_by_preparation
    end

    sig {params(roles: Team::RoleSet, size: StoryPoint).void}
    def estimate(roles, size)
      raise CanNotEstimate unless Activity.allow?(:estimate_issue, [roles, status])

      @size = size
      update_status_by_preparation
    end

    sig {params(roles: Team::RoleSet).void}
    def assign_to_sprint(roles)
      raise CanNotAssignToSprint unless Activity.allow?(:assign_issue_to_sprint, [roles, status])

      @status = @status.assign_to_sprint
    end

    sig {params(roles: Team::RoleSet).void}
    def revert_from_sprint(roles)
      raise CanNotRevertFromSprint unless Activity.allow?(:revert_issue_from_sprint, [roles, status])

      @status = @status.revert_from_sprint
    end

    private

    sig {void}
    def update_status_by_preparation
      return unless @type.update_by_preparation?

      @status = @status.update_by_preparation(acceptance_criteria, size)
    end
  end
end
