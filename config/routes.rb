Rails.application.routes.draw do
  # Ruta para refrescar el token
  root "zoho#refresh_token"

  get 'zoho/refresh_token', to: 'zoho#refresh_token'
end
