SOURCES = src/*.lua src/*/*.lua
ASSETS_SPRITE = src/assets/sprites/*/*.png src/assets/sprites/*.png
ASSETS_SOUNDS = src/assets/sounds/*/*.ogg src/assets/ogg/*.ogg
ASSETS_FONTS = src/assets/fonts/*/*.ttf src/assets/fonts/*.ttf
GAMEFILES = $(SOURCES) $(ASSETS_SPRITE) $(ASSETS_FONTS) $(ASSETS_SOUNDS)

.PHONY: doc
doc:
	ldoc -c doc/config.ld .
	ldoc -c doc/Game/config.ld .
	ldoc -c doc/Lighting/config.ld .
	ldoc -c doc/Tilemap/config.ld .
	ldoc -c doc/GUI/config.ld .
	ldoc -c doc/Networking/config.ld .
	ldoc -c doc/LevelEditor/config.ld .
	ldoc -c doc/Utilities/config.ld .
	ldoc -c doc/GameMechanics/config.ld .
    
love:
	sh makelove.sh
    
.PHONY: run
run:
	love src