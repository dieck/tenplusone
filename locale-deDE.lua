local L = LibStub("AceLocale-3.0"):NewLocale("Prio3", "deDE", false)

if L then

-- core
-- ----

L["Bid duration"] = "Dauer für Gebote"
L["Initial time for a bid"] = "Erste Zeit für Gebote"
L["Prolong bids"] = "Verlängern"
L["If a new bid came in, prolong time to end if necessary"] = "Zeit um welche die Gebotsphase verlängert wird, wenn Gebote eingehen"
L["Debug"] = "Debug"
L["Usage: |cFF00CCFF/tpo |cFFA335EE[Sword of a Thousand Truths]|r to start a bid"] = "Benutzung: |cFF00CCFF/tpo |cFFA335EE[Schwert der 1000 Wahrheiten]|r startet die Gebote"
L["Usage: |cFF00CCFF/tpo config|r to open the configuration window"] = "Benutzung: |cFF00CCFF/tpo config|r öffnet das Konfigurationsmenü"

-- bids
-- ----

L["Bidding for itemLink still running, cannot start new bidding now!"] = function(itemLink) return "Gebote für " .. itemLink .. " laufen noch, es kann noch keine neue Versteigerung beginnen!" end
L["Start Bidding now: itemLink"] = function(itemLink) return "Jetzt bieten für " .. itemLink end
L["You don't have assist, so I cannot put out Raid Warnings"] = "Du hast kein Assist, kann keine Raid-Warnung senden"
L["You are not in a party or raid. So here we go: Have fun bidding for itemLink against yourself."] = function(itemLink) return "Du bist nicht in einer Gruppe oder Raid. Also dann viel Spaß, du kannst jetzt gegen dich selbst auf " .. itemLink .. " bieten." end
L["Current highest bid for itemLink is maxbid"] = function(itemLink, maxbid) return "Aktuell höchstes Gebot für " .. itemLink .. " ist " .. maxbid end
L["Bidding ended!"] = "Bieten beendet!"
L["No one bid on itemLink"] = function (itemLink) return "Niemand hat für " .. itemLink .. " geboten" end
L["Congratulations! maxplayers won itemLink for maxbid"] = function(maxplayers,itemLink,maxbid) return "Glückwunsch! " .. table.concat(maxplayers, ", ") .. " hat " .. itemLink .. " gewonnen für " ..  maxbid end
L["Tie! maxplayers please roll on itemLink for maxbid"] = function (maxplayers,itemLink,maxbid) return "Gleichstand! " .. table.concat(maxplayers, ", ") .. " rollen jetzt auf " .. itemLink .. " für " ..  maxbid end
L["Bidding ends in sec"] = function (s) return "Gebote enden in " .. s end

L["You passed on itemLink"] = function (itemLink) return "Du hast auf " .. itemLink .. " gepasst" end
L["Received your bid bid for itemLink"] = function (bid, itemLink) return "Dein Gebot " .. bid .. " für " .. itemLink .. " ist angekommen. Denk dran, du kannst jederzeit passen mit -" end
L["You already bid bid for itemLink"] = function (bid, itemLink) return "Du hast bereits " .. bid .. " geboten für " .. itemLink .. ". Denk dran, du kannst jederzeit passen mit -" end
L["LOW BID! Your bid of bid for itemLink is NOT current max bid!"] = function (bis, itemLink) return "NIEDRIGES GEBOT! Dein Gebot " .. bid .. " für " .. itemLink .. " ist NICHT das höchste Gebot jetzt!" end
L["We are bidding, not rolling. Please state your bid in Chat or Whisper."] = "Wir würfeln nicht, wir bieten. Bitte gib ein Gebot ab im Chat oder flüstere es zu."

end -- if L then
