module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'bg-blue-500 text-white p-4 rounded'
    when 'success' then 'bg-green-300 text-white p-4 rounded'
    when 'danger' then 'bg-red-300 text-white p-4 rounded'
    when 'alert' then 'bg-yellow-500 text-white p-4 rounded'
    else 'bg-gray-500 text-white p-4 rounded'
    end
  end
end
