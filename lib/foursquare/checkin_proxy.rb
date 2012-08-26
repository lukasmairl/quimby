module Foursquare
  class CheckinProxy
    def initialize(foursquare)
      @foursquare = foursquare
    end

    def find(id)
      Foursquare::Checkin.new(@foursquare, @foursquare.get("checkins/#{id}")["checkin"])
    end
    
    def merge_auth_params(params)
      if @access_token
        params.merge!(:oauth_token => @access_token)
      else
        params.merge!(:client_id => @client_id, :client_secret => @client_secret)
      end
    end
    
    def reply(checkin_id, options={})
      puts "---- hello 3333333 ----"
      #puts '-------- testing checkin_id -------'
      #puts checkin_id
      #puts options.to_yaml
      #response = Typhoeus::Request.post("https://api.foursquare.com/v2/checkins/#{checkin_id}", options)
      #Foursquare::Checkin.new(@foursquare, @foursquare.post("checkins/#{checkin_id}", options))
      #@foursquare.post("checkins/#{checkin_id}", options)s
      
      #puts "------ second ---------"
      #merge_auth_params(params)
      #response = Typhoeus::Request.post("https://api.foursquare.com/v2/checkins/#{checkin_id}/reply", :params => params)
      #puts response.inspect
      
      
      #puts response.inspect
      #Foursquare.log(response.inspect)
      #error(response) || response["response"]
      
      @foursquare.post("checkins/#{checkin_id}", options)
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
