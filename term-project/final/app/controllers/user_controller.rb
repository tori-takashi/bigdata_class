class UserController < ApplicationController
  require 'securerandom'
  def new
    @user = User.new
  end

  def create
    if User.new(register_params).valid?
      parameters = register_params
      user_hash = SecureRandom.uuid

      parameters[:user_hash] = user_hash
      User.new(parameters).save!
      session[:id] = User.find_by(user_hash: user_hash).id
      redirect_to article_index_path
    else
      render 'new'
    end
  end

  def login
    @user = User.new
  end

  def auth
    user = User.find_by(email: login_params[:email])
    if user.authenticate(login_params[:password])
      session[:id] = user.id
      redirect_to article_index_path
    else
      render user_login_path
    end
  end

  def logout
    session[:id] = nil
    redirect_to article_index_path
  end

  private def register_params
    params.require(:user).permit(:user_id, :email, :password, :password_confirmation)
  end

  private def login_params
    puts params
    params.require(:user).permit(:email, :password)
  end

end
