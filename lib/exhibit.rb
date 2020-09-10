class Exhibit
  attr_reader :name, :cost 

  def initialize(info)
    @info = info
    @name = info[:name]
    @cost = info[:cost]
  end
end
