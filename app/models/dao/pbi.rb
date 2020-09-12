# typed: false
class Dao::Pbi < ApplicationRecord
  has_many :criteria, class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_pbi_id, dependent: :destroy
end
