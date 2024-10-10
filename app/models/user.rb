class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true

  has_one :profile, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_articles, through: :favorites, source: :article

  def own?(object)
    object.profile.user_id == id
  end

  def own1?(object)
    object.user_id == id
  end

  def favorite(article)
    favorite_articles << article
  end

  def unfavorite(article)
    favorite_articles.destroy(article)
  end

  def favorite?(article)
    favorite_articles.include?(article)
  end
end
