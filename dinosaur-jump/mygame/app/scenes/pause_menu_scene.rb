class PauseMenuScene
  attr_accessor :args, :selected_index

  def initialize(args, game_scene)
    @args = args
    @game_scene = game_scene
    @selected_index = 0
    @options = ["Resume", "Restart", "Return to Menu"]
    @text_renderer = TextRenderer.new(args)
  end

  def tick
    render
    handle_input
  end

  def render
    # Render the frozen game scene behind the menu
    @game_scene.render_actions

    # Render semi-transparent background overlay
    @args.outputs.sprites << {
      x: 0, y: 0, w: 1280, h: 720,
      path: :pixel,
      r: 0, g: 0, b: 0, a: 128
    }

    # Render Pause Title
    @args.outputs.sprites << @text_renderer.render_string(
      "PAUSED",
      x: 640,
      y: 550,
      alignment_enum: 1,
      size: 48
    )

    # Render Options
    @options.each_with_index do |option, index|
      text = option
      if index == @selected_index
        text = "> #{option} <"
      end

      @args.outputs.sprites << @text_renderer.render_string(
        text,
        x: 640,
        y: 400 - (index * 50),
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
    when 0 # Resume
      @args.state.scene = @game_scene
    when 1 # Restart
      @args.state.scene = GameScene.new(@args)
    when 2 # Return to Menu
      @args.state.scene = MenuScene.new(@args)
    end
  end
end
