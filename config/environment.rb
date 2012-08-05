# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Reduce::Application.initialize!

Reduce::Application.configure do
  config.action_mailer.delivery_method = :smtp
  
  config.action_mailer.smtp_settings = {
    :address  => "smtp.gmail.com",
    :port     => "587",
    :domain => "xiyix.com",
    :authentication => "plain",
    :user_name  => "dajay520@gmail.com",
    :password =>  "ttt5201314",
    :enable_starttls_auto => true
    
  }
end