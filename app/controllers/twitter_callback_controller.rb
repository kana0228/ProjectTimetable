class TwitterCallbackController < ApplicationController
    def create
    user = User.find_or_create_from_auth(request.env['omniauth.auth'])
     # request.env['omniauth.auth']にユーザのTwitter認証情報が格納されている
     # find_or_create_from_auth()はuser.rbに宣言されています。
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


