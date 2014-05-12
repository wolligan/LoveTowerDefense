--- ADD ME
Ingame.tileDict = {}
Ingame.tileNames = {}


---
--
Ingame.tileNames[1]	= "air1"
Ingame.tileDict[1] 	= {	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Ingame.Settings.tileSize, Ingame.Settings.tileSize},			-- function parameters
						{255,255,255},								-- color
						1,											-- speed multiplicator
						false										-- is obstacle
                      }
--
Ingame.tileNames[2]	= "air2"
Ingame.tileDict[2] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Ingame.Settings.tileSize, Ingame.Settings.tileSize},			-- function parameters
						{240,240,240},								-- color
						1,											-- speed multiplicator
						false										-- is obstacle
					}
--
Ingame.tileNames[3]	= "sand"
Ingame.tileDict[3] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Ingame.Settings.tileSize, Ingame.Settings.tileSize},			-- function parameters
						{255,243,191},								-- color
						0.4,										-- speed multiplicator
						false										-- is obstacle
					}
--
Ingame.tileNames[4]	= "simple obstacle"
Ingame.tileDict[4] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, Ingame.Settings.tileSize, Ingame.Settings.tileSize},			-- function parameters
						{0,0,0},									-- color
						1,											-- speed multiplicator
						true										-- is obstacle
					}
--
