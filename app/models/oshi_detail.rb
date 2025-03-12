class OshiDetail < ApplicationRecord

  belongs_to :profile
  belongs_to :oshi_name
  mount_uploader :oshi_image, OshiImageUploader

  validates :reason_for_favorite, length: { maximum: 500 }
  validates :trigger_for_favorite, length: { maximum: 500 }
  validates :activity_history, length: { maximum: 1000 }
end
