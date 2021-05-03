# typed: false
module SprintSupport
  def start_sprint(product_id)
    StartSprintUsecase.perform(product_id)
      .then { |id| SprintRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include SprintSupport
end
