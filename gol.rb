class Cell
  attr_accessor :world, :x, :y
  
  def initialize(world,x=0,y=0)
    @world = world
    @x = x
    @y = y
    world.cells << self
  end
  
  def spawn_at(x,y)
    Cell.new(world, x, y)
  end
  
  def neighbors
    @neighbors = []
    world.cells.each do |cell|
      if (self.x == cell.x-1 || self.x == cell.x || self.x == cell.x+1) && (self.y == cell.y-1 || self.y == cell.y || self.y == cell.y+1)
        @neighbors << cell unless (self.x == cell.x && self.y == cell.y)
      end
    end
    return @neighbors
  end
  
  def die!
    world.cells -= [self]
  end
  
  def dead?
    !alive?
  end
  
  def alive?
    world.cells.include?(self)
  end
  
  def flag_around
    # Place flags around the cell
    Flag.new(world, x-1, y-1)
    Flag.new(world, x-1, y)
    Flag.new(world, x-1, y+1)
    Flag.new(world, x, y+1)
    Flag.new(world, x+1, y+1)
    Flag.new(world, x+1, y)
    Flag.new(world, x+1, y-1)
    Flag.new(world, x, y-1)
  end
end

class Flag
  attr_accessor :world, :x, :y
  
  def initialize(world,x=0,y=0)
    @world = world
    @x = x
    @y = y
    world.flags << self
  end
  
  def place_at(x,y)
    Flag.new(world, x, y)
  end
end

class World
  attr_accessor :cells, :flags
  
  def initialize
    @cells = []
    @flags = []
  end
  
  def tick!
    cells.each do |cell|
      cell.die! if (cell.neighbors.count < 2 or cell.neighbors.count > 3)
      if cell.neighbors.count > 1
         cell.flag_around
      end
    end
    
    investigate = flags.map { |f| [f.x, f.y] }.inject(Hash.new(0)) { |h,v| h[v] += 1; h }.reject { |k,v| v != 3 }
    unless investigate.empty?
      investigate.each_pair do |coordinates, count|
        Cell.new(self,coordinates[0],coordinates[1])
      end
    end
    
    @flags = []
  end
end