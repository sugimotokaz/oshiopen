class OshiName < ApplicationRecord
  has_many :oshi_details
  has_many :articles

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  def self.ransackable_attributes(auth_object = nil)
    %w[name] # oshi_namesテーブルのnameカラムを検索対象に指定
  end
  
end
