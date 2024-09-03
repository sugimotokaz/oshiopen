class OshiName < ApplicationRecord
  has_many :oshi_details
  has_many :articles

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
