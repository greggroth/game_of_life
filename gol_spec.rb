require "gol"

describe 'Game of Life' do
  let(:world) { World.new }
  context "cell utility methods" do
    subject { Cell.new(world) }
    
    it "spawn relative to" do
      cell = subject.spawn_at(3,5)
      cell.is_a?(Cell).should be_true
      cell.x.should == 3
      cell.y.should == 5
      cell.world.should == subject.world
    end
    
    it "detects a neighbour to the north" do
      cell = subject.spawn_at(0, 1)
      subject.neighbors.count.should == 1
    end

    it "detects a neighbour to the north east" do
      cell = subject.spawn_at(1, 1)
      subject.neighbors.count.should == 1
    end

    it "detects a neighbour to the left" do
      cell = subject.spawn_at(-1, 0)
      subject.neighbors.count.should == 1
    end

    it "detects a neighbour to the right" do
      cell = subject.spawn_at(1, 0)
      subject.neighbors.count.should == 1
    end

    it "dies" do
      subject.die!
      subject.world.cells.should_not include(subject)
    end
    
    it "flags all around itself" do
      subject.flag_around
      world.flags.count.should == 8
    end
  end
  
  context "flag utilty rules" do
    subject { Flag.new(world) }
    it "places another flag at 0,0" do
      flag = subject.place_at(0,0)
      world.flags.count.should == 2
    end
  end
  
  context "Rule" do
    # subject { Cell.new(world) }
    
    it "#1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
      cell = Cell.new(world)
      cell.spawn_at(2,0)
      world.tick!
      cell.should be_dead
    end

    it "#2: Any live cell with two or three live neighbours lives on to the next generation." do
      cell = Cell.new(world)
      cell.spawn_at(1,0)
      cell.spawn_at(-1, 0)
      world.tick!
      cell.should be_alive
    end
    
    it "#3: Any live cell with more than three live neighbours dies, as if by overcrowding." do
      cell = Cell.new(world)
      cell.spawn_at(1,0)
      cell.spawn_at(1,1)
      cell.spawn_at(1,-1)
      cell.spawn_at(-1,0)
      world.tick!
      cell.should be_dead
    end
    
    it "#4:  Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
      cell = Cell.new(world)
      cell.spawn_at(1,0)
      cell.spawn_at(0,1)
      world.tick!
      world.cells.map { |i| [i.x, i.y] }.should == [[0,0],[1,0],[0,1],[1,1]]
    end
  end
end