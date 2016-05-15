# Global variables are defined here
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  $access_token = '2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402'
  $version = 'v1.0.2'
end
