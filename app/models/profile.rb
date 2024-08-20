class Profile < ApplicationRecord

  validates :name, presence: true, length: { maximum: 25 }

  belongs_to :user
end
