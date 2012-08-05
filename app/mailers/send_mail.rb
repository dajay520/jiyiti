#encoding: UTF-8
class SendMail < ActionMailer::Base
  default from: "dajay520@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.send_mail.confirm.subject
  #
  def confirm
    @greeting = "Hi"

    mail to: "dajay520@qq.com",:subject => "日报延迟通知"
  end
end
