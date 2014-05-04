-- create classes and derived classes
OO = {}
function OO.createClass(ClassTable)
	ClassTable.__index = ClassTable

	setmetatable(ClassTable, { __call = function (cls, ...)
										local self = setmetatable({}, cls)
										self:new(...)
										return self
									end,
						      })
end

function OO.createDerivedClass(ClassTable, toInheritFrom)
	ClassTable.__index = ClassTable
	ClassTable.base = toInheritFrom

	setmetatable(ClassTable, { __index = toInheritFrom,
	                           __call =	function (cls, ...)
											local self = setmetatable({}, cls)
											self:new(...)
											return self
										end,
							  })
end
