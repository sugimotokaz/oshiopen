class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 200 }

  belongs_to :user
  belongs_to :article
  has_many :notifications, dependent: :destroy

end
