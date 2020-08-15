local L = LibStub("AceLocale-3.0"):NewLocale("TenPlusOne", "enUS", true)

if L then

-- core
-- ----

L["Bid duration"] = "Bid duration"
L["Initial time for a bid"] = "Initial time for a bid"
L["Prolong bids"] = "Prolong bids"
L["If a new bid came in, prolong time to end if necessary"] = "If a new bid came in, prolong time to end if necessary"
L["Debug"] = "Debug"
L["Usage: |cFF00CCFF/tpo |cFFA335EE[Sword of a Thousand Truths]|r to start a bid"] = "Usage: |cFF00CCFF/tpo |cFFA335EE[Sword of a Thousand Truths]|r to start a bid"
L["Usage: |cFF00CCFF/tpo config|r to open the configuration window"] = "Usage: |cFF00CCFF/tpo config|r to open the configuration window"

-- bids
-- ----

L["Bidding for itemLink still running, cannot start new bidding now!"] = function(itemLink) return "Bidding for " .. itemLink .. " still running, cannot start new bidding now!" end
L["Start Bidding now: itemLink"] = function(itemLink) return "Start Bidding now: " .. itemLink end
L["You don't have assist, so I cannot put out Raid Warnings"] = "You don't have assist, so I cannot put out Raid Warnings"
L["You are not in a party or raid. So here we go: Have fun bidding for itemLink against yourself."] = function(itemLink) return "You are not in a party or raid. So here we go: Have fun bidding for " .. itemLink .. " against yourself." end
L["Current highest bid for itemLink is maxbid"] = function(itemLink, maxbid) return "Current highest bid for " .. itemLink .. " is " .. maxbid end
L["Bidding ended!"] = "Bidding ended!"
L["No one bid on itemLink"] = function (itemLink) return "No one bid on " .. itemLink end
L["Congratulations! maxplayers won itemLink for maxbid"] = function(maxplayers,itemLink,maxbid) return "Congratulations! " .. table.concat(maxplayers, ", ") .. " won " .. itemLink .. " for " ..  maxbid end
L["Tie! maxplayers please roll on itemLink for maxbid"] = function (maxplayers,itemLink,maxbid) return "Tie! " .. table.concat(maxplayers, ", ") .. " please roll on " .. itemLink .. " for " ..  maxbid end
L["Bidding ends in sec"] = function (s) return "Bidding ends in " .. s end

L["You passed on itemLink"] = function (itemLink) return "You passed on " .. itemLink end
L["Received your bid bid for itemLink"] = function (bid, itemLink) return "Received your bid " .. bid .. " for " .. itemLink .. ". Remember you can always pass with -" end
L["You already bid bid for itemLink"] = function (bid, itemLink) return "You already bid " .. bid .. " for " .. itemLink .. ". Remember you can always pass with -" end
L["LOW BID! Your bid of bid for itemLink is NOT current max bid!"] = function (bis, itemLink) return "LOW BID! Your bid of " .. bid .. " for " .. itemLink .. " is NOT current max bid!" end
L["We are bidding, not rolling. Please state your bid in Chat or Whisper."] = "We are bidding, not rolling. Please state your bid in Chat or Whisper."

end -- if L then
