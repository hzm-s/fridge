# typed: strict
require 'sorbet-runtime'

class AddIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(product_id: Product::Id, description: Issue::Description, release_no: Integer).returns(Issue::Id)}
  def perform(product_id, description, release_no = 1)
    issue = Issue::Issue.create(product_id, description)
    @repository.store(issue)
    issue.id
  end
end
