class Profile < ApplicationRecord

  belongs_to :user
  mount_uploader :profile_image, ProfileImageUploader

  validates :name, presence: true, length: { maximum: 25 }
  validates :birth_year, numericality: { only_integer: true, allow_nil: true }, inclusion: { in: 1900..Time.now.year, allow_nil: true }
  validates :self_introduction, length: { maximum: 1000 }

  enum gender: { not_selected: 0, male: 1, female: 2 }

end