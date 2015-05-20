class Show < ActiveRecord::Base
  belongs_to :proposer, class_name: 'User'
  has_many :showtimes

  validates :name, presence: true, length: { in: 1..30 }
  validates :category, length: { in: 1..30 }
  validates :proposer_id, presence: true
end
