INPUT = <<-INPUT
2238518614
4552388553
2562121143
2666685337
7575518784
3572534871
8411718283
7742668385
1235133231
2546165345
INPUT

struct Point
    property col, row

    def initialize(@row : Int32, @col : Int32)
    end
end

grid = INPUT.split("\n").map do |row|
    row.split("").map(&.to_i)
end

p! simulate(grid, 100)

def simulate(grid, steps = 1)
    flashes = 0
    steps.times do |n|
        this_step = step(grid)
        flashes += this_step
    end
    flashes
end

def step(grid)
    incr(grid)
    num_flashes = flash(grid)
    reset(grid)
    num_flashes
end

def incr(grid)
    0.upto(grid.size - 1) do |r|
        0.upto(grid[r].size - 1) do |c|
            grid[r][c] += 1
        end
    end
end

def flash(grid, highlighted = Set(Point).new)
    0.upto(grid.size - 1) do |r|
        0.upto(grid[r].size - 1) do |c|
            pt = Point.new(r, c)
            if grid[r][c] > 9 && !highlighted.includes?(pt)
                highlighted << pt
                grid[r][c] += 1
                get_neighbors(grid, r, c).each do |pt|
                    grid[pt.row][pt.col] += 1
                    if grid[pt.row][pt.col] > 9 && !highlighted.includes?(pt)
                        flash(grid, highlighted)
                    end
                end
            end
        end
    end
    return highlighted.size
end

def get_neighbors(grid, r, c)
    min_row = [0, r - 1].max
    max_row = [grid.size - 1, r + 1].min
    min_col = [0, c - 1].max
    max_col = [grid[r].size - 1, c + 1].min
    neighbors = Set(Point).new
    (min_row..max_row).each do |r0|
        (min_col..max_col).each do |c0|
            if r0 != r || c0 != c
                neighbors << Point.new(r0, c0)
            end
        end
    end
    neighbors
end

def reset(grid)
    0.upto(grid.size - 1) do |r|
        0.upto(grid[r].size - 1) do |c|
            grid[r][c] = 0 if grid[r][c] > 9
        end
    end
end
