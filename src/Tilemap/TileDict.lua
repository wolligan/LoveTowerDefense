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
						false										-- is obstacle
                      }
--
Tilemap.tileNames[2]	= "air2"
Tilemap.tileDict[2] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{240,240,240},								-- color
						1,											-- speed multiplicator
						false										-- is obstacle
					}
--
Tilemap.tileNames[3]	= "sand"
Tilemap.tileDict[3] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{255,243,191},								-- color
						0.4,										-- speed multiplicator
						false										-- is obstacle
					}
--
Tilemap.tileNames[4]	= "simple obstacle"
Tilemap.tileDict[4] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},			-- function parameters
						{0,0,0},									-- color
						1,											-- speed multiplicator
						true										-- is obstacle
					}
--
