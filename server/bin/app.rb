puts "This is process #{Process.pid}"

require_relative 'JSONable'
require 'sinatra'
require 'json'


get '/' do
  halt 404
end

get '/api/trackables' do
  content_type :json
  t = Trackable.new
  t.name = 'Happiness'
  t.scores << Score.new(7, 'great day')
  t.scores << Score.new(10, 'everyday i\'m bustin')
  ts = Trackables.new
  ts.items << t
  
  t = Trackable.new
  t.name = 'Creativity'
  t.scores << Score.new(5, 'ok')
  t.scores << Score.new(10, 'inspired!')
  ts.items << t
    
  return ts.to_json
end

post '/api/trackables', :provides => :json do
  # Do something with the params, then…
  #  halt 200, params.to_json 
  body = request.env["rack.input"].read
  json = JSON.parse body
    
  dump = ''
  json["items"].first["scores"].each{|h|
    dump << h["rating"].to_s + ':' + h["notes"].to_s
  }
  
  halt 200, dump
end

class Trackables < JSONable
   attr_accessor :items
   def initialize()
       self.items = []
   end
end

class Trackable < JSONable
   attr_accessor :name, :created, :scores
   def initialize()
       self.created = DateTime.now
       self.scores = []
   end
end

class Score < JSONable
  attr_accessor :created, :rating, :notes
  def initialize(r,n = nil)
    self.rating = r
    self.notes = n
    self.created = DateTime.now
  end
end
