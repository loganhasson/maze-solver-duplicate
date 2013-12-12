require_relative 'spec_helper'
require_relative 'maze_solver'

describe 'MazeSolver' do
  let(:small_maze){
    <<-11x11
      ###########
      #         #
      # ##### ###
      →   #     #
      ### # ### #
      #     #   #
      # ##### ###
      # #   #   @
      # ### #####
      #         #
      ###########
    11x11
  }

  let(:maze_solver) { MazeSolver.new(small_maze) }  
  
  context "A new maze solver" do
    it "instantiates with the maze as an attribute" do   
      expect(maze_solver.maze).to eq(small_maze)
    end

    it 'instantiates with empty arrays for traveled_path, visited_set, node_queue' do
      expect(maze_solver.traveled_path).to eq([])
      expect(maze_solver.visited_nodes).to eq([])
      expect(maze_solver.node_queue).to eq([])  
    end
  end

  context 'Parsing a maze' do
    let(:maze_array) {MazeSolver.new(small_maze).maze_array}

    it 'converts the maze to an array' do
      maze_array_fixture = [
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"],
        ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"],
        ["#", " ", "#", "#", "#", "#", "#", " ", "#", "#", "#"],
        ["→", " ", " ", " ", "#", " ", " ", " ", " ", " ", "#"],
        ["#", "#", "#", " ", "#", " ", "#", "#", "#", " ", "#"],
        ["#", " ", " ", " ", " ", " ", "#", " ", " ", " ", "#"],
        ["#", " ", "#", "#", "#", "#", "#", " ", "#", "#", "#"],
        ["#", " ", "#", " ", " ", " ", "#", " ", " ", " ", "@"],
        ["#", " ", "#", "#", "#", " ", "#", "#", "#", "#", "#"],
        ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"],
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"]
      ]

      expect(maze_array).to eq(maze_array_fixture)
    end
      
  end

  context 'Solving a maze' do
    describe '#solve' do
      it 'visits nodes and keeps track of them in the visited_nodes array' do
        maze_solver.solve

        # We're going to assume that at least 0,3 and 1,3 will be moved through
        # in an at all functioning solve routine.
        expect(maze_solver.visited_nodes).to include([0,3])
        expect(maze_solver.visited_nodes).to include([1,3])
      end
    end

    describe '#solution_path' do
      it 'returns the solution path array' do
        maze_solver.solve
        
        # We're using nodes that absolutely must be traveled to in order to confirm a solution path, 
        # as mazes might include more than one solution.
        solution_must_contain = [[0, 3], [7, 5], [7, 6], [7, 7], [8, 7], [9, 7], [10,7]]

        solution_must_contain.each do |node|
          expect(maze_solver.solution_path).to include(node)
        end
      end
    end

    # It is possible 
    describe '#display_solution_path' do
      it 'prints out the solved maze' do
        # There is another possible solution so don't worry
        # if this test fails.

        @solution_string = "
###########
#         #
# ##### ###
→...#.....#
###.#.###.#
#  ...#...#
# #####.###
# #   #...@
# ### #####
#         #
###########".strip

        maze_solver.solve
        expect($stdout).to receive(:puts).with(@solution_string)

        maze_solver.display_solution_path   
      end
    end

  end
end 