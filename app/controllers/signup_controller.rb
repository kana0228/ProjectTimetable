class SignupController < ApplicationController

  def view
    @user = User.new
  end

  def create
    begin
      #Error handling Start!
      newUser = User.new(user_params)
      if newUser.valid?
          newUser.save!
          flash[:success] = "Created Your account !"
          redirect_to :root
      else 
          flash[:danger] = "password and password_confirmation are different.<br> Please make sure password"
          redirect_to signup_view_path
      end
    rescue => e #Error handling! 想定するエラーとしては、すでに存在しますなどのSQLエラー
        p e
        flash[:danger] = "Aleady exists Username"
        redirect_to signup_view_path
    end
     
  end

  private
    def user_params
        params.require(:user).permit(:user_name, :password, :password_confirmation)
    end
  
end
