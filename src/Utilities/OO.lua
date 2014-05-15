--- create classes and derived classes
Utilities.OO = {}

--- Create a simple class so that you can make instances of a table
function Utilities.OO.createClass(ClassTable)
	ClassTable.__index = ClassTable

	setmetatable(ClassTable, { __call = function (cls, ...)
										local self = setmetatable({}, cls)
										self:new(...)
										return self
									end,
						      })
end

--- Create a derived class so that you can make instances of a table
function Utilities.OO.createDerivedClass(ClassTable, toInheritFrom)
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
