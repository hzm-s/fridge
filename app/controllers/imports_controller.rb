class ImportsController < ApplicationController
  def create
    import(JSON.parse(params[:form][:data]).with_indifferent_access)
    redirect_to new_data_import_path, flash: { success: 'OK' }
  end

  private

  def import(data)
    product_id = Product::Id.from_string(data[:product_id])

    data[:pbis].each do |pbi|
      pbi_id = draft_pbi(product_id, pbi)
      append_criteria(pbi_id, pbi[:criteria])
    end
  end

  def draft_pbi(product_id, pbi)
    DraftPbiUsecase.perform(
      product_id,
      Pbi::Types.from_string(pbi[:pbi_type]),
      Shared::LongSentence.new(pbi[:description]),
      pbi[:release_number].to_i,
    )
  end

  def append_criteria(pbi_id, criteria)
    criteria.each do |c|
      AppendAcceptanceCriterionUsecase.perform(
        pbi_id,
        Shared::ShortSentence.new(c[:content]),
      )
    end
  end
end
