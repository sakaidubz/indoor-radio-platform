module UiHelper
  def status_emoji(status)
    case status.to_s
    when 'planning', 'scheduled' then '🗓️'
    when 'active', 'published' then '✅'
    when 'archived' then '🗄️'
    when 'draft' then '✏️'
    else '•'
    end
  end

  def platform_emoji(platform)
    case platform.to_s.downcase
    when 'x', 'twitter' then '𝕏'
    when 'instagram' then '📸'
    when 'soundcloud' then '☁️'
    when 'youtube' then '▶️'
    else '💬'
    end
  end

  def titleize_status(status)
    status.to_s.tr('_', ' ').split.map(&:capitalize).join(' ')
  end
end

