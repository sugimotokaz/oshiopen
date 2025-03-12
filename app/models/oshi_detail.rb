class OshiDetail < ApplicationRecord

  belongs_to :profile
  belongs_to :oshi_name
  mount_uploader :oshi_image, OshiImageUploader

  validates :reason_for_favorite, length: { maximum: 100 }
  validates :trigger_for_favorite, length: { maximum: 100 }
  validates :activity_history, length: { maximum: 200 }
end
