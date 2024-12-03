require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'コメント作成' do
    it '本文がない場合、無効' do
      comment = build(:comment)
      expect(comment).to be_invalid
    end
  end
end
