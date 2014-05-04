tileDict = {}
tileNames = {}


---------------------------------------------------------------------------------------------------------------------------------------------------
tileNames[1]	= "air1"
tileDict[1] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, tileSize, tileSize},			-- function parameters
						{255,255,255},								-- color
						1,											-- speed multiplicator
						false										-- is obstacle
					}
---------------------------------------------------------------------------------------------------------------------------------------------------				
tileNames[2]	= "air2"
tileDict[2] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, tileSize, tileSize},			-- function parameters
						{240,240,240},								-- color
						1,											-- speed multiplicator
						false										-- is obstacle
					}
---------------------------------------------------------------------------------------------------------------------------------------------------
tileNames[3]	= "sand"
tileDict[3] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, tileSize, tileSize},			-- function parameters
						{255,243,191},								-- color
						0.4,										-- speed multiplicator
						false										-- is obstacle
					}
---------------------------------------------------------------------------------------------------------------------------------------------------
tileNames[4]	= "simple obstacle"
tileDict[4] 	= 	{	love.graphics.rectangle,					-- draw function
						{"fill", 0, 0, tileSize, tileSize},			-- function parameters
						{0,0,0},									-- color
						1,											-- speed multiplicator
						true										-- is obstacle
					}
---------------------------------------------------------------------------------------------------------------------------------------------------