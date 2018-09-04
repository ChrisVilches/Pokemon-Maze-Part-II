class PathCalculator

  WALL = 1
  LAND = 2
  HOLE = 3

  def initialize(maze)
    @maze = maze
  end

  def get_path(start, finish)

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

    queue << start

    while !queue.empty?

      curr = queue.pop

      next if is_hole? @maze, curr

      (0..3).each do |d|

        landing_pos = curr
        next_pos = curr.move(@@di[d], @@dj[d])

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

    path = Array.new

    return nil if prev[finish.i][finish.j].nil?

    while finish != start
      path << finish
      finish = prev[finish.i][finish.j]
    end

    path << start
    path.reverse!
    return path
  end

  private

  @@di = [0, 0, 1, -1]
  @@dj = [1, -1, 0, 0]

  def accessible_pos?(maze, pos)
    return false if pos.i < 0
    return false if pos.j < 0
    return false if pos.i >= maze.length
    return false if pos.j >= maze[0].length
    return false if maze[pos.i][pos.j] == WALL
    return true
  end

  def is_hole?(maze, pos)
    maze[pos.i][pos.j] == HOLE
  end

  def landed?(maze, pos)
    maze[pos.i][pos.j] == LAND
  end
end
