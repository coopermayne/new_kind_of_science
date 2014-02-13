class PatternsController < ApplicationController
  def index

    # 8 binary rules... that means 256 distinct combinations
    # if we add shades things change
    # 3 shades: 6,561
    # 4 shades: 65,536

    depth = params['depth'].to_i + (params['depth'].to_i%2-1).abs #make sure its odd...
    rows = depth
    cols = depth*2+1 #add equale numbers of cells on each side of middle....
    grid = Array.new(rows){ Array.new(cols) { 0 } }

    filename = "#{cols}_#{rows}.png"

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
        return 1   #this one is cool 0 or 1
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

    #set the seed... 
    initialIndex = depth
    grid[0][(initialIndex)] = 1

    depth.times do |t|
      puts t
      next if t == 0  #dont need to investigate the first t
      (initialIndex-t..initialIndex+t).each do |col|  #only investigate within possible range
        grid[t][col] = determine_color(grid, t, col)
      end
    end

    #slice off edges
    grid.map! do |row|
      row[(depth+1)/2..-(depth+3)/2]
    end  

    cols = depth
    rows = depth

    img = Magick::Image.new(cols,rows)

    rows.times { |y|
      pixels = img.get_pixels(0, y, cols, 1)
      pixels.each_with_index do |p,x|
        if grid[y][x]==1
          p.red = 0
          p.green = 0
          p.blue = 0
        else
          n = 65535/3
          p.red = n
          p.green = n
          p.blue = n
        end
      end
      img.store_pixels(0, y, cols, 1, pixels)
    }

    img_small = img.scale(2)
    img_large = img.scale(3)
    img_small.write("public/images/small_#{filename}")
    img_large.write("public/images/large_#{filename}")

    render :json => {small: "images/small_#{filename}", large: "images/large_#{filename}" }

  end
end
