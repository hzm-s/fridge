class ImportsController < ApplicationController
  def create
    import(JSON.parse(params[:form][:data]).with_indifferent_access)
    redirect_to new_data_import_path, flash: { success: 'OK' }
  end

  private

  def import(data)
    product_id = Product::Id.from_string(data[:product_id])

    data[:issues].each do |issue|
      issue_id = plan_issue(product_id, issue)
      append_criteria(issue_id, issue[:criteria])
    end
  end

  def plan_issue(product_id, issue)
    PlanIssueUsecase.perform(
      product_id,
      Issue::Types.from_string(issue[:issue_type]),
      Shared::LongSentence.new(issue[:description]),
    )
  end

  def append_criteria(issue_id, criteria)
    criteria.each do |c|
      AppendAcceptanceCriterionUsecase.perform(
        issue_id,
        Shared::ShortSentence.new(c[:content]),
      )
    end
  end
end
