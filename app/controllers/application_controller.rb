class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  before_action :require_login
  before_action :set_locale

  private

  def require_login
    unless logged_in?
      redirect_to login_path
    end
  end

  def record_not_found
    render :file => "#{Rails.root}/public/404.html",  :status => 404
  end

  def set_locale
    if(params[:locale].present?)
      cookies.permanent[:locale] = params[:locale]
    end

    locale = cookies[:locale].to_s.strip.to_sym

    if I18n.available_locales.include?(locale)
        I18n.locale = locale
    end
  end

end
