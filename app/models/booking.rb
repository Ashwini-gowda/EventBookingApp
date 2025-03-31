class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :event
  belongs_to :ticket

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
