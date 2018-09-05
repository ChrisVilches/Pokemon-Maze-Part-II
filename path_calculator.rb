require 'set'

class PathCalculator

  WALL = 1
  LAND = 2
  HOLE = 3
  BREAKABLE_BOULDER = 4

  def initialize(maze)
    @maze = maze
  end

  def get_path(start:, finish:, boulder_break_count: Float::INFINITY)

    visited = Array.new(@maze.length){Array.new(@maze[0].length)}
    prev = Array.new(@maze.length){Array.new(@maze[0].length)}
    dist = Array.new(@maze.length){Array.new(@maze[0].length)}

    (0..visited.length-1).each do |i|
      (0..visited[0].length-1).each do |j|
        visited[i][j] = false
        prev[i][j] = nil
        dist[i][j] = Float::INFINITY
      end
    end

    visited[start.i][start.j] = true
    dist[start.i][start.j] = 0

    queue = Queue.new
    recursive_paths = Array.new

    queue << start

    while !queue.empty?

      curr = queue.pop

      next if is_hole? curr

      (0..3).each do |d|

        landing_pos = curr
        next_pos = curr.move(@@di[d], @@dj[d])

        if @maze[next_pos.i][next_pos.j] == BREAKABLE_BOULDER && boulder_break_count > 0
          new_maze = clone_maze
          new_maze[next_pos.i][next_pos.j] = LAND
          branch = PathCalculator.new new_maze
          path = branch.get_path(start: curr, finish: finish, boulder_break_count: boulder_break_count - 1)
          recursive_paths << path if !path.nil?
          next
        end

        while true
          break if !accessible_pos? next_pos
          landing_pos = next_pos
          break if landed? landing_pos
          break if is_hole? landing_pos
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

    all_paths = Array.new

    # For this recursion
    all_paths << get_path_from(start: start, finish: finish, prev: prev)

    # Blend with recursive_paths
    recursive_paths.each do |path|

      if path.first == start && path.last == finish
        # Add without completing the route, because it's already completed
        full_path = path
      else
        # It needs to compute the full path, since the recursion result is only part of it
        first_part = get_path_from(start: start, finish: path.first, prev: prev)
        first_part_without_last = first_part.first(first_part.size - 1)
        full_path = first_part_without_last + path
      end

      all_paths << full_path
    end

    return get_shortest_path all_paths

  end

  private

  @@di = [0, 0, 1, -1]
  @@dj = [1, -1, 0, 0]

  def get_shortest_path(paths_array)
    paths = paths_array.compact
    return nil if paths.length == 0
    shortest = paths.first
    paths.each do |path|
      shortest = path if path.length < shortest.length
    end
    return shortest
  end

  def clone_maze
    new_maze = []
    @maze.each do |row|
      new_maze << row.dup
    end
    new_maze
  end

  def get_path_from(start:, finish:, prev:)
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

  def accessible_pos?(pos)
    return false if pos.i < 0
    return false if pos.j < 0
    return false if pos.i >= @maze.length
    return false if pos.j >= @maze[0].length
    return false if @maze[pos.i][pos.j] == WALL
    return false if @maze[pos.i][pos.j] == BREAKABLE_BOULDER
    return true
  end

  def is_hole?(pos)
    @maze[pos.i][pos.j] == HOLE
  end

  def landed?(pos)
    @maze[pos.i][pos.j] == LAND
  end
end
