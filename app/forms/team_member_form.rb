# typed: false
class TeamMemberForm
  include ActiveModel::Model
  extend I18nHelper

  attr_accessor :roles
  attr_accessor :domain_objects

  validates :roles, team_roles: true
end
