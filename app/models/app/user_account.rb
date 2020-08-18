# typed: true
class App::UserAccount < ApplicationRecord
  belongs_to :dao_person, class_name: 'Dao::Person', foreign_key: :dao_person_id

  class << self
    def create_for_person(person_id, provider:, uid:, image:)
      create!(dao_person_id: person_id, provider: provider, uid: uid, image: image)
    end

    def find_person_id_by_oauth_account(provider:, uid:)
      find_by(provider: provider, uid: uid)&.dao_person_id
    end
  end
end
