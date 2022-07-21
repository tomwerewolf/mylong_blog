module ExceptionHandle
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  end

  private

  def record_not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
