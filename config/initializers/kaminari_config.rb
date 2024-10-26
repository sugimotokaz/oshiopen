# frozen_string_literal: true

Kaminari.configure do |config|
  # 一覧ページの１ページに何個の記事が表示されるか。下記では1ページに10のアイテムを表示させる
  config.default_per_page = 10
  # config.max_per_page = nil

  # ペーネーションのページ数の表示を現在のページから左右に3まで表示させる
  config.window = 2
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end
