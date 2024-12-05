class OgpCreator
  require 'mini_magick'  
  BASE_IMAGE_PATH = './app/assets/images/share_image.png'
  GRAVITY = 'center'
  TEXT_POSITION = '0,0'
  FONT = './app/assets/fonts/KosugiMaru-Regular.ttf'
  FONT_SIZE = 50
  INDENTION_COUNT = 20
  ROW_LIMIT = 8

  def self.build(text)
    text = prepare_text(text)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|        
      config.font FONT
      config.fill 'red'
      config.gravity GRAVITY
      config.pointsize FONT_SIZE
      config.draw "text #{TEXT_POSITION} '#{text}'"
    end
  end

  private
  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end