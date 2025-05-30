module ApplicationHelper
  def flash_class(level)
    case level
    when 'info' then 'bg-orange-300 text-white p-4 rounded'
    when 'success' then 'bg-green-300 text-white p-4 rounded'
    when 'danger' then 'bg-red-300 text-white p-4 rounded'
    when 'alert' then 'bg-yellow-500 text-white p-4 rounded'
    else 'bg-gray-500 text-white p-4 rounded'
    end
  end

  def page_title(title = '')
    base_title = '推しOPEN'
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
