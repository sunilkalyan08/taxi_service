class Api::CustomerBookingsController < Api::ApiController
  require 'find_lat_lan.rb'
  def booking
    if params[:address] && params[:contact_number].present?
      @coordinates = {}
      @address = params[:address]
      @contact_number = params[:contact_number]
      @color = params[:color]
      if params[:lat].present? && params[:lan].present?
        @coordinates[:lat] = params[:lat]
        @coordinates[:lng] = params[:lng]
      end
      if @address
        lat_lan = FindLatLan.new(@address)
        json_response = lat_lan.get_coord
        if json_response.present?
          @coordinates = json_response['geometry']['location']
        end
      end
      # if @coordinates.present?
        # $redis.set(@contact_number, @coordinates.to_json)
      # end
      # render json: {message: "Please wait for taxi allocation"}
      get_cabs_list
    else
      render json: {message: "Required Mandotory Parameters"}, status: 422
    end
  end

  def get_cabs_list
    nearest_cabs,cabs_list = CabService.new(@contact_number, @coordinates, @color).nearest_cabs if @coordinates.present?
    if nearest_cabs.present?
      near_cab = nearest_cabs.sort_by{|uid, miles| miles}[0]
      cab_details = cabs_list.select{|cab| cab["uid"] == near_cab[0]} # Retrive Cab Details w.r.t Unique ID
      customer_details = @coordinates.merge!("cab_uid" => near_cab[0], "cus_number" => @contact_number)
      booking_id = @contact_number[0..5] + SecureRandom.hex(4)
      CabService.update_cab_status(cab_details, booking_id)
      $redis.set(booking_id, customer_details.to_json) # Store the booking details w.r.t customer number
      render json: {cab_details: [name: cab_details[0]["name"], number: cab_details[0]["number"], booking_id: booking_id]}, status: 200
    else
      render json: {message: "No Cabs are free to serve"}, status: 200
    end
  end

  def complete_ride
    # By Cab Driver
    if params[:booking_id].present? && params[:drop_address].present?
      @coordinates = {}
      booking_id = params[:booking_id]
      @address = params[:drop_address]
      if params[:lat].present? && params[:lan].present?
        @coordinates[:drop_lat] = params[:drop_lat]
        @coordinates[:drop_lng] = params[:drop_lng]
      end
      if @address
        lat_lan = FindLatLan.new(@address)
        json_response = lat_lan.get_coord
        if json_response.present?
          @coordinates = json_response['geometry']['location']
          location = json_response["formatted_address"]
        end
      end
      booking_details = JSON.parse($redis.get(booking_id)) # Get the booking details w.r.t booking_id for getting cab Unique ID
      cab_uid = booking_details["cab_uid"]
      CabService.update_complet_cab(cab_uid, @coordinates, location) # Update Cab status w.r.t location and availablility
      render json: {message: "Ride completed Successfully"}, status: 200
    else
      render json: {message: "Required Mandotory Parameters"}, status: 422
    end
  end



end
