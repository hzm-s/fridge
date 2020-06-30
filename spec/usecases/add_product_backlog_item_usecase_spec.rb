require 'rails_helper'

RSpec.describe 'Add product backlog item' do
  it do
    repo = ProductBacklogItemRepository::AR
    uc = AddProductBacklogItemUsecase.new(repo)

    pbi_id = uc.perform('CONTENT_OF_PBI')
    pbi = repo.find_by_id(pbi_id)

    aggregate_failures do
      expect(pbi.content).to eq('CONTENT_OF_PBI')
    end
  end
end
