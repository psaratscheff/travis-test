class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
  end

  def instagram_tag
    render json: {Implementado: false}
  end
end
