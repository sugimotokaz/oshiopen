require 'rails_helper'

RSpec.describe OshiName, type: :model do
  
  describe '推しの名前登録' do
    it '推しの名前がない場合、無効' do
      oshi_name = build(:oshi_name, name: "")
      expect(oshi_name).to be_invalid
    end

    it '推しの名前の文字数が50文字でない場合、無効' do
      oshi_name = build(:oshi_name, name: 'a' * 51)
      expect(oshi_name).to be_invalid
    end

    it '推しの名前は一意でないと無効' do
      create(:oshi_name, name: 'JO1')
      oshi_name = build(:oshi_name, name: 'JO1')
      expect(oshi_name).to be_invalid
    end
  end
end
