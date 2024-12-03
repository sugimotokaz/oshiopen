FactoryBot.define do
  factory :article do
    title { "テストタイトル" }
    notice { "注意書きです" }
    category { "others" }
    visible_gender { "not_selected" }
    visible_oshi { "false" }
    content { "本文です" }
    status { "published" }
  end
end
