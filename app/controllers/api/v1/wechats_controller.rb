class Api::V1::WechatsController < ApplicationController
  wechat_responder

  on :text do |request, content|
    request.reply.text "echo: #{content}"
  end

  on :text, with: 'help' do |request, help|
    request.reply.text 'help content'
  end

  on :text, with: /^(\d+)条新闻$/ do |request, count|
    articles_range = (0... [count.to_i, 10].min)
    request.reply.news(articles_range) do |article, i|
      article.item title: "标题#{i}", description:"内容描述#{i}", pic_url: 'http://www.baidu.com/img/bdlogo.gif', url: 'http://www.baidu.com/'
    end
  end

  on :image do |request|
    request.reply.image(request[:MediaId])
  end

  on :voice do |request|
    request.reply.voice(request[:MediaId])
  end

  on :video do |request|
    nickname = wechat.user(request[:FromUserName])['nickname']
    request.reply.video(request[:MediaId], title: '回声', description: "#{nickname}发来的视频请求")
  end

  on :location do |request|
    request.reply.text("#{request[:Location_X]}, #{request[:Location_Y]}")
  end

  on :event do |request, key|
    case key
    when 'EVERYDAY_CHECK'
      request.reply.text '签到成功！'
    else '没有这个菜单！'
    end
  end

  on :fallback, respond: 'fallback message'  
end
