# app/helpers/quotes_helper.rb
module QuotesHelper
  def format_date(date_string)
    return 'N/A' if date_string.blank?

    begin
      date = DateTime.parse(date_string)
      l(date.to_date, format: :long) # Usa el formato :long o cualquier formato que prefieras
    rescue ArgumentError
      'Invalid Date'
    end
  end
end
