class ZohoController < ApplicationController
  include HTTParty

  # Configura el endpoint base para las solicitudes
  base_uri 'https://accounts.zoho.com/oauth/v2'

  def refresh_token
    # Reemplaza estos valores con tus credenciales
    client_id = ''
    client_secret = ''
    refresh_token = ''

    response = self.class.post('/token', {
      body: {
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token,
        grant_type: 'refresh_token'
      }
    })

    if response.success?
      @response = response.parsed_response
    else
      @error = response.body
    end

    render :refresh_token
  end
end
