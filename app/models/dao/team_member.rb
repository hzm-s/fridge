# typed: strict
class Dao::TeamMember < ApplicationRecord
  belongs_to :person, class_name: 'Dao::Person', foreign_key: :dao_person_id
end
