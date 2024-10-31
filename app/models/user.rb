class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true, length: { maximum: 25 }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_one :profile, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_articles, through: :favorites, source: :article
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_users, through: :active_relationships, source: :followed
  has_many :follower_users, through: :passive_relationships, source: :follower
  # Google認証に関するアソシエーション
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  after_create :create_profile

  def own?(object)
    object.profile.user_id == id
  end

  def own1?(object)
    object.user_id == id
  end

  # お気に入り機能に関するメソッド
  def favorite(article)
    favorite_articles << article
  end

  def unfavorite(article)
    favorite_articles.destroy(article)
  end

  def favorite?(article)
    favorite_articles.include?(article)
  end
  # ここまで

  # フォロー機能に関するメソッド
  def follow(user)
    following_users << user
  end

  def unfollow(user)
    following_users.destroy(user)
  end

  def follow?(user)
    following_users.include?(user)
  end
  # ここまで

  private

  # プロフィールを自動作成
  def create_profile
    build_profile.save
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name] # usersテーブルのnameカラムを検索対象に指定
  end

end
