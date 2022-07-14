class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :set_locale

  private

  def record_not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end

  def set_locale
    cookies.permanent[:locale] = params[:locale] if params[:locale].present?

    locale = cookies[:locale].to_s.strip.to_sym

    I18n.locale = locale if I18n.available_locales.include?(locale)
  end

  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end

  # def default_url_options
  #   {locale: I18n.locale}
  # end
end
