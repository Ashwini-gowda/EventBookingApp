class Ticket < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy

  validates :ticket_type, :price, :quantity_available, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
