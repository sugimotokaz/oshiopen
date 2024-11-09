class Article < ApplicationRecord

  belongs_to :user
  belongs_to :oshi_name
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags
  has_many :notifications, dependent: :destroy

  has_rich_text :content

  enum category: { others: 0, impression: 1, introduction: 2 }
  enum visible_gender: { not_selected: 0, male: 1, female: 2 }

  validates :title, presence: true, length: { maximum: 50 }
  validates :notice, length: { maximum: 100 }
  validates :category, presence: true
  validates :visible_gender, presence: true
  validates :visible_oshi, inclusion: { in: [true, false] }
  validates :content, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[title category]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user oshi_name] # 関連モデルを指定して検索可能に
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(article_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      article_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

end
