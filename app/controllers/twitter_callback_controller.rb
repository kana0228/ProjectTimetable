class TwitterCallbackController < ApplicationController
    def create
    #   # request.env['omniauth.auth']にユーザのTwitter認証情報が格納されている
    #user_data = request.env['omniauth.auth']
    # logger.debug("debug!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    # logger.debug(user_data.inspect)
    # logger.debug("debug Complete!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    #session[:nickname] = user_data[:info][:nickname]
    
    
    user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    # session[:nickname] = user_data[:info][:nickname]
    session[:nickname] = user.user_name
    redirect_to main_page_show_path #notice: 'ログインしました' 
    end
    
    def destory
     reset_session
    #flash[:notice] = "ログアウトしました。"
    redirect_to root_path
    end
end


