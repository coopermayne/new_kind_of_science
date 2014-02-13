require 'rubygems'
require 'pry'
require 'rmagick'


grid = []
rows = 1001
cols = 1001
default_color = 0

def determine_color(grid, row_index, col_index) 
  previous_row = grid[row_index-1]
  parents = previous_row[col_index-1,3]
  case parents
  when [1,1,1]
    return 0 #toggle boring/fun
  when [1,1,0]
    return 1
  when [1,0,1]
    return 1
  when [1,0,0] 
    return 0   #this one is cool 0 or 1
  when [0,1,1]
    return 1  #make a sideways fractal
  when [0,1,0]
    return 1
  when [0,0,1]
    return 1
  when [0,0,0]
    return 0    #sideways swoop
  else
    return 0
  end
end

grid = Array.new(rows){ Array.new(cols) { 0 } }

grid[0][(rows-1)/2] = 1
#added complexity
#grid[0][(rows-1)/2+20] = 1
#grid[0][(rows-1)/2+38] = 1
#grid[0][(rows-1)/2+61] = 1
#grid[0][(rows-1)] = 1

grid.each_with_index do |row, row_index|  
  next if row_index==0   #(skip the first row....)

  #determine colors for each row. 
  row.each_with_index do |col, col_index| 
    next if col_index==0 || col_index==cols-1  #skip first and last col
    grid[row_index][col_index] = determine_color(grid, row_index, col_index)
  end
end

img = Magick::Image.new(cols,rows)

rows.times { |y|
    pixels = img.get_pixels(0, y, cols, 1)
    pixels.each_with_index do |p,x|
      if grid[y][x]==1
        p.red = 0
        p.green = 0
        p.blue = 0
      end
    end
    img.store_pixels(0, y, cols, 1, pixels)
}

img.write('testy.png')

puts "DONE"


