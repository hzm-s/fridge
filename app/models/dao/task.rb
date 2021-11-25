# typed: false
class Dao::Task < ApplicationRecord
  belongs_to :sbi, class_name: 'Dao::Sbi', foreign_key: :dao_sbi_id, optional: true
end
