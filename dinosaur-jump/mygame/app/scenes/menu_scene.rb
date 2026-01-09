class MenuScene
  attr_accessor :args, :selected_index

  def initialize(args)
    @args = args
    @selected_index = 0 # 0 = Start Game, 1 = Exit
    @options = ["Start Game", "Exit"]
    @text_renderer = TextRenderer.new(args)
  end

  def tick
    render
    handle_input
  end

  def render
    # Render Title
    @args.outputs.sprites << {
      x: 440, y: 400, w: 400, h: 268,
      path: 'sprites/text/title.png'
    }

    # Render Options
    @options.each_with_index do |option, index|
      text = option
      if index == @selected_index
        text = "> #{option} <"
      end

      @args.outputs.sprites << @text_renderer.render_string(
        text,
        x: 640,
        y: 200 - (index * 50),
        alignment_enum: 1,
        size: 24
      )
    end
  end

  def handle_input
    if @args.inputs.keyboard.key_down.up
      @selected_index = (@selected_index - 1) % @options.length
    elsif @args.inputs.keyboard.key_down.down
      @selected_index = (@selected_index + 1) % @options.length
    elsif @args.inputs.keyboard.key_down.enter
      select_option
    end
  end

  def select_option
    case @selected_index
    when 0 # Start Game
      @args.state.scene = GameScene.new(@args)
    when 1 # Exit
      @args.gtk.request_quit
    end
  end
end
