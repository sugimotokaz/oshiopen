class Article < ApplicationRecord

  belongs_to :user
  belongs_to :oshi_name

  enum category: { others: 0, impression: 1, introduction: 2 }
  enum visible_gender: { not_selected: 0, male: 1, female: 2 }

  validates :title, presence: true, length: { maximum: 50 }
  validates :notice, length: { maximum: 100 }
  validates :category, presence: true
  validates :visible_gender, presence: true
  validates :visible_oshi, inclusion: { in: [true, false] }

end
