#encoding: UTF-8
class UserMailer < ActionMailer::Base
  default from: "dajay520@gmail.com"
  
  def send
    puts 'go to send.'
    mail(:to => "dajay520@qq.com" , :subject => "日报延迟通知") do |format|
      format.text { render :text => '[减肥日志]通知您，您今日日报未发，请将罚款15元RMB打入dajay520@qq.com'}
    end
  end
end
