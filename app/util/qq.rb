#encoding=utf-8
#以下不需要改动
AUTHURL='https://graph.qq.com/oauth2.0/authorize?'
TOKENURL='https://graph.qq.com/oauth2.0/token?'
OPENIDURL='https://graph.qq.com/oauth2.0/me?access_token='
GETUSERINFOURL='https://graph.qq.com/user/get_user_info?'
ADDSHAREURL='https://graph.qq.com/share/add_share'
CHECKPAGEFANSURL='https://graph.qq.com/user/check_page_fans?'
ADDTURL='https://graph.qq.com/t/add_t'
ADDPICTURL='https://graph.qq.com/t/add_pic_t'
ADDPICURL='https://open.t.qq.com/api/t/add_pic_url'
DELTURL='https://graph.qq.com/t/del_t'
GETREPOSTLISTURL='https://graph.qq.com/t/get_repost_list?'
GETINFOURL='https://graph.qq.com/user/get_info?'
GETOTHERINFOURL='https://graph.qq.com/user/get_other_info?'
GETFANSLISTURL='https://graph.qq.com/relation/get_fanslist?'
GETIDOLLISTURL='https://graph.qq.com/relation/get_idollist?'
ADDIDOLURL='https://graph.qq.com/relation/add_idol'
DELIDOLURL='https://graph.qq.com/relation/del_idol'
APPID= '100295213'#'100295213'
REDURL='&redirect_uri=http://www.heasenbug.me/loseweights/qqlogin'
APPKEY='3cfeb3faf4aa0b1e86fd1f9246f7074a'


OPEN_GETUSERINFO= 'http://openapi.tencentyun.com/v3/user/get_info?' #'http://119.147.19.43/v3/user/get_info?'
OPEN_WORD_FILTER = 'http://119.147.19.43/v3/csec/word_filter'
OPEN_APPID='100650681'
OPEN_APPKEY='208cab1f3a57a2d4bf8db2c29096c97d'

OPEN_ACCESS_TOKEN='http://openapi.qzone.qq.com/oauth/qzoneoauth_access_token?oauth_version=1.0&oauth_signature_method=HMAC-SHA1'

require 'net/http'
require 'uri'
require 'open-uri'
require 'rest-client'
require 'multi_json'
require 'hmac-sha1'


class Qq
	attr_accessor :token,:openid,:auth
	
	#点击登陆按钮跳转地址
	def Qq.redo(scope)
		AUTHURL + 'response_type=code&client_id='+ APPID + REDURL + '&scope=' + scope
	end
	
	#获取令牌:认证码code=params[:code],httpstat=request.env['HTTP_CONNECTION']
	def get_token(code,httpstat)
	  puts 'get_token....'
	  #ts = open(TOKENURL + 'grant_type=authorization_code&client_id=' + APPID + '&client_secret=' + APPKEY + '&code=' + code + REDURL).read
	  #puts "ts:" + ts
		#获取令牌
		@token=open(TOKENURL + 'grant_type=authorization_code&client_id=' + APPID + '&client_secret=' + APPKEY + '&code=' + code + REDURL).read[/(?<=access_token=)\w{32}/]
		puts @token
		#获取Openid
		@openid=open(OPENIDURL + @token).read[/\w{32}/]		
		#获取通用验证参数
		@auth='access_token=' + @token + '&oauth_consumer_key=' + APPID + '&openid=' + @openid
	end
	
	#获取令牌:认证码code=params[:code],httpstat=request.env['HTTP_CONNECTION']
	def get_token_openqq(code,httpstat)
	  puts 'get_token....'
		#获取令牌
		@token=open(TOKENURL + 'grant_type=authorization_code&client_id=' + APPID + '&client_secret=' + APPKEY + '&code=' + code + '&state='+ httpstat + REDURL).read[/(?<=access_token=)\w{32}/]
		puts @token
		#获取Openid
		@openid=open(OPENIDURL + @token).read[/\w{32}/]		
		#获取通用验证参数
		@auth='access_token=' + @token + '&oauth_consumer_key=' + APPID + '&openid=' + @openid
	end
	
	def get_all_url(token,openid)
	  @token=token
	  @openid=openid
	  all_url='access_token=' + @token + '&oauth_consumer_key=' + APPID + '&openid=' + @openid
  end
	
	#post包的通用模版,用于没有附件的情况
	#url:发送的网址
	#data:数据
	def post_comm(url,data)
		com=URI.parse(url)
		if url.include?'https://'
			res=Net::HTTP.new(com.host,443)
			res.use_ssl=true
		else
			res=Net::HTTP.new(com.host)
		end
		res=res.post(com.path,data).body
	end
	
	#获取用户信息:比如figureurl,nickname
	def get_user_info(auth)
		MultiJson.decode(open(GETUSERINFOURL + auth).read.force_encoding('utf-8'))
	end
  
  #获取openqq用户信息
  def get_open_user_info(openid,openkey,pf,ip)
    if !openid || !openkey || !pf || !ip
      return nil
    end
    prefix = 'GET&%2Fv3%2Fuser%2Fget_info&'
    params_req = 'appid='+OPEN_APPID + '&format=json&ip='+ip+'&openid='+openid + '&openkey='+openkey+'&pf='+pf
    signature = prefix + CGI.escape(params_req)
    hmac = HMAC::SHA1.new(OPEN_APPKEY+'&')
    hmac.update(signature)
    result_key= CGI.escape(Base64.strict_encode64("#{hmac.digest}"))
    uri = OPEN_GETUSERINFO + params_req+'&sig='+result_key
    MultiJson.decode(open(uri).read.force_encoding('utf-8'))
  end
  
  def open_word_filter(openid,openkey,pf,ip,content,msgid)
    if !openid || !openkey || !pf || !ip
      return nil
    end
    prefix = 'POST&%2Fv3%2Fcsec%2Fword_filter&'
    params_req = 'appid='+OPEN_APPID + '&content=' + content + '&format=json&msgid=' + msgid +'&openid='+openid + '&openkey='+openkey+'&pf='+pf +'&userip='+ip
    signature = prefix + CGI.escape(params_req)
    hmac = HMAC::SHA1.new(OPEN_APPKEY+'&')
    hmac.update(signature)
    sig =Base64.strict_encode64("#{hmac.digest}")
    result_key= CGI.escape(Base64.strict_encode64("#{hmac.digest}"))
    MultiJson.decode(RestClient.post(OPEN_WORD_FILTER,
													:appid=>OPEN_APPID,
													:content=>content,
													:format=>"json",
													:msgid=>msgid,
													:openid=>openid,
                          :openkey=>openkey,
                          :pf=>pf,
                          :userip=>ip,
                          :sig=>sig	))
  end
  
  #获取openapi登录的accesstoken
  def open_access_token
    access_token_url = OPEN_ACCESS_TOKEN + '&oauth_timestamp=' + Time.now.to_i + '&oauth_nonce=' + rand(999999) + '&oauth_consumer_key='+OPEN_APPID + ''
  end

	#发表一条说说到QQ空间
	def add_topic(auth,type)
		
	end
	
	#同步分享到QQ空间、朋友网、腾讯微博
	def add_share(auth,title,url,comment,summary,images,source,site,nswb,*play)
		data=auth + '&title=' + title + '&url=' + url + '&comment=' + comment + '&summary=' + summary + '&images=' + images + '&source=' + source + '&site=' + site + '&nswb=' + nswb + '&type=' + play[0]
		data=data + '&playurl=' + play[1] unless play.count ==1
		MultiJson.decode(post_comm(ADDSHAREURL,URI.escape(data)))
	end
	
	#验证登录的用户是否为某个认证空间的粉丝
	#page_id:认证空间的QQ号码,比如706290240
	def check_page_fans(auth,page_id)
		MultiJson.decode(open(CHECKPAGEFANSURL + auth + '&page_id=' + page_id).read.force_encoding('utf-8'))
	end
	
	#发表一条微博信息到腾讯微博
	def add_t(auth,clientip,jing,wei,syncflag,content)
		MultiJson.decode(post_comm(ADDTURL,URI.escape(auth + '&clientip=' + clientip + '&jing=' + jing + '&wei=' + wei + '&syncflag=' + syncflag + '&content=' + content)))
	end
  def test_add_pic
    MultiJson.decode(RestClient.post(ADDPICURL,
													:access_token=>"afba8e37b6ef7672b8cc9014eb6a1874",
													:oauth_consumer_key=>"801058005",
													:openid=>"674C462EC9D1015F3A7FA56478CFA0AD",
													:clientip=>"122.194.1.31",
													:syncflag=>"0",
													:content=>"test",
													:pic_url=>"http://t2.qpic.cn/mblogpic/9c7e34358608bb61a696/2000",
													:format=>"json",
													:oauth_version=>"2.a",
													:scope=>"all"	))
  end
	#上传图片并发表消息到腾讯微博
	def add_pic_t(token,openid,clientip,jing,wei,syncflag,content,pic)
		MultiJson.decode(RestClient.post(ADDPICTURL,
													:access_token=>token,
													:oauth_consumer_key=>APPID,
													:openid=>openid,
													:clientip=>clientip,
													:jing=>jing,
													:wei=>wei,
													:syncflag=>syncflag,
													:content=>content,
													:pic=>pic))
	end
	
	def add_pic_url(token,openid,clientip,jing,wei,syncflag,content,pic_url)
		MultiJson.decode(RestClient.post(ADDPICURL,
													:access_token=>"afba8e37b6ef7672b8cc9014eb6a1874",
													:oauth_consumer_key=>"801058005",
													:openid=>"674C462EC9D1015F3A7FA56478CFA0AD",
													:clientip=>clientip,
													:syncflag=>syncflag,
													:content=>content,
													:pic_url=>pic_url,
													:format=>"json",
													:oauth_version=>"2.a",
													:scope=>"all"))
	end
	
	#删除一条微博
	#id:被删除的微博号
	def del_t(auth,id)
		data=auth + '&id=' + id
		MultiJson.decode(post_comm(DELTURL,URI.escape(data)))
	end

	#获取一条微博的转播或评论信息列表
	def get_repost_list(auth,flag,rootid,pageflag,pagetime,reqnum,twitterid)
		MultiJson.decode(open(GETREPOSTLISTURL + auth + '&flag=' + flag +
				 						   '&rootid=' + rootid +
				 						   '&pageflag=' + pageflag +
				 						   '&pagetime=' + pagetime +
				 						   '&reqnum=' + reqnum +
				 						   '&twitterid=' + twitterid).read)
	end

	#获取腾讯微博登录用户的用户资料
	def get_info(auth)
		MultiJson.decode(open(GETINFOURL + auth).read.force_encoding('utf-8'))
	end

	#获取腾讯微博其他用户详细信息
	#name=其他用户账号名或openid,格式为name=peter或fopenid=******
	def get_other_info(auth,name)
		MultiJson.decode(open(GETOTHERINFOURL + auth + '&' + name).read.force_encoding('utf-8'))			
	end

	#获取登录用户的听众列表
	def get_fanslist(auth,reqnum,startindex,mode,install)
		MultiJson.decode(open(GETFANSLISTURL + auth + '&reqnum=' + reqnum + '&startindex=' + startindex + '&mode=' + mode + '&install=' + install))
	end

	#获取登录用户收听的人的列表
	def get_idollist(auth,reqnum,startindex,install)
		MultiJson.decode(open(GETIDOLLISTURL + auth + '&reqnum=' + reqnum + '&startindex=' + startindex + '&install=' + install))
	end

	#收听腾讯微博上的用户
	def add_idol(auth,name)
		MultiJson.decode(post_comm(ADDIDOLURL,URI.escape(auth + '&' + name)))
	end

	#取消收听腾讯微博上的用户
	def del_idol(auth,name)
		MultiJson.decode(post_comm(DELIDOLURL,URI.escape(auth + '&' + name)))	
	end

end