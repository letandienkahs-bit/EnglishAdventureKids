extends Control

# English Adventure Kids v0.5
# Offline-first, designed for ages 3–5.
# Core loop: hear -> see -> tap -> celebrate -> repeat.

const BG := Color("#FFF7E8")
const CARD := Color("#FFFFFF")
const INK := Color("#4A405A")
const SOFT := Color("#F4EAFB")
const GREEN := Color("#78CFA5")
const PINK := Color("#F4A6B8")
const BLUE := Color("#8EC5E8")
const YELLOW := Color("#FFD95A")

const ART := {
    "Dog": "res://assets/dog.svg",
    "Cat": "res://assets/cat.svg",
    "Rabbit": "res://assets/rabbit.svg",
    "Bird": "res://assets/bird.svg",
    "Apple": "res://assets/apple.svg",
    "Banana": "res://assets/banana.svg",
    "Orange": "res://assets/orange.svg",
    "Watermelon": "res://assets/watermelon.svg"
}

const DATA := {
    "Animals": ["Dog", "Cat", "Rabbit", "Bird"],
    "Fruits": ["Apple", "Banana", "Orange", "Watermelon"],
    "Colors": ["Red", "Blue", "Yellow", "Green"]
}

var stars := 0
var progress := {}
var mode := ""
var current_items: Array = []
var question_index := 0
var answer := ""
var locked := false
var rng := RandomNumberGenerator.new()

var title: Label
var subtitle: Label
var content: VBoxContainer
var status: Label
var stars_label: Label

func _ready() -> void:
    rng.randomize()
    load_progress()
    build_home()
    print("=== ENGLISH ADVENTURE KIDS v0.5 READY ===")

func clear_root() -> void:
    for child in get_children():
        child.queue_free()

func base_screen(title_text: String, subtitle_text: String) -> VBoxContainer:
    clear_root()
    var bg := ColorRect.new()
    bg.color = BG
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 34)
    margin.add_theme_constant_override("margin_right", 34)
    margin.add_theme_constant_override("margin_top", 24)
    margin.add_theme_constant_override("margin_bottom", 24)
    add_child(margin)

    var box := VBoxContainer.new()
    box.add_theme_constant_override("separation", 14)
    margin.add_child(box)

    var head := HBoxContainer.new()
    head.custom_minimum_size.y = 62
    box.add_child(head)

    var back := Button.new()
    back.text = "←"
    back.custom_minimum_size = Vector2(72, 62)
    back.add_theme_font_size_override("font_size", 34)
    back.pressed.connect(build_home)
    head.add_child(back)

    title = Label.new()
    title.text = title_text
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_color_override("font_color", INK)
    title.add_theme_font_size_override("font_size", 34)
    head.add_child(title)

    stars_label = Label.new()
    stars_label.text = "⭐ " + str(stars)
    stars_label.custom_minimum_size.x = 110
    stars_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stars_label.add_theme_color_override("font_color", INK)
    stars_label.add_theme_font_size_override("font_size", 25)
    head.add_child(stars_label)

    subtitle = Label.new()
    subtitle.text = subtitle_text
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle.add_theme_color_override("font_color", INK)
    subtitle.add_theme_font_size_override("font_size", 21)
    box.add_child(subtitle)

    content = VBoxContainer.new()
    content.size_flags_vertical = Control.SIZE_EXPAND_FILL
    content.add_theme_constant_override("separation", 12)
    box.add_child(content)

    status = Label.new()
    status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status.add_theme_color_override("font_color", INK)
    status.add_theme_font_size_override("font_size", 23)
    box.add_child(status)

    return box

func make_button(text: String, min_h := 84, font_size := 28) -> Button:
    var b := Button.new()
    b.text = text
    b.custom_minimum_size = Vector2(0, min_h)
    b.add_theme_font_size_override("font_size", font_size)
    b.add_theme_color_override("font_color", INK)
    return b

func build_home() -> void:
    var box := base_screen("🌈 English Adventure Kids", "Let's play and learn English!")
    var welcome := HBoxContainer.new()
    welcome.alignment = BoxContainer.ALIGNMENT_CENTER
    content.add_child(welcome)

    var bear := TextureRect.new()
    bear.texture = load("res://assets/bear.svg")
    bear.custom_minimum_size = Vector2(120, 120)
    bear.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    bear.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    welcome.add_child(bear)

    var msg := Label.new()
    msg.text = "Tap a game.\nListen, look, and play!"
    msg.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    msg.add_theme_color_override("font_color", INK)
    msg.add_theme_font_size_override("font_size", 27)
    welcome.add_child(msg)

    var games := [
        ["👂 Listen & Find", "listen", BLUE],
        ["🧩 Match Picture", "match", PINK],
        ["🔢 Count", "count", GREEN],
        ["🎨 Colors", "color", YELLOW]
    ]
    for item in games:
        var b := make_button(item[0], 82, 27)
        b.add_theme_color_override("font_color", INK)
        b.pressed.connect(func(): start_mode(item[1]))
        content.add_child(b)

    var credit := Label.new()
    credit.text = "Ba Diện gửi tới con Hồng Xiêm\nChúc con luôn vui vẻ, mạnh khỏe, ngoan ngoãn và học giỏi!"
    credit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    credit.add_theme_color_override("font_color", INK)
    credit.add_theme_font_size_override("font_size", 20)
    content.add_child(credit)

func start_mode(new_mode: String) -> void:
    mode = new_mode
    question_index = 0
    locked = false
    if mode == "listen":
        current_items = DATA["Animals"].duplicate()
    elif mode == "match":
        current_items = DATA["Fruits"].duplicate()
    elif mode == "count":
        current_items = [2, 3, 4, 5, 6, 7]
    else:
        current_items = DATA["Colors"].duplicate()
    next_question()

func next_question() -> void:
    locked = false
    if question_index >= 5:
        finish_round()
        return

    if mode == "listen":
        show_listen_question()
    elif mode == "match":
        show_match_question()
    elif mode == "count":
        show_count_question()
    else:
        show_color_question()

func header_for_game(name: String, instruction: String) -> void:
    base_screen(name, instruction)
    status.text = "Question %d / 5" % [question_index + 1]

func show_listen_question() -> void:
    header_for_game("👂 Listen & Find", "Tap 🔊 to hear the word, then find the picture.")
    answer = current_items[rng.randi_range(0, current_items.size() - 1)]
    var speak_btn := make_button("🔊 Hear " + answer, 78, 26)
    speak_btn.pressed.connect(func(): speak(answer))
    content.add_child(speak_btn)

    var grid := GridContainer.new()
    grid.columns = 2
    grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
    content.add_child(grid)
    var opts := current_items.duplicate()
    opts.shuffle()
    for word in opts:
        var card := make_card(word)
        card.pressed.connect(func(): choose_answer(word))
        grid.add_child(card)

func show_match_question() -> void:
    header_for_game("🧩 Match Picture", "See the word. Hear it. Find the matching picture.")
    answer = current_items[rng.randi_range(0, current_items.size() - 1)]
    var word_btn := make_button("🔊  " + answer, 95, 34)
    word_btn.pressed.connect(func(): speak(answer))
    content.add_child(word_btn)

    var grid := GridContainer.new()
    grid.columns = 2
    grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
    content.add_child(grid)
    var opts := current_items.duplicate()
    opts.shuffle()
    for word in opts:
        var card := make_picture_card(word)
        card.pressed.connect(func(): choose_answer(word))
        grid.add_child(card)

func show_count_question() -> void:
    header_for_game("🔢 Count", "How many?")
    answer = str(current_items[rng.randi_range(0, current_items.size() - 1)])
    var count := int(answer)
    var row := HBoxContainer.new()
    row.alignment = BoxContainer.ALIGNMENT_CENTER
    row.size_flags_vertical = Control.SIZE_EXPAND_FILL
    content.add_child(row)
    for i in range(count):
        var icon := Label.new()
        icon.text = "●"
        icon.custom_minimum_size = Vector2(54, 54)
        icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        icon.add_theme_font_size_override("font_size", 38)
        icon.add_theme_color_override("font_color", BLUE)
        row.add_child(icon)

    var hint := make_button("🔊 How many?", 74, 25)
    hint.pressed.connect(func(): speak(answer))
    content.add_child(hint)

    var nums := [2, 3, 4, 5]
    nums.shuffle()
    if not nums.has(count):
        nums[0] = count
    for n in nums:
        var b := make_button(str(n), 70, 30)
        b.pressed.connect(func(): choose_answer(str(n)))
        content.add_child(b)

func show_color_question() -> void:
    header_for_game("🎨 Colors", "Tap 🔊, listen, then choose the color.")
    answer = current_items[rng.randi_range(0, current_items.size() - 1)]
    var hear := make_button("🔊 Hear " + answer, 78, 26)
    hear.pressed.connect(func(): speak(answer))
    content.add_child(hear)

    var grid := GridContainer.new()
    grid.columns = 2
    grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
    content.add_child(grid)
    var opts := current_items.duplicate()
    opts.shuffle()
    for color_name in opts:
        var b := make_button("   " + color_name + "   ", 120, 30)
        b.add_theme_color_override("font_color", color_for(color_name))
        b.pressed.connect(func(): choose_answer(color_name))
        grid.add_child(b)

func make_card(word: String) -> Button:
    var b := make_button(word, 160, 30)
    b.text = "🖼️\n" + word
    return b

func make_picture_card(word: String) -> Button:
    var b := Button.new()
    b.custom_minimum_size = Vector2(0, 190)
    var icon := TextureRect.new()
    icon.texture = load(ART.get(word, ""))
    icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
    icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    b.add_child(icon)
    var label := Label.new()
    label.text = word
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
    label.add_theme_font_size_override("font_size", 24)
    label.add_theme_color_override("font_color", INK)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
    label.offset_top = -45
    b.add_child(label)
    return b

func choose_answer(value: String) -> void:
    if locked:
        return
    locked = true
    if value == answer:
        stars += 1
        progress[answer] = int(progress.get(answer, 0)) + 1
        status.text = "🌟 Great!  Well done!"
        speak("Great job!")
        save_progress()
        await get_tree().create_timer(0.8).timeout
        question_index += 1
        next_question()
    else:
        locked = false
        status.text = "💛 Nice try! Listen and try again."
        speak("Try again!")

func finish_round() -> void:
    var box := base_screen("🌟 Great job!", "You finished this little English adventure!")
    var big := Label.new()
    big.text = "⭐ ⭐ ⭐\nYou earned stars!"
    big.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    big.add_theme_font_size_override("font_size", 42)
    big.add_theme_color_override("font_color", INK)
    big.size_flags_vertical = Control.SIZE_EXPAND_FILL
    content.add_child(big)

    var again := make_button("🔁 Play again", 88, 28)
    again.pressed.connect(func(): start_mode(mode))
    content.add_child(again)

    var home := make_button("🏠 Home", 78, 27)
    home.pressed.connect(build_home)
    content.add_child(home)

func color_for(name: String) -> Color:
    match name:
        "Red": return Color("#E85B5B")
        "Blue": return Color("#4B91D1")
        "Yellow": return Color("#D49B20")
        "Green": return Color("#48A66D")
    return INK

func speak(text: String) -> void:
    if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        DisplayServer.tts_speak(text, "", 1.0, 1.0, 1.0, 0, true)
    else:
        print("TTS unavailable: ", text)

func save_progress() -> void:
    var data := {"stars": stars, "progress": progress}
    var file := FileAccess.open("user://progress.json", FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(data))

func load_progress() -> void:
    if not FileAccess.file_exists("user://progress.json"):
        return
    var file := FileAccess.open("user://progress.json", FileAccess.READ)
    if file:
        var parsed = JSON.parse_string(file.get_as_text())
        if typeof(parsed) == TYPE_DICTIONARY:
            stars = int(parsed.get("stars", 0))
            progress = parsed.get("progress", {})
