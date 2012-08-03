#encoding: UTF-8
require 'googlecharts'
class LoseweightsController < ApplicationController
  def authorize
    if cookies[:remember_me]
      puts 'admin tianjj'
      session[:admin] = 'admin'
    end
    unless session[:admin] 
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
  # GET /loseweights
  # GET /loseweights.json
  def index
    @loseweights = Loseweight.all
    
    data = []
    @loseweights.each do |l|
      if l.weight.to_i.to_s==l.weight 
      	data<<Integer(l.weight)
      end
    end
    #data=[1,2,3,4]
    @img_url = Gchart.line(:data => data, :size => '400x300', :line_colors => '0077CC',:axis_with_labels => 'y')
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
