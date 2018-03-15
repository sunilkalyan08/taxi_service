$redis = Redis::Namespace.new("site_point", :redis => Redis.new)
$cab_hash = [{location: "BTM 2nd stage", lat: 12.9165757, lng: 77.61011630000007,status: "Available", color: "Pink", uid: "ABGD", name: "Taxi 1", number: "1234567890"},{location: "Marathahalli", lat: 12.9591722, lng: 77.69741899999997, status: "Busy", color: "Black", uid: "GGHC",name: "Taxi 2", number: "9898989898" },{location: "Bellandur", lat: 12.926303, lng: 77.675278, status: "Available", color: "Pink", uid: "JKKII",name: "Taxi 3", number: "9898989897" }]
$redis.set("cab_list", $cab_hash.to_json)
