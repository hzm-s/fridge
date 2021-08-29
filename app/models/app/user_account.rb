# typed: false
class App::UserAccount < ApplicationRecord
  belongs_to :person, class_name: 'Dao::Person', foreign_key: :dao_person_id
  has_one :profile, class_name: 'App::UserProfile', foreign_key: :app_user_account_id, required: false

  delegate :name, to: :person
  delegate :initials, :fgcolor, :bgcolor, to: :profile

  class << self
    def create_for_person(person_id, provider:, uid:)
      new(dao_person_id: person_id, provider: provider, uid: uid)
    end

    def find_id_by_oauth_account(provider:, uid:)
      find_by(provider: provider, uid: uid)&.id
    end
  end

  def initialize_profile(email)
    self.profile = App::UserProfile.create_from_email(id, email)
  end
end
