#encoding: UTF-8
require 'googlecharts'
require "open-uri"
require 'json'
require 'qq'
class LoseweightsController < ApplicationController
  def authorize
    response.headers['P3P'] = "CP=\"CAO PSA OUR\""
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
    notice='密码不对。'
  end
  
  def qqlogin
    puts "qqlogin:params," + request.fullpath
    puts "http_state:"+request.env['HTTP_CONNECTION']
    qq = Qq.new
    token=qq.get_token(params[:code],request.env['HTTP_CONNECTION'])
    puts "token:" + token
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
      
      puts quser[0].user
    end
    session[:userInfo] = qq.get_user_info(qq.auth)
    redirect_to "/loseweights"
  end
  
  def qzonelogin
    session[:iscomefromqzone]='yes'
    response.headers['P3P'] = "CP=\"CAO PSA OUR\""
    q = Qq.new
    quser = q.get_open_user_info(params[:openid],params[:openkey],params[:pf],request.remote_ip)
    unless quser
      redirect_to "/loseweights"
      return
    end
    user = Qquser.where(:open_id=>params[:openid])
    if user.size==0
      usr = User.new
      usr.name=quser["nickname"]
      usr.save
      
      qquser = Qquser.new
      qquser.open_id = params[:openid]
      qquser.token=params[:openkey]
      qquser.user_id=usr.id
      qquser.save
      session[:user] = usr
    else
      session[:user] = user[0].user
      puts 'puts quser:'
      puts  user[0].user
    end
    session[:userInfo] = quser
    puts quser
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
    @all_loseweights = Loseweight.where(:user_id=>session[:user].id).order('update_date,created_at')
    @loseweights = Loseweight.where(:user_id=>session[:user].id).order('update_date desc').order('created_at desc').paginate(:page=>params[:page],:per_page => 7)
    @data = []
    time = []
    @time=[] #新报表记录x轴属性
    allsize=@all_loseweights.size
    step = (allsize-1)/6+1
    @step = (allsize-1)/10+1 #新报表x轴显示步长
    count = 1
    @all_loseweights.each do |l|
      if l.weight.to_f!=0
      	@data<<l.weight.to_f
        @time<< l.update_date.strftime('%m/%d')
      	if(count%step==0)
      	  time << l.update_date.strftime('%m/%d')
    	  end
      	count+=1
      end
    end
    timestr=''
    time.each do |s|
      timestr+=s+'|'
    end
    if timestr.size>0
      timestr=timestr[0,timestr.size-1]
    end
    #data=[1,2,3,4]
    if @data.size>0
      @img_url = Gchart.sparkline(:data => @data, :size => '400x300', :line_colors => '0077CC',:axis_with_labels => 'y,x',
      :max_value=>@data.max+1,:min_value=>@data.min-1)+'&chg=0,15&chls=3&chxl=1:|'+timestr + '&chf=bg,s,b2d9f3'
      if @data.size==3
        @img_url=fix_bug(@img_url)
      end
    end
    
    #@img_url = Gchart.line(:data => [0, 40, 10, 70, 20],:axis_with_labels => ['y'])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @loseweights }
    end
  end
  
  def fix_bug(str)
    if str.index 'chxr='
      s1=str[str.index('chxr='),str.size]
      s2=s1[0,s1.index('&')]
      s3=s2[0,s2.size-5]
      puts 's3=' +s3
      return  str[0,str.index('chxr=')] + s3 + s1[s1.index('&'),s1.size]
    end
    str
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
    if @loseweight.remark
    	@loseweight.remark.delete "-"
  	end
    respond_to do |format|
      if @loseweight.save
        format.html { redirect_to "/loseweights" }
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
        format.html { redirect_to "/loseweights" }
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
