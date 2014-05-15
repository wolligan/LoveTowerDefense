SOURCES = src/*.lua src/*/*.lua
ASSETS_SPRITE = src/assets/sprites/*/*.png src/assets/sprites/*.png
ASSETS_SOUNDS = src/assets/sounds/*/*.ogg src/assets/ogg/*.ogg
ASSETS_FONTS = src/assets/fonts/*/*.ttf src/assets/fonts/*.ttf
GAMEFILES = $(SOURCES) $(ASSETS_SPRITE) $(ASSETS_FONTS) $(ASSETS_SOUNDS)

.PHONY: doc
doc:
	ldoc -c doc/config.ld  -d doc src/
    
love:
	sh makelove.sh
    
.PHONY: run
run:
	love src