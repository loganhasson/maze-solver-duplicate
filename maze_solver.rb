class MazeSolver

  attr_accessor :maze, :traveled_path, :visited_nodes, :node_queue, :goal_reached

  def initialize(maze)
    @maze = maze
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
    @goal_reached = false
  end

  def maze_array
    maze_array = []
    @maze.split("\n").each do |line|
      temp_array = []
      line.strip.each_char do |c|
        temp_array << c
      end
      maze_array << temp_array
    end

    maze_array
  end

  def get_starting_node
    maze_array.each_with_index do |row, row_index|
      row.each_with_index do |column, col_index|
        return [col_index, row_index] if column == "→"
      end
    end
  end

  def neighbors(node)
    col_index = node[0]
    row_index = node[1]
    indicies = [
                [col_index-1, row_index],
                [col_index+1, row_index],
                [col_index, row_index-1],
                [col_index, row_index+1]
               ]

    raw_one = maze_array[row_index-1][col_index] if maze_array[row_index-1]
    raw_two = maze_array[row_index+1][col_index] if maze_array[row_index+1]
    
    raw_neighbors_list = [
                          maze_array[row_index][col_index-1],
                          maze_array[row_index][col_index+1],
                          raw_one,
                          raw_two
                         ]
    possible_neighbors = raw_neighbors_list.each_with_index.map do |item, i|
      indicies[i] if !item.nil? && item != "#"
    end.compact
    possible_neighbors
  end

  def setup
    self.traveled_path << get_starting_node
    self.visited_nodes << get_starting_node
    self.node_queue << get_starting_node
  end

  def visited(node)
    self.visited_nodes.include?(node)
  end

  def goal(node)
    col_index = node[0]
    row_index = node[1]
    maze_array[row_index][col_index] == "@"
  end

  def add_to_arrays(node)
    self.visited_nodes << node
    self.node_queue << node
  end

  def solution_path
    solution = []
    starting_child = self.traveled_path.last[1]
    starting_parent = self.traveled_path.last[0]
    solution.unshift(starting_child)
    current_child = starting_parent
    self.traveled_path.reverse.each_with_index do |pair,i|
      if pair[1] == current_child
        solution.unshift(pair[1])
        current_child = pair[0]
      end
    end

    solution.unshift(current_child)
  end

  def add_to_path(parent, child)
    self.traveled_path << [parent, child]
  end

  def solve
    setup
    while !self.node_queue.empty?
      node = node_queue.shift
      neighbors(node).each do |neighbor|
        if !visited(neighbor)
          add_to_path(node, neighbor)
          add_to_arrays(neighbor)
          if goal(neighbor)
            self.goal_reached = true
            return solution_path
          end
        end
      end
    end

    if self.goal_reached == false
      raise "You will never get out! Muahahahahaha!"
    end
  end

  def print_maze(maze)
    printed_maze_str = ""
    maze.each do |row|
      row.each do |col|
        printed_maze_str << col
      end
      printed_maze_str << "\n"
    end

    puts printed_maze_str.strip
  end

  def display_solution_path
    copied_maze = maze_array
    solution_path[1..-2].each do |coord|
      copied_maze[coord[1]][coord[0]] = "."
    end
    print_maze(copied_maze)
  end

end