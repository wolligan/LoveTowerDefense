SOURCES = src/*.lua src/*/*.lua
ASSETS_SPRITE = src/assets/sprites/*/*.png src/assets/sprites/*.png
ASSETS_SOUNDS = src/assets/sounds/*/*.ogg src/assets/ogg/*.ogg
ASSETS_FONTS = src/assets/fonts/*/*.ttf src/assets/fonts/*.ttf
GAMEFILES = $(SOURCES) $(ASSETS_SPRITE) $(ASSETS_FONTS) $(ASSETS_SOUNDS)

.PHONY: doc
doc:
	ldoc -c doc/Game/config.ld  -d doc src/Game.lua
	ldoc -c doc/Lighting/config.ld  -d doc src/Lighting
	ldoc -c doc/Tilemap/config.ld  -d doc src/Tilemap
	ldoc -c doc/GUI/config.ld  -d doc src/GUI
	ldoc -c doc/Networking/config.ld  -d doc src/Networking
	ldoc -c doc/LevelEditor/config.ld  -d doc src/LevelEditor
	ldoc -c doc/Utilities/config.ld  -d doc src/Utilities
	ldoc -c doc/GameMechanics/config.ld  -d doc src/Ingame
    
love:
	sh makelove.sh
    
.PHONY: run
run:
	love src