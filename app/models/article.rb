class Article < ApplicationRecord

  belongs_to :user
  belongs_to :oshi_name
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

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

end
