module Foursquare
  class CheckinProxy
    def initialize(foursquare)
      @foursquare = foursquare
    end

    def find(id)
      Foursquare::Checkin.new(@foursquare, @foursquare.get("checkins/#{id}")["checkin"])
    end
    
    def reply(checkin_id, options={})
      puts '-------- checkin_id -------'
      puts checkin_id
      puts options.to_yaml
      response = Typhoeus::Request.post("checkins/#{checkin_id}", options)
      #puts response.to_yaml
      #Foursquare.log(response.inspect)
      #error(response) || response["response"]
      
      #@foursquare.post("checkins/#{checkin_id}", options)
      #Foursquare::Checkin.new(@foursquare, @foursquare.post("checkins/#{checkin_id}", options))
    end

    def recent(options={})
      @foursquare.get("checkins/recent", options)["recent"].map do |json|
        Foursquare::Checkin.new(@foursquare, json)
      end
    end

    def all(options={})
      @foursquare.get("users/self/checkins", options)["checkins"]["items"].map do |json|
        Foursquare::Checkin.new(@foursquare, json)
      end
    end

    def create(options={})
      if json = @foursquare.post("checkins/add", options)
        Foursquare::Checkin.new(@foursquare, json["checkin"])
      else
        nil
      end
    end
    alias_method :add, :create
  end
end
