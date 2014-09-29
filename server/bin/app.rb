puts "This is process #{Process.pid}"

require 'sinatra'
require 'json'

get '/' do
  'Hello world!'
end

get '/entity' do
  content_type :json
  a = Trackable.new
  a.name = 'Happiness'
  a.scores << Score.new(5, 'great day')
  a.scores << Score.new(10, 'everyday i\'m bustin')
    
  return a.to_json
end


class JSONable
    def to_json(*a)
      hash = {}
      self.instance_variables.each do |var|
        name = var[1..-1]
        hash[name] = self.instance_variable_get var
      end
      hash.to_json(*a)
    end

    def ref_children
      return self.instance_variables.map { |var| self.instance_variable_get var }
    end

    def declare(&block)
      self.instance_eval &block if block_given?
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
