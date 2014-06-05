--- TileDict saves visual representation of tiles and mechanics of tiles.
-- Members of a tile:
-- name - string with the name of the tile.
-- draw - function that gets called for rendering the tile.
-- drawParams - parameters of the draw function.
-- color - color of the tile as {r,g,b}.
-- speed - multiplicator of the speed, 1 changes nothing.
-- isObstacle - a character cannot walk of an obstacle.
-- update - function that gets called before rendering

Tilemap.tileDict = {}


Tilemap.tileDict[1] 	= {   name = "air1",
                              draw = love.graphics.rectangle,
						      drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
						      color = {255,255,255},
						      speed = 1,
						      isObstacle = false,
                              update = nil
                            }

Tilemap.tileDict[2] 	= {	  name = "air2",
                              draw = love.graphics.rectangle,
						      drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
						      color = {240,240,240},
						      speed = 1,
						      isObstacle = false,
                              update = nil
					       }

Tilemap.tileDict[3] 	= {	  name = "sand",
                              draw = love.graphics.rectangle,
						      drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
						      color = {255,243,191},
						      speed = 0.4,
						      isObstacle = false,
                              update = nil
					       }

Tilemap.tileDict[4] 	= {   name = "obstacle",
                              draw = love.graphics.rectangle,
						      drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
						      color = {0,0,0},
						      speed = 1,
						      isObstacle = true,
                              update = nil
					}

Tilemap.tileDict[5] 	= {   name = "spawner",
                              draw = love.graphics.rectangle,					-- draw function
				              drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						      color = {120,37,98},									-- color
						      speed = 1,											-- speed multiplicator
						      isObstacle = false,										-- is obstacle
                              update = function(apparentScene, posX, posY, tick)         -- update function
                                if tick then
                                    print("ich bin spawner also spawne ich")
                                    apparentScene.characters[#apparentScene.characters+1] = Tilemap.Character(apparentScene,
                                                                                                                                posX*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                                                                                                                posY*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2)
                                    end
                                end
					}

Tilemap.tileDict[6] 	= {   name = "waypoint1",
                              draw = love.graphics.rectangle,					-- draw function
                              drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
                              color = {255,0,0},								-- color
                              speed = 1,											-- speed multiplicator
                              isObstacle = false,										-- is obstacle
                              update = nil                                         -- update function
                      }

Tilemap.tileDict[7] 	= {	  name = "waypoint2",
                              draw = love.graphics.rectangle,					-- draw function
						      drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						      color = {0,255,255},								-- color
						      speed = 1,											-- speed multiplicator
						      isObstacle = false,										-- is obstacle
                              update = nil                                         -- update function
                      }
