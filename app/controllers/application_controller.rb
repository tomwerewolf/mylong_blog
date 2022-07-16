class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
  include ExceptionHandle
  before_action :set_locale

  private

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
