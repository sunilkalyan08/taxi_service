Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'api/customer_booking',to: "api/customer_bookings#booking"
  get 'api/complete_ride', to: "api/customer_bookings#complete_ride"

end
