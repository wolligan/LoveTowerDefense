#!/bin/bash

cd src
zip -r ../bin/LTD.love . -i *.lua */*.lua */*/*.lua *.png */*.png */*/*.png *.ogg */*.ogg */*/*.ogg *.ttf */*.ttf */*/*.ttf
cd ..
