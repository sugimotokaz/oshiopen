require 'rails_helper'

RSpec.describe Tag, type: :model do
  
  describe 'タグの作成' do
    it 'タグの文字数がない場合、無効' do
      tag = build(:tag, name: "")
      expect(tag).to be_invalid
    end
  end
end
