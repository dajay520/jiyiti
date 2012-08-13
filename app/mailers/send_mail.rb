#encoding: UTF-8
class SendMail < ActionMailer::Base
  default from: "dajay520@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.send_mail.confirm.subject
  #
  def confirm
    if Loseweight.where(:update_date => (Time.now + 8.hour-1.second).strftime("%y-%m-%d")).size < 1
      mail to: ["dajay520@qq.com","dajay520@gmail.com","261657372@qq.com"],:subject => "日报延迟未发通知"
    end
  end
end
