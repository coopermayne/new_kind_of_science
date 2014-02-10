class PatternsController < ApplicationController
  def index

    grid = []
    rows = 301
    cols = 301
    default_color = 0

    def determine_color(grid, row_index, col_index) 
      previous_row = grid[row_index-1]
      parents = previous_row[col_index-1,3]
      case parents
      when [1,1,1]
        return 0
      when [1,1,0]
        return 1
      when [1,0,1]
        return 1
      when [1,0,0]
        return 0
      when [0,1,1]
        return 1
      when [0,1,0]
        return 1
      when [0,0,1]
        return 1
      when [0,0,0]
        return 0
      else
        return 0
      end
    end

    grid = Array.new(rows){ Array.new(cols) { 0 } }

    grid[0][(rows-1)/2] = 1

    grid.each_with_index do |row, row_index|  
      next if row_index==0   #(skip the first row....)

      #determine colors for each row. 
      row.each_with_index do |col, col_index| 
        next if col_index==0 || col_index==cols-1  #skip first and last col
        grid[row_index][col_index] = determine_color(grid, row_index, col_index)
      end
    end

    render :json => grid.to_json
  end
end
