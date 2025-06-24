class SessionsController < ApplicationController
  def new
    # Login form
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # Get or create default OAuth application
      app = Doorkeeper::Application.find_or_create_by(name: 'Portfolia Web App') do |application|
        application.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
        application.scopes = ''
      end

      # Generate OAuth token
      token = Doorkeeper::AccessToken.create!(
        resource_owner_id: user.id,
        application_id: app.id,
        expires_in: Doorkeeper.configuration.access_token_expires_in,
        scopes: ''
      )

      # Store user in session for web UI
      session[:user_id] = user.id

      # Return token for API or redirect for web
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: 'Logged in successfully!' }
        format.json { render json: { access_token: token.token, token_type: 'Bearer' } }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:alert] = 'Invalid email or password'
          render :new, status: :unprocessable_entity
        }
        format.json { render json: { error: 'Invalid credentials' }, status: :unauthorized }
      end
    end
  end

  def destroy
    # Revoke OAuth token if present
    if doorkeeper_token
      doorkeeper_token.revoke
    end

    # Clear session
    session[:user_id] = nil

    redirect_to root_path, notice: 'Logged out successfully!'
  end
end
