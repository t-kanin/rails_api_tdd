class AccessTokensController < ApplicationController 
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform #authentication_error is called when AuthenticationError is raised
  end

  private 

  def authentication_error 
    error = {
      :status => "401",
      :source => {:pointer => "/code"},
      :title => "Authentication is invalid",
      :detail => "You must provide valid code in order to exchange it for token." 
    }
    
    render json: { "errors": [ error ] }, status: 401 
  end 

end