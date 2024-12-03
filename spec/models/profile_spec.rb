require 'rails_helper'

RSpec.describe Profile, type: :model do

  describe 'プロフィール更新' do
    it '自己紹介が1000文字以内でない場合、バリデーションが機能するか' do
      profile = build(:profile, self_introduction: 'a' * 1001)
      expect(profile).to be_invalid
    end
  end

end
