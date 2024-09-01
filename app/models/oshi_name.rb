class OshiName < ApplicationRecord
  has_many :oshi_details

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
