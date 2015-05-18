class Show < ActiveRecord::Base
  validates :name, presence: true, length: { in: 1..30 }
  validates :category, length: { in: 1..30 }
  validates :proposer_id, presence: true
  belongs_to :proposer
end
