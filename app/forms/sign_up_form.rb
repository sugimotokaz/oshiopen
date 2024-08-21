class SignUpForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  validates :name, presence: true, length: { maximum: 25 }
  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true, confirmation: true

  attr_reader :user

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      @user = User.create!(email: email, password: password, password_confirmation: password_confirmation)
      Profile.create!(name: name, user: user)
    end
  rescue StandardError
    false
  end
end