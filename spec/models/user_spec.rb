require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'ユーザー新規登録' do
    it '全てのフォームに入力されていば正常に保存されるか' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '名前の入力がない場合、無効' do
      user = build(:user, name: "")
      expect(user).to be_invalid
    end

    it '名前の文字数が15文字以内でない場合、無効' do
      user = build(:user, name: 'a' * 16)
      expect(user).to be_invalid
    end

    it 'メールアドレスがない場合、無効' do
      user = build(:user, email: "")
      expect(user).to be_invalid
    end

    it 'メールアドレスは一意でないと無効' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).to be_invalid
    end

    it 'パスワードがない場合、無効' do
      user = build(:user, password: "")
      expect(user).to be_invalid
    end

    it '確認用パスワードがない場合、無効' do
      user = build(:user, password_confirmation: "")
      expect(user).to be_invalid
    end
  end
end
