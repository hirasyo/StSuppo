class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(name: params[:user][:name])
    if user.save
      @monster = Monster.all
      redirect_to :root, layout: "application.html.erb", success: '登録が完了しました'
    else
      redirect_to new_user_url, danger:'登録済みの名前または空白です'
    end

  end

end
