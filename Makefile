SOURCES = src/*.lua src/*/*.lua
ASSETS_SPRITE = src/assets/sprites/*/*.png src/assets/sprites/*.png
ASSETS_SOUNDS = src/assets/sounds/*/*.ogg src/assets/ogg/*.ogg
ASSETS_FONTS = src/assets/fonts/*/*.ttf src/assets/fonts/*.ttf
GAMEFILES = $(SOURCES) $(ASSETS_SPRITE) $(ASSETS_FONTS) $(ASSETS_SOUNDS)

.PHONY: doc
doc:
	ldoc -c doc/Game/config.ld  -d doc src/
	ldoc -c doc/Lighting/config.ld  -d doc src/Lighting
	ldoc -c doc/Tilemap/config.ld  -d doc src/Tilemap
	ldoc -c doc/GUI/config.ld  -d doc src/GUI
    
love:
	sh makelove.sh
    
.PHONY: run
run:
	love src