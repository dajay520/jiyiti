#encoding: UTF-8
class SendMail < ActionMailer::Base
  default from: "dajay520@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.send_mail.confirm.subject
  #
  def confirm
    if Loseweight.where(:update_date => '2012-08-04').size < 1
      mail to: ["dajay520@qq.com","dajay520@gmail.com"],:subject => "日报延迟通知"
    else
      mail to: ["dajay520@qq.com","dajay520@gmail.com"],:subject => "日报没有延迟通知"
    end
  end
end
