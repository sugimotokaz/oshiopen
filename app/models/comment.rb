class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 500 }

  belongs_to :user
  belongs_to :article
  has_many :notifications, dependent: :destroy

end
