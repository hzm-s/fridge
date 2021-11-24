# typed: false
class Dao::AssignedPbi < ApplicationRecord
  belongs_to :pbi, class_name: 'Dao::Pbi', foreign_key: :dao_pbi_id
end
