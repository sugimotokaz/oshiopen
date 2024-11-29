class Profile < ApplicationRecord

  belongs_to :user
  has_many :oshi_details, dependent: :destroy
  mount_uploader :profile_image, ProfileImageUploader

  validates :birth_year, numericality: { only_integer: true, allow_nil: true }, inclusion: { in: 1950..Time.now.year, allow_nil: true }
  validates :self_introduction, length: { maximum: 1000 }
  validates :gender, presence: true

  enum gender: { not_selected: 0, male: 1, female: 2 }

  def fetch_oshi_details
    oshi_details.includes(:oshi_name) # N+1問題を避けるための例
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[gender birth_year] 
  end

end
