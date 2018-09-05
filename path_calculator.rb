require 'set'

class PathCalculator

  WALL = 1
  LAND = 2
  HOLE = 3
  BREAKABLE_BOULDER = 4

  def initialize(maze)
    @maze = []
    #@maze = maze
    (0..maze.length-1).each do |i|
      @maze << []
      (0..maze[0].length-1).each do |j|
        @maze[i] << maze[i][j]

      end
    end
  end

  def get_path(start:, finish:, visited: nil, dist: nil, prev: nil, boulder_break_remaining: Float::INFINITY, break_boulder: nil)

    init_visited = visited.nil?
    init_prev = prev.nil?
    init_dist = dist.nil?

    _visited = Array.new(@maze.length){Array.new(@maze[0].length)}
    _prev = Array.new(@maze.length){Array.new(@maze[0].length)}
    _dist = Array.new(@maze.length){Array.new(@maze[0].length)}

    # Deep cloning
    (0.._visited.length-1).each do |i|
      (0.._visited[0].length-1).each do |j|
        #_visited[i][j] = false if init_visited
        #_prev[i][j] = nil if init_prev
        #_dist[i][j] = Float::INFINITY if init_dist

        #_visited[i][j] = visited[i][j] if !init_visited
        #_prev[i][j] = prev[i][j] if !init_prev
        #_dist[i][j] = dist[i][j] if !init_dist

        _visited[i][j] = false
        _prev[i][j] = nil
        _dist[i][j] = Float::INFINITY
      end
    end

    @maze[break_boulder.i][break_boulder.j] = LAND if !break_boulder.nil?

    visited = _visited
    prev = _prev
    dist = _dist

    visited[start.i][start.j] = true
    dist[start.i][start.j] = 0

    queue = Queue.new

    queue << start

    recursive_paths = Array.new

    while !queue.empty?

      curr = queue.pop

      next if is_hole? @maze, curr

      (0..3).each do |d|

        landing_pos = curr
        next_pos = curr.move(@@di[d], @@dj[d])

        if @maze[next_pos.i][next_pos.j] == BREAKABLE_BOULDER && boulder_break_remaining > 0

          new_maze = @maze.dup
          branch = PathCalculator.new new_maze

          path = branch.get_path(
            start: curr.dup,
            finish: finish.dup,
            visited: visited.dup,
            dist: dist.dup,
            prev: prev.dup,
            boulder_break_remaining: boulder_break_remaining - 1,
            break_boulder: next_pos.dup
          )

          recursive_paths << path
          next
        end

        while true
          break if !accessible_pos? @maze, next_pos
          landing_pos = next_pos
          break if landed? @maze, landing_pos
          break if is_hole? @maze, landing_pos
          next_pos = next_pos.move(@@di[d], @@dj[d])
        end

        alt = dist[curr.i][curr.j] + 1
        if alt < dist[landing_pos.i][landing_pos.j]
          dist[landing_pos.i][landing_pos.j] = alt
          prev[landing_pos.i][landing_pos.j] = curr
        end

        if !visited[landing_pos.i][landing_pos.j]
          queue << landing_pos
          visited[landing_pos.i][landing_pos.j] = true
        end
      end
    end

    # For this recursion
    this_path = get_path_from(start: start.dup, finish: finish.dup, prev: prev)

    recursive_paths_completed = Array.new

    # Blend with recursive_paths
    recursive_paths.each do |path|

      next if path.nil?

      if path.first == start && path.last == finish
        # Add without completing the route, because it's already completed
        recursive_paths_completed << path
        next
      end

      first_part = get_path_from(start: start.dup, finish: path.first.dup, prev: prev)

      next if first_part.nil?

      first_part_without_last = first_part.first(first_part.size - 1)
      recursive_paths_completed << (first_part_without_last + path)
    end

    all_paths = [this_path] + recursive_paths_completed
    all_paths = all_paths.compact
    all_paths = all_paths.sort do |a, b|
      case
      when a.length < b.length
        -1
      when a.length > b.length
        1
      else
        a.length <=> b.length
      end
    end

    return nil if all_paths.length == 0

    return all_paths[0]

  end

  private

  @@di = [0, 0, 1, -1]
  @@dj = [1, -1, 0, 0]

  def get_path_from(start:, finish:, prev:)
    finish_ = finish.dup
    return nil if prev[finish.i][finish.j].nil?
    path = Array.new
    while finish != start
      path << finish
      finish = prev[finish.i][finish.j]    
    end
    path << start
    path.reverse!
    return path
  end

  def accessible_pos?(maze, pos)
    return false if pos.i < 0
    return false if pos.j < 0
    return false if pos.i >= maze.length
    return false if pos.j >= maze[0].length
    return false if maze[pos.i][pos.j] == WALL
    return false if maze[pos.i][pos.j] == BREAKABLE_BOULDER
    return true
  end

  def is_hole?(maze, pos)
    maze[pos.i][pos.j] == HOLE
  end

  def landed?(maze, pos)
    maze[pos.i][pos.j] == LAND
  end
end
