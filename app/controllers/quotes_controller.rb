class QuotesController < ApplicationController
  include HTTParty

  base_uri 'https://www.zohoapis.com/crm/v2'
  TOKEN_CACHE_KEY = 'zoho_access_token'

  def index
    access_token = Rails.cache.read(TOKEN_CACHE_KEY)

    if access_token.nil?
      refresh_token
      access_token = Rails.cache.read(TOKEN_CACHE_KEY)
      Rails.logger.info("Token refreshed: #{access_token}")
    end

    Rails.logger.info("Token from cache: #{access_token}")

    if access_token
      response = self.class.get('/Quotes', {
        headers: {
          'Authorization': "Bearer #{access_token}"
        }
      })

      if response.success?
        @quotes = response.parsed_response['data']
      else
        handle_token_error(response)
      end
    else
      @error = 'No access token available'
    end
  end

  private

  def refresh_token
    client_id = '1000.1WCMNXDE70J46UUES27T0SVWK9LE2I'
    client_secret = '0bcebfa070a62e834f56b5e8a01ccc27f7179d7e35'
    refresh_token = '1000.808ddd526b4a299d5ab0cde834eaecaa.fcffbae796f7aabb1188b9a5af373c4c'

    response = self.class.post('https://accounts.zoho.com/oauth/v2/token', {
      body: {
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token,
        grant_type: 'refresh_token'
      }
    })

    if response.success?
      Rails.cache.write(TOKEN_CACHE_KEY, response.parsed_response['access_token'], expires_in: 30.minutes)
    else
      Rails.logger.error("Failed to refresh token: #{response.body}")
    end
  end

  def handle_token_error(response)
    if response.code == 401
      Rails.cache.delete(TOKEN_CACHE_KEY) # Borra el token expirado
      refresh_token # Intenta refrescar el token
      redirect_to quotes_path # Redirige para intentar de nuevo
    else
      Rails.logger.error("Error fetching quotes: #{response.body}")
      @error = 'Error fetching quotes'
    end
  end

end
