class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout :layout

  private

  before_filter :layout

  def layout
    ze_layout = nil
    if request.xhr?
    # only turn it off for login pages:
    ze_layout = (is_a?(Devise::SessionsController) || is_a?(Devise::PasswordsController) || is_a?(Devise::RegistrationsController) ) ? false : nil
    # or turn layout off for every devise controller:
    # devise_controller? && "application"
    else
      @has_layout = true
    end
    ze_layout
  end
end
