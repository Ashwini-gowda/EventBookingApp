class EventOrganizer < ApplicationRecord
  has_secure_password

  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
