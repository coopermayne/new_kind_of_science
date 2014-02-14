class PatternsController < ApplicationController

  def determine_color(grid, rules, row_index, col_index) 
    previous_row = grid[row_index-1]
    parents = previous_row[col_index-1,3]
    case parents
    when [1,1,1]
      return rules.include?('R1') ? 1 : 0 #TOGGLE BORING/FUN
    when [1,1,0]
      return rules.include?('R2') ? 1 : 0 #TOGGLE BORING/FUN
    when [1,0,1]
      return rules.include?('R3') ? 1 : 0
    when [1,0,0] 
      return rules.include?('R4') ? 1 : 0 #FUN BOTH WAYS
    when [0,1,1]
      return rules.include?('R5') ? 1 : 0 #sideways fractal
    when [0,1,0]
      return rules.include?('R6') ? 1 : 0
    when [0,0,1]
      return rules.include?('R7') ? 1 : 0
    when [0,0,0] #this rule!... messes up my optimization
      return rules.include?('R8') ? 1 : 0 
    else
      return 0
    end
  end

  def img
    all_rules = %w(R1 R2 R3 R4 R5 R6 R7 R8)
    rules = params.keys & all_rules

    depth = params['depth'].to_i + (params['depth'].to_i%2-1).abs #MAKE SURE ITS ODD...
    rows = depth
    cols = depth*2+1 #ADD EQUALE NUMBERS OF CELLS ON EACH SIDE OF MIDDLE....
    grid = Array.new(rows){ Array.new(cols) { 0 } }

    filename = "#{cols}_#{rows}.png"

    #SET THE SEED... 
    initialIndex = depth
    grid[0][(initialIndex)] = 1

    depth.times do |t|
      puts t
      next if t == 0  #dont need to investigate the first t
      (initialIndex-t..initialIndex+t).each do |col|  #only investigate within possible range
        grid[t][col] = determine_color(grid, rules, t, col)
      end
    end

    #SLICE OFF EDGES
    grid.map! do |row|
      row[(depth+1)/2..-(depth+3)/2]
    end  

    #MAKE THE IMAGES

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

    if cols < 700
      img_small = img.scale(4)
    elsif cols < 1000
      img_small = img.scale(3)
    elsif cols < 1300
      img_small = img.scale(2)
    else
      img_small = img
    end
    img_large = img_small.scale(2)
    img_small.write("public/images/small_#{filename}")
    img_large.write("public/images/large_#{filename}")

    render :json => {small: "images/small_#{filename}", large: "images/large_#{filename}" }

  end

  def svg
    img = Rasem::SVGImage.new(100,100) do
      circle 20, 20, 5
      circle 50, 50, 5
      line 20, 20, 50, 50
    end

    render :json => {source: img.output}
  end
end
