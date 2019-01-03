class SessionsController < ApplicationController
  def new
    @monster = []
    @history = []
    current_user
    out_history
  end

  def create
    user = User.find_by(name: params[:name])
    if user
      log_in user
      current_user

      redirect_to '/sessions/new'
    else

      redirect_to :root, danger:'登録されていないユーザーです'
    end
  end

  def destroy
    log_out
    redirect_to :root
  end

  def search
    @search = []
    @monster = []
    @history = []

    current_user

    if params[:search_regexp] == "完全一致検索"
      @search.push(Monster.find_by(name: params[:keyword]))
    else
      if !params[:keyword].empty?
        Monster.where('name LIKE ?', "%#{params[:keyword]}%").each {|search| @search.push(search)}
      end
    end

    if !@search.compact.empty?
      regist_history
    end

    @history = []
    out_history

    render partial: 'detail', locals: { :monster => @monster} and return

  end

  private
    def log_in(user)
      session[:user_id] = user.id
    end

    def log_out
      session.delete(:user_id)
      @current_user = nil
      @current_user_name = nil
    end

    def regist_history
      @search.each do |mons|
        @history = @current_user.histories.new(user_name: @current_user_name ,monster_name: mons[:name])
        @history.save!
      end
    end

    def out_history
      @history = History.where(user_name: "#{@current_user_name}")

      if !@history.nil?
        @history.each do |history|
          @monster.unshift(Monster.find_by(name: history[:monster_name]))
        end
      end
    end

end
