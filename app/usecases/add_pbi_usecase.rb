# typed: strict
require 'sorbet-runtime'

class AddPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(product_id: Product::Id, description: Pbi::Description, release_no: Integer).returns(Pbi::Id)}
  def perform(product_id, description, release_no = 1)
    pbi = Pbi::Pbi.create(product_id, description)
    @repository.store(pbi)
    pbi.id
  end
end
