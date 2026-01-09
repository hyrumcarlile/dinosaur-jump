class TextRenderer
  CHAR_WIDTH = 86
  CHAR_HEIGHT = 86

  # Symbols are 370x538 originally.
  # We want them to match the height of 86.
  # 86 / 538 ~= 0.16
  # Width should be 370 * 0.16 ~= 59
  # Let's try 60x86 for symbols
  SYMBOL_WIDTH = 60
  SYMBOL_HEIGHT = 86

  def initialize(args)
    @args = args
  end

  def render_string(string, x:, y:, alignment_enum: 0, size: 86)
    # Alignment: 0 = Left, 1 = Center, 2 = Right

    # Calculate scale based on desired height vs original height (86)
    scale = size / CHAR_HEIGHT.to_f
    scaled_char_width = CHAR_WIDTH * scale
    scaled_symbol_width = SYMBOL_WIDTH * scale # 60 * scale

    total_width = calculate_width(string, size)

    start_x = x
    if alignment_enum == 1
      start_x = x - (total_width / 2)
    elsif alignment_enum == 2
      start_x = x - total_width
    end

    sprites = []
    current_x = start_x

    string.each_char do |char|
      if char == ' '
        current_x += scaled_char_width
        next
      end

      # Determine if it's a symbol (> or <) or a letter
      is_symbol = ['>', '<'].include?(char)
      path = char_path(char)

      width = is_symbol ? scaled_symbol_width : scaled_char_width
      height = size # Since we scaled by height ratio, height is just size

      # Special alignment for Q
      offset_y = 0
      if char.downcase == 'q'
        offset_y = -20 * scale # Scale the offset too
      end

      sprites << {
        x: current_x,
        y: y + offset_y,
        w: width,
        h: height,
        path: path
      }

      current_x += width
    end

    sprites
  end

  def calculate_width(string, size)
    scale = size / CHAR_HEIGHT.to_f
    scaled_char_width = CHAR_WIDTH * scale
    scaled_symbol_width = SYMBOL_WIDTH * scale

    width = 0
    string.each_char do |char|
      if ['>', '<'].include?(char)
        width += scaled_symbol_width
      elsif char == ' '
        width += scaled_char_width
      else
        width += scaled_char_width
      end
    end
    width
  end

  def char_path(char)
    if char == '>'
      return 'sprites/text/symbols/>.png'
    elsif char == '<'
      return 'sprites/text/symbols/<.png'
    end

    # Assume alphabet
    # User folders had lowercase filenames: 'a.png', 'b.png'...
    # User request example "start game" implies case insensitivity or mapping.
    # The file list showed 'a.png', 'b.png'.
    # Let's simply downcase using Ruby.

    c = char.downcase
    # Verify it's a valid letter? If not found, maybe show nothing or error?
    # Assuming valid input for now.
    "sprites/text/alphabet/#{c}.png"
  end
end
