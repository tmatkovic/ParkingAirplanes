

local nbParkingSpots = 100

for i = 0, nbParkingSpots - 1, 1 do
	-- list representing parking spots
	redis.call("LPUSH", "parkingSpots", 0)
	-- random parking spot number will be taken from this set
	redis.call("SADD", "numsForRandom", i)
end
