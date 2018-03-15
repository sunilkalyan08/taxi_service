class CabService

  def initialize(number, coordinates, color=nil)
    @contact_number = number
    @cabs = JSON.parse($redis.get("cab_list"))
    @nearest_cabs = {}
    @customer_cordinates = coordinates
    @color = color
  end

  def nearest_cabs
    available_cabs = @cabs.select{|cab| cab["status"] == "Available"} # Select the cabs which are only available to serve
    available_cabs = @cabs.select{|cab| cab["color"] == @color} if @color.present?
    available_cabs.each do |cab_service|
      cab_lat = cab_service["lat"]
      cab_lng = cab_service["lng"]
      uid = cab_service["uid"]
      distance_between_coordinates(cab_lat, cab_lng, uid)
    end
    return @nearest_cabs, @cabs
  end

  def distance_between_coordinates(cab_lat, cab_lan, uid)
    cust_lat = @customer_cordinates["lat"]
    cust_lng = @customer_cordinates["lng"]
    distance = Math.sqrt((cab_lat - cust_lat)**2  + (cab_lan - cust_lng)**2) * 3960 * (3.1415/180)
    @nearest_cabs.merge!(uid => distance)
  end

  def self.update_cab_status(cab_details, booking_id, options={})
    $cab_hash.each{|cab| cab[:uid] == cab_details[0]["uid"] ? cab[:status] = "Busy" : ''}
    $cab_hash.each{|cab| cab[:uid] == cab_details[0]["uid"] ? cab[:booking_id] = booking_id : ''}
    $redis.set('cab_list', $cab_hash.to_json)
  end

  def self.update_complet_cab(cab_uid,coordinates, location)
    dri_lat = coordinates["lat"]
    dri_lng = coordinates["lng"]
    $cab_hash.each{|cab| cab[:uid] == cab_uid ? cab[:status] = "Available" : ''}
    $cab_hash.each{|cab| cab[:uid] == cab_uid ? cab[:lat] = dri_lat : ''}
    $cab_hash.each{|cab| cab[:uid] == cab_uid ? cab[:lng] = dri_lng : ''}
    $cab_hash.each{|cab| cab[:uid] == cab_uid ? cab[:location] = location : ''}
    $redis.set('cab_list', $cab_hash.to_json)
  end
end
