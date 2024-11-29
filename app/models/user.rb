class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true, length: { maximum: 15 }
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
  # フォロー機能に関するアソシエーション
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_users, through: :active_relationships, source: :followed
  has_many :follower_users, through: :passive_relationships, source: :follower
  # 通知機能に関するアソシエーション
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  # Google認証に関するアソシエーション
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  # ユーザーが作成したグループ（Room）の所有者
  has_many :owned_rooms, class_name: "Room", foreign_key: "owner_id", dependent: :destroy
  # ユーザーが参加しているグループ
  has_many :user_rooms, dependent: :destroy
  has_many :joined_rooms, through: :user_rooms, source: :room
  # メッセージに関するアソシエーション
  has_many :messages, dependent: :destroy

  # usersテーブルのデータが作成された時にprofilesテーブルのデータも作成される
  after_create :create_profile

  def own?(object)
    object.profile.user_id == id
  end

  def own1?(object)
    object.user_id == id
  end

  def owned_rooms?(object)
    object.owner_id == id
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

  # ルーム参加機能に関するメソッド
  def join_room(room)
    joined_rooms << room
  end

  def leave_room(room)
    joined_rooms.destroy(room)
  end

  def joined_room?(room)
    joined_rooms.include?(room)
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

  def self.ransackable_associations(auth_object = nil)
    %w[profile]
  end

end
