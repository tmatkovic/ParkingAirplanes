
redis.replicate_commands()

local airplaneId = KEYS[1]

local function IsParkingSpotAlreadyAssigned(id)

	local retVal = -1
	local listSize = redis.call("LLEN", "parkingSpots")
	
	for i = 0, listSize - 1, 1 do
		if redis.call("LINDEX", "parkingSpots", i) == id then
			retVal = i
			break
		end
	end

	return retVal
end


if tonumber(airplaneId) < 1 or tonumber(airplaneId) > 80 then
	return "Invalid plane ID...values accepted: [1-80]"
end

-- first check if this airplane already has parking spot assigned
local parkingSpot = IsParkingSpotAlreadyAssigned(airplaneId)


-- -1 means unassigned
if parkingSpot == -1 then
	-- get some random parking spot from the numsForRandom set
	-- remove it also, so some other airplane can not get the same parking spot
	parkingSpot = redis.call("SPOP", "numsForRandom");
	-- set plane on this spot in the list
	redis.call("LSET", "parkingSpots", parkingSpot, airplaneId);
end

return tostring(parkingSpot)