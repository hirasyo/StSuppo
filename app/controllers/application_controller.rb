class ApplicationController < ActionController::Base
  require 'open-uri'
  require 'nokogiri'

  add_flash_types :success, :info, :warning, :danger

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    @current_user_name ||= @current_user[:name]
  end

  def logged_in?
    !current_user.nil?
  end
end
