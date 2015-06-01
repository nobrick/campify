class University < ActiveRecord::Base
  validates :name, presence: true, length: { in: 1..30 }
  validates :city, length: { in: 1..15 }
end
