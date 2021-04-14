# typed: strict
require 'sorbet-runtime'

class StartSprintUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
  end

  sig {params(product_id: Product::Id).returns(Sprint::Id)}
  def perform(product_id)
    next_sprint_number = @repository.next_sprint_number(product_id)
    sprint = Sprint::Sprint.start(product_id, next_sprint_number)
    @repository.store(sprint)
    sprint.id
  end
end
