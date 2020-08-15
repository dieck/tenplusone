local L = LibStub("AceLocale-3.0"):GetLocale("TenPlusOne", true)

-- Output to Raid chat, Party chat or chat window
function TenPlusOne:CanDoRaidWarning() 
	for i = 1, MAX_RAID_MEMBERS do
		local name, rank = GetRaidRosterInfo(i)
		if name == UnitName("player") then
			return (rank >= 1)
		end
	end
	return false
end

function TenPlusOne:OutputWithWarning(msg)
	if UnitInRaid("player") then
		if TenPlusOne:CanDoRaidWarning() then
			SendChatMessage(msg, "RAID_WARNING")
		else
			SendChatMessage(msg, "RAID")
		end
	else
		if UnitInParty("player") then
			SendChatMessage(msg, "PARTY")
		else
			TenPlusOne:Print(msg)
		end
	end
end

function TenPlusOne:Output(msg)
	if UnitInRaid("player") then
		SendChatMessage(msg, "RAID")
	else
		if UnitInParty("player") then
			SendChatMessage(msg, "PARTY")
		else
			TenPlusOne:Print(msg)
		end
	end
end


-- Loot handling functions
function TenPlusOne:StartBidding(itemLink)
	
	if not (TenPlusOne.db.profile.currentbidding.itemLink == nil) then
		TenPlusOne:Print(L["Bidding for itemLink still running, cannot start new bidding now!"](itemLink))
		return nil
	end
	
	startnotice = L["Start Bidding now: itemLink"](itemLink)
	
	if UnitInRaid("player") then
	
		if TenPlusOne:CanDoRaidWarning() then
			SendChatMessage(startnotice, "RAID_WARNING")
		else
			TenPlusOne:Print(L["You don't have assist, so I cannot put out Raid Warnings"])
			SendChatMessage(startnotice, "RAID")
		end

	else
		if UnitInParty("player") then
			SendChatMessage(startnotice, "PARTY")
		else
			TenPlusOne:Print(L["You are not in a party or raid. So here we go: Have fun bidding for itemLink against yourself."](itemLink))
		end
	end
	
	TenPlusOne.db.profile.currentbidding = {}
	TenPlusOne.db.profile.currentbidding["itemLink"] = itemLink
	TenPlusOne.db.profile.currentbidding["endTime"] = time() + TenPlusOne.db.profile.bidduration
	
	TenPlusOne.db.profile.currentbidding["maxBid"] = -1
	TenPlusOne.db.profile.currentbidding["announceNewMaxBid"] = false

	TenPlusOne.db.profile.currentbidding["bids"] = {}
	
	TenPlusOne.biddingTimer = TenPlusOne:ScheduleRepeatingTimer("BidTimerHandler", 1)
	
end

function TenPlusOne:BidTimerHandler()

	if TenPlusOne.db.profile.currentbidding["announceNewMaxBid"] then
		TenPlusOne:Output(L["Current highest bid for itemLink is maxbid"](TenPlusOne.db.profile.currentbidding.itemLink, TenPlusOne.db.profile.currentbidding["maxBid"]))
		TenPlusOne.db.profile.currentbidding["announceNewMaxBid"] = false
	end

	-- look if timer expired
	if TenPlusOne.db.profile.currentbidding["endTime"] <= time() then
		TenPlusOne:Output(L["Bidding ended!"])
		
		if TenPlusOne.db.profile.currentbidding.maxBid == -1 then
			TenPlusOne:OutputWithWarning(L["No one bid on itemLink"](TenPlusOne.db.profile.currentbidding.itemLink))
		else
		
			local newmax = -1
			local maxplayers = {}
			local singleplayer = true
			
			for name,bid in pairs(TenPlusOne.db.profile.currentbidding.bids) do 
				if bid > newmax then 
					maxplayers = {}
					newmax = bid
				end
				if bid == newmax then
					tinsert(maxplayers, name)
				end
			end

			if #maxplayers == 1 then
				TenPlusOne:OutputWithWarning(L["Congratulations! maxplayers won itemLink for maxbid"](maxplayers,TenPlusOne.db.profile.currentbidding.itemLink,TenPlusOne.db.profile.currentbidding.maxBid))
			else
				TenPlusOne:OutputWithWarning(L["Tie! maxplayers please roll on itemLink for maxbid"](maxplayers,TenPlusOne.db.profile.currentbidding.itemLink,TenPlusOne.db.profile.currentbidding.maxBid))
			end

			
		end
		
		TenPlusOne.db.profile.lastbidding = TenPlusOne.db.profile.currentbidding
		TenPlusOne.db.profile.currentbidding = {}
		TenPlusOne:CancelTimer(TenPlusOne.biddingTimer)
		return nil
	end
	
	-- if timer didn't expire yet, count down the last seconds
	rest = TenPlusOne.db.profile.currentbidding["endTime"] - time() 

	if rest <= 3 then
		TenPlusOne:Output(L["Bidding ends in sec"](rest))
		return nil
	end
	
end


-- different times of incoming messages
function TenPlusOne:CHAT_MSG_WHISPER(event, text, sender)		TenPlusOne:IncomingChat(text, sender) end
function TenPlusOne:CHAT_MSG_PARTY(event, text, sender)			TenPlusOne:IncomingChat(text, sender) end
function TenPlusOne:CHAT_MSG_PARTY_LEADER(event, text, sender)	TenPlusOne:IncomingChat(text, sender) end
function TenPlusOne:CHAT_MSG_RAID(event, text, sender)			TenPlusOne:IncomingChat(text, sender) end
function TenPlusOne:CHAT_MSG_RAID_LEADER(event, text, sender)	TenPlusOne:IncomingChat(text, sender) end
function TenPlusOne:CHAT_MSG_RAID_WARNING(event, text, sender)	TenPlusOne:IncomingChat(text, sender) end

function TenPlusOne:IncomingChat(text, sender)
	
	-- playerName may contain "-REALM"
	sender = strsplit("-", sender)
	
	if TenPlusOne.db.profile.currentbidding.itemLink == nil then
		-- no current bidding
		return nil
	end
	
	if text == "-" then
		TenPlusOne.db.profile.currentbidding.bids[sender] = nil 
		SendChatMessage(L["You passed on itemLink"](TenPlusOne.db.profile.currentbidding.itemLink), "WHISPER", nil, sender)
		
		-- if I was max bid, need to set new maxbid
		local newmax = -1
		for name,bid in pairs(TenPlusOne.db.profile.currentbidding.bids) do 
			if bid > newmax then newmax = bid end
		end
		TenPlusOne.db.profile.currentbidding.maxBid = newmax
		return
	end
	
	-- todo "minus" as delete bid
	
	trimmed = strtrim(text)
	if not string.match(trimmed, '^%d+$') then
		-- not a number, ignoring
		return nil
	end
	
	bid = tonumber(trimmed)
	
	-- prolong also if someone matches max bid
	if TenPlusOne.db.profile.currentbidding.maxBid <= bid then
		-- prolong if needed
		if TenPlusOne.db.profile.currentbidding["endTime"] < time() + TenPlusOne.db.profile.bidprolong then
			TenPlusOne.db.profile.currentbidding["endTime"] = time() + TenPlusOne.db.profile.bidprolong
		end
	end	

	if TenPlusOne.db.profile.currentbidding.maxBid < bid then
		TenPlusOne.db.profile.currentbidding.maxBid = bid
		TenPlusOne.db.profile.currentbidding.announceNewMaxBid = true
	end	
	
	-- todo: warning if you didn't get the highest bid or if you only matched
	
	if not TenPlusOne.db.profile.currentbidding.bids[sender] then
		TenPlusOne.db.profile.currentbidding.bids[sender] = bid
		SendChatMessage(L["Received your bid bid for itemLink"](bid, TenPlusOne.db.profile.currentbidding.itemLink), "WHISPER", nil, sender)

	else

		if TenPlusOne.db.profile.currentbidding.bids[sender] < bid then
			TenPlusOne.db.profile.currentbidding.bids[sender] = bid
			SendChatMessage(L["Received your bid bid for itemLink"](bid, TenPlusOne.db.profile.currentbidding.itemLink), "WHISPER", nil, sender)
		else
			SendChatMessage(L["You already bid bid for itemLink"](TenPlusOne.db.profile.currentbidding.bids[sender], TenPlusOne.db.profile.currentbidding.itemLink), "WHISPER", nil, sender)
		end
		
	end
	
	if TenPlusOne.db.profile.currentbidding.bids[sender] < TenPlusOne.db.profile.currentbidding.maxBid then
		SendChatMessage(L["LOW BID! Your bid of bid for itemLink is NOT current max bid!"](TenPlusOne.db.profile.currentbidding.bids[sender],TenPlusOne.db.profile.currentbidding.itemLink), "WHISPER", nil, sender)
	end
	
end

function TenPlusOne:CHAT_MSG_SYSTEM (event, text )
	-- seems there is a problem with the german Umlaut
	if GetLocale() == 'deDE' then RANDOM_ROLL_RESULT = "%s w\195\188rfelt. Ergebnis: %d (%d-%d)" end
	local pattern = RANDOM_ROLL_RESULT:gsub( "%%s", "(.+)" ):gsub( "%%d %(%%d%-%%d%)", ".*" )
	local sender = text:match(pattern)
	
	if sender and not (TenPlusOne.db.profile.currentbidding.itemLink == nil) then
		SendChatMessage(L["We are bidding, not rolling. Please state your bid in Chat or Whisper."], "WHISPER", nil, sender)
	end
end

