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