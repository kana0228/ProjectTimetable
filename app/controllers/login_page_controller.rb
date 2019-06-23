class LoginPageController < ApplicationController
  def login
      @user = User.new
   # # request.env['omniauth.auth']にユーザのTwitter認証情報が格納されている
   #  user_data = request.env['omniauth.auth']
   #  logger.debug("debug!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
   #  logger.debug(user_data.inspect)
   #  logger.debug("debug Complete!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
   #  session[:nickname] = user_data[:info][:nickname]
#   redirect_to main_page_show_path, notice: 'ログインしました'
  end
  
  def create
      if params[:user][:user_name] == nil || params[:user][:password] == nil
          flash[:danger] = "Please input the Your name or Password"
          redirect_to :root
      
      end
      user = User.find_by(user_name: params[:user][:user_name])
      
      if user && user.authenticate(params[:user][:password])
          session[:user_id] = user.id
          session[:nickname] = user.user_name
          redirect_to main_page_show_path
      else
          flash[:danger] = "Wrong Username or Password. <br> Please confirm Username or Password"
          redirect_to :root
      end
      
  end
end
