# typed: false
module SprintSupport
  def start_sprint(product_id)
    StartSprintUsecase.perform(product_id)
      .then { |id| SprintRepository::AR.find_by_id(id) }
  end

  def assign_pbi_to_sprint(product_id, *pbi_ids)
    pbi_ids.each do |pbi_id|
      AssignPbiToSprintUsecase.perform(product_id, team_roles(:po), pbi_id)
    end
  end
end

RSpec.configure do |c|
  c.include SprintSupport
end
