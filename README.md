# README

Dependencies
 1. Ruby Version 2.4.2
 2. Rails Version 5.1.5

 SetUp
 1. Clone the repo via SSH or https.
 2. Make Sure Run the Bundle install before running application
 3. Test Data stored in Redis Memory
 4. <b>API endpoints</b>
  <br>
  i) Customer Booking: Request Type: GET , Url: {server_ip}/api/customer_booking, parameters: {contact_number: "<contact_number>", address: <address>}<br>
  ii) Complete Ride by Driver: Request Type: GET , Url: {server_ip}/api/complete_ride, parameters: {booking_id: "<booking_id>", drop_address: <drop_address>} <br><br>
