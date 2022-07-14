module SessionAction
  extend ActiveSupport::Concern
  included do
    before_action :find_user, only: :create
  end

  private

  def find_user
    @user = User.find_by(username: params[:session][:username].downcase)
  end
end
