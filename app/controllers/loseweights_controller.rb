#encoding: UTF-8
require 'googlecharts'
require "open-uri"
require 'json'
require 'qq'
class LoseweightsController < ApplicationController
  def authorize
    if cookies[:remember_me]
      puts 'admin tianjj'
      session[:admin] = 'admin'
    end
    unless session[:admin] or session[:user]
      redirect_to :action=>:login
    end
  end
  def login
    pwd = params[:pwd]
    if pwd=='7877435'
      session[:admin] = 'admin'
      puts 'test tianjj'
      if params[:remember_me]
        puts 'tianjj remember'
        cookies[:remember_me]='admin'
      end
      
      redirect_to "/loseweights"
      
    end
    notice='密码不对，真蠢。'
  end
  
  def qqlogin
    puts "qqlogin:params," + request.fullpath
    qq = Qq.new
    token=qq.get_token(params[:code],request.env['HTTP_CONNECTION'])
    quser = Qquser.where(:open_id=>qq.openid)
    if quser.size == 0
      puts 'no user.create it'
      usr = User.new
      usr.save
      
      qquser = Qquser.new
      qquser.open_id = qq.openid
      qquser.token=qq.token
      qquser.user_id=usr.id
      qquser.save
      session[:user] = usr
    else
      session[:user] = quser[0].user
    end
    session[:userInfo] = qq.get_user_info(qq.auth)
    redirect_to "/loseweights"
  end
  
  def loginout
    session[:user]=nil
    session[:userInfo]=nil
    redirect_to "/loseweights/login"
  end
  # GET /loseweights
  # GET /loseweights.json
  def index
    puts 'session_user:'
    puts session[:user]
    @all_loseweights = Loseweight.where(:user_id=>session[:user].id).order('update_date')
    @loseweights = Loseweight.where(:user_id=>session[:user].id).paginate(:order=>'update_date desc',:page=>params[:page],:per_page => 15)
    data = []
    @all_loseweights.each do |l|
      if l.weight.to_f!=0
      	data<<l.weight.to_f
      end
    end
    #data=[1,2,3,4]
    if data.size>0
      @img_url = Gchart.sparkline(:data => data, :size => '400x300', :line_colors => '0077CC',:axis_with_labels => 'y',
      :chg=>'0,20', :max_value=>data.max+1,:min_value=>data.min-1)+'&chg=0,15&chls=3'
    end
    
    #@img_url = Gchart.line(:data => [0, 40, 10, 70, 20],:axis_with_labels => ['y'])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @loseweights }
    end
  end

  # GET /loseweights/1
  # GET /loseweights/1.json
  def show
    @loseweight = Loseweight.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @loseweight }
    end
  end 

  # GET /loseweights/new
  # GET /loseweights/new.json
  def new
    @loseweight = Loseweight.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @loseweight }
    end
  end

  # GET /loseweights/1/edit
  def edit
    @loseweight = Loseweight.find(params[:id])
  end

  # POST /loseweights
  # POST /loseweights.json
  def create
    @loseweight = Loseweight.new(params[:loseweight])
    @loseweight.gmt_create=Time.new.utc
    @loseweight.user_id=session[:user].id
    respond_to do |format|
      if @loseweight.save
        format.html { redirect_to @loseweight, notice: '新建日志成功。蠢耸。' }
        format.json { render json: @loseweight, status: :created, location: @loseweight }
      else
        format.html { render action: "new" }
        format.json { render json: @loseweight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /loseweights/1
  # PUT /loseweights/1.json
  def update
    @loseweight = Loseweight.find(params[:id])

    respond_to do |format|
      if @loseweight.update_attributes(params[:loseweight])
        format.html { redirect_to @loseweight, notice: '更新日志成功，小蠢耸.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @loseweight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loseweights/1
  # DELETE /loseweights/1.json
  def destroy
    @loseweight = Loseweight.find(params[:id])
    @loseweight.destroy

    respond_to do |format|
      format.html { redirect_to loseweights_url }
      format.json { head :no_content }
    end
  end
end
