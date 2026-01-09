def test_text_renderer_char_mapping(args, assert)
  renderer = TextRenderer.new(args)

  assert.equal! renderer.char_path('A'), 'sprites/text/alphabet/a.png'
  assert.equal! renderer.char_path('z'), 'sprites/text/alphabet/z.png'
  assert.equal! renderer.char_path('>'), 'sprites/text/symbols/>.png'
  assert.equal! renderer.char_path('<'), 'sprites/text/symbols/<.png'
end

def test_text_renderer_render_string_positions(args, assert)
  renderer = TextRenderer.new(args)

  # Default size 86
  # String "A B"
  # Width: 86 + 86 + 86 = 258

  sprites = renderer.render_string("A B", x: 100, y: 100)

  assert.equal! sprites.length, 2 # Space is not a sprite

  # A
  assert.equal! sprites[0].path, 'sprites/text/alphabet/a.png'
  assert.equal! sprites[0].x, 100
  assert.equal! sprites[0].y, 100

  # B (x should be 100 + 86 + 86 = 272)
  assert.equal! sprites[1].path, 'sprites/text/alphabet/b.png'
  assert.equal! sprites[1].x, 272
end

def test_text_renderer_scaling(args, assert)
  renderer = TextRenderer.new(args)

  # Size 43 (Half size)
  # Scale 0.5
  # Char width 43

  sprites = renderer.render_string("A", x: 100, y: 100, size: 43)

  assert.equal! sprites[0].w, 43
  assert.equal! sprites[0].h, 43
end

def test_text_renderer_alignment_center(args, assert)
  renderer = TextRenderer.new(args)

  # String "AA" (Width 172)
  # Center at 100
  # Start X should be 100 - (172/2) = 14

  sprites = renderer.render_string("AA", x: 100, y: 100, alignment_enum: 1)

  assert.equal! sprites[0].x, 14
end

def test_text_renderer_q_offset(args, assert)
  renderer = TextRenderer.new(args)

  # Normal Q (size 86, scale 1) -> offset -20
  sprites = renderer.render_string("Q", x: 100, y: 100)
  assert.equal! sprites[0].y, 80 # 100 - 20

  # Scaled Q (size 43, scale 0.5) -> offset -10
  sprites = renderer.render_string("Q", x: 100, y: 100, size: 43)
  assert.equal! sprites[0].y, 90 # 100 - 10
end
