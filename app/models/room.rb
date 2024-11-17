class Room < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :user_rooms, dependent: :destroy
  has_many :users, through: :user_rooms

  validates :name, presence: true
end
