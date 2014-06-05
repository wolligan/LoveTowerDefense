--- ADD ME
Tilemap.tileDict = {}
Tilemap.tileNames = {}


---
--
Tilemap.tileNames[1]	= "air1"
Tilemap.tileDict[1] 	= {	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{255,255,255},								-- color
						1,											-- speed multiplicator
						false,										-- is obstacle
                        nil                                         -- update function
                      }
--
Tilemap.tileNames[2]	= "air2"
Tilemap.tileDict[2] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{240,240,240},								-- color
						1,											-- speed multiplicator
						false,										-- is obstacle
                        nil                                         -- update function
					}
--
Tilemap.tileNames[3]	= "sand"
Tilemap.tileDict[3] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{255,243,191},								-- color
						0.4,										-- speed multiplicator
						false,										-- is obstacle
                        nil                                         -- update function
					}
--
Tilemap.tileNames[4]	= "obstacle"
Tilemap.tileDict[4] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{0,0,0},									-- color
						1,											-- speed multiplicator
						true,										-- is obstacle
                        nil                                         -- update function
					}
--
Tilemap.tileNames[5]	= "spawner"
Tilemap.tileDict[5] 	= 	{	love.graphics.rectangle,					-- draw function
				        {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{120,37,98},									-- color
						1,											-- speed multiplicator
						false,										-- is obstacle
                        function(apparentScene, posX, posY, tick)         -- update function
                            if tick then
                                print("ich bin spawner also spawne ich")
                                Tilemap.getActiveScene().characters[#Tilemap.getActiveScene().characters+1] = Tilemap.Character(apparentScene,
                                                                                                                                posX*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                                                                                                                posY*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2)
                            end
                        end
					}
--
Tilemap.tileNames[6]	= "waypoint1"
Tilemap.tileDict[6] 	= {	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{255,0,0},								-- color
						1,											-- speed multiplicator
						false,										-- is obstacle
                        nil                                         -- update function
                      }
--
Tilemap.tileNames[7]	= "waypoint2"
Tilemap.tileDict[7] 	= {	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{0,255,255},								-- color
						1,											-- speed multiplicator
						false,										-- is obstacle
                        nil                                         -- update function
                      }
