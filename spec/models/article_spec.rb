require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '記事の作成' do

    it 'タイトルの入力がない場合、無効' do
      article = build(:article, title: "")
      expect(article).to be_invalid
    end

    it 'タイトルの文字数が50文字以内でない場合、無効' do
      article = build(:article, title: 'a' * 51)
      expect(article).to be_invalid
    end

    it '注意書きが100文字以内でない場合、無効' do
      article = build(:article, title: 'a' * 101)
      expect(article).to be_invalid
    end

    it '本文の入力がない場合、無効' do
      article = build(:article, content: '')
      expect(article).to be_invalid
    end
  end
end
