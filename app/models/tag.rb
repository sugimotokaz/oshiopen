class Tag < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  validates :name, presence: true, uniqueness: true
end
