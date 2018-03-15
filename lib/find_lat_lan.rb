class FindLatLan
  include HTTParty

  def initialize(address)
    api_key = Rails.configuration.gecoder_api
    @options = { query: {address: address, key: api_key } }
  end

  def get_coord
    result = self.class.get("https://maps.googleapis.com/maps/api/geocode/json?", @options)
    if result['status'] == "OK"
      res = result['results'][0]
      return res
    end
  end
end
