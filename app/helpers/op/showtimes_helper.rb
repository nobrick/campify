module Op::ShowtimesHelper
  def ongoing_status(ongoing)
    if ongoing
      '活动进行中'
    else
      '活动已结束'
    end
  end

  def link_to_show(show)
    link_to "#{show.id}: #{show.name}", [ :op, show ]
  end

  def auto_display_show_id_field(&block)
    content = capture(&block)
    if @hidden_show_id_field
      content_tag(:div, content, class: 'hidden')
    else
      content
    end
  end
end
