require 'rails_helper'

RSpec.describe OshiDetail, type: :model do
  
  describe '推し詳細の登録' do
    it '好きな理由の文字数が500文字以下でない場合、無効' do
      oshi_detail = build(:oshi_detail, reason_for_favorite: 'a' * 501)
      expect(oshi_detail).to be_invalid
    end

    it '好きになったキッカケの文字数が500文字以下でない場合、無効' do
      oshi_detail = build(:oshi_detail, trigger_for_favorite: 'a' * 501)
      expect(oshi_detail).to be_invalid
    end

    it '推し活履歴の文字数が10000文字以下でない場合、無効' do
      oshi_detail = build(:oshi_detail, activity_history: 'a' * 10001)
      expect(oshi_detail).to be_invalid
    end
  end
end
