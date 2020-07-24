# typed: false
class TeamMemberForm
  include ActiveModel::Model

  attr_accessor :user_id, :role
end
