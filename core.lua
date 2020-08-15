local L = LibStub("AceLocale-3.0"):GetLocale("TenPlusOne", true)

local defaults = {
  profile = {
    debug = false,
	bidduration = 15,
	bidprolong = 5,
  }
}

TenPlusOne.tpoOptionsTable = {
  type = "group",
  args = {
	duration = {
		name = L["Bid duration"],
		desc = L["Initial time for a bid"],
		type = "range",
		min = 0,
		softMax = 60,
		step = 1,
		order = 20,
		set = function(info,val) TenPlusOne.db.profile.bidduration = val end,
		get = function(info) return TenPlusOne.db.profile.bidduration end,
	},
	newline1 = { name="", type="description", order=21 },

	prolong = {
		name = L["Prolong bids"],
		desc = L["If a new bid came in, prolong time to end if necessary"],
		type = "range",
		min = 0,
		softMax = 30,
		step = 1,
		order = 30,
		set = function(info,val) TenPlusOne.db.profile.bidprolong = val end,
		get = function(info) return TenPlusOne.db.profile.bidprolong end,
	},
	
	newline_dbg = { name="", type="description", order=98 },
    debugging = {
      name = L["Debug"],
      type = "toggle",
      order = 99,
      set = function(info,val) TenPlusOne.db.profile.debug = val end,
      get = function(info) return TenPlusOne.db.profile.debug end,
    },
  }
}

function TenPlusOne:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("TenPlusOneDB", defaults)

  LibStub("AceConfig-3.0"):RegisterOptionsTable("TenPlusOne", self.tpoOptionsTable)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TenPlusOne", "TenPlusOne")
  
  -- interaction from raid members
  self:RegisterEvent("CHAT_MSG_WHISPER")
  self:RegisterEvent("CHAT_MSG_PARTY")
  self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
  self:RegisterEvent("CHAT_MSG_RAID")
  self:RegisterEvent("CHAT_MSG_RAID_LEADER")
  self:RegisterEvent("CHAT_MSG_RAID_WARNING")
  self:RegisterEvent("CHAT_MSG_SYSTEM")
 
  self:RegisterChatCommand("tpo", "ChatCommandTPO")
   
  if self.db.profile.currentroll == nil then
	self.db.profile.currentroll = {}
  end
  
end

function TenPlusOne:OnEnable()
    -- Called when the addon is enabled
end

function TenPlusOne:OnDisable()
    -- Called when the addon is disabled
end


function TenPlusOne:ChatCommandTPO(inc)

	if strtrim(inc) == "" then
		TenPlusOne:Print(L["Usage: |cFF00CCFF/tpo |cFFA335EE[Sword of a Thousand Truths]|r to start a bid"])
		TenPlusOne:Print(L["Usage: |cFF00CCFF/tpo config|r to open the configuration window"])
		return nil
	end

	if strlower(inc) == "config" then
		LibStub("AceConfigDialog-3.0"):Open("TenPlusOne")
		return nil
	end

	-- if inc is itemLink: start bidding
	local d, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, linkLevel, specializationID, reforgeId, unknown1, unknown2 = strsplit(":", inc)		
	if itemId then
		TenPlusOne:StartBidding(inc)
		return nil
	end
	
	-- if inc is not, analyze for command and parameter
--	local cmd, params = strsplit(" ", inc, 2) 
--	TenPlusOne:Print("got cmd " .. cmd .. " with params " .. params)
	
end


function TenPlusOne:Debug(t) 
	if (TenPlusOne.db.profile.debug) then
		TenPlusOne:Print("TenPlusOne DEBUG: " .. t)
	end
end


-- for debug outputs
function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end
