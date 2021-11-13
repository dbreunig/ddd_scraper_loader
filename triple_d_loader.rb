require 'json'
require 'sequel'
require 'geocoder'

@db = Sequel.sqlite('ddd.db')

# Migrate the db, if needed
@db.create_table?(:destinations) do
    primary_key :id
    String  :name, null: false
    String  :description, text: true
    Float   :latitude
    Float   :longitude
    String  :house_number
    String  :road
    String  :city
    String  :county
    String  :state
    String  :postcode
    String  :country
    String  :address_string
    index [:latitude, :longitude]
    index :name
    index :state
end

# Read in the JSON
filedata    = File.read('ddd.json')
diners      = JSON.parse(filedata)

# Step through the JSON, geocode it, and load it
diners.each do | diner |
    results = Geocoder.search(diner['address'])
    p diner
    p results
    unless results.empty?
        result = results.first.data
        address = result['address']
        @db[:destinations].insert(
            name: diner['title'],
            description: diner['description'],
            latitude: result["lat"],
            longitude: result["lon"],
            house_number: address['house_number'],
            road: address['road'],
            city: address['city'],
            county: address['county'],
            state: address['state'],
            postcode: address['postcode'],
            country: address['country'],
            address_string: diner['address']
        )
    else
        @db[:destinations].insert(
            name: diner['title'],
            description: diner['description'],
            address_string: diner['address']
        )
    end
end

#<Geocoder::Result::Nominatim:0x0000000148c91ac8 @data=
{
    "place_id"=>65885532, 
    "licence"=>"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright", 
    "osm_type"=>"node", 
    "osm_id"=>6068492673, 
    "boundingbox"=>["44.0464259", "44.0465259", "-121.311051", "-121.310951"], 
    "lat"=>"44.0464759", 
    "lon"=>"-121.311001", "display_name"=>"CR Property Management, 384, Southwest Upper Terrace Drive, Bend, Deschutes County, Oregon, 97702, United States", "class"=>"office", "type"=>"company", "importance"=>0.621, "address"=>{"office"=>"CR Property Management", "house_number"=>"384", "road"=>"Southwest Upper Terrace Drive", "city"=>"Bend", "county"=>"Deschutes County", "state"=>"Oregon", "postcode"=>"97702", "country"=>"United States", "country_code"=>"us"}}