class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize,:except => [:login,:qqlogin]
  protected
  
  def authorize
    if cookies[:remember_me]
      puts 'admin tianjj'
      session[:admin] = 'admin'
    end
  end
end
