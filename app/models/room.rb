class Room < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :user_rooms, dependent: :destroy
  has_many :users, through: :user_rooms
  has_many :messages, dependent: :destroy

  validates :name, presence: true
end
