-------------------------------------------------------------------------------
-- QuickApp by MindScape - Designed for Enteleaie
-------------------------------------------------------------------------------

local addonData = {name="QuickApp",prefix="QABUTTON_"}
local currentVersion = GetAddOnMetadata("QuickApp", "Version")
local author = GetAddOnMetadata("QuickApp", "Author")

-------------------------------------------------------------------------------
-- Local Simple Functions
-------------------------------------------------------------------------------

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

local function playerName()
	local name = UIDROPDOWNMENU_INIT_MENU.name:gsub("%s","_")
	return name;
end

-------------------------------------------------------------------------------
-- Defining what buttons to add
-------------------------------------------------------------------------------

local menu = {
	{ text = "|cff00E5EEAppear", name="APPEAR",
			func = function()
				cmd("appear "..UIDROPDOWNMENU_INIT_MENU.name)
			end
	},
	{ text = "|cff00E5EESummon", name="SUMMON",
			func = function()
				cmd("summon "..UIDROPDOWNMENU_INIT_MENU.name)
			end
	},
}

-------------------------------------------------------------------------------
-- Adding our Buttons to the Right-Click!
-------------------------------------------------------------------------------

-- create our onClickFunction storage table
local onClickFunction = {}

-- Creating Nested Menu options
for index, button in ipairs(menu) do
local name = addonData.prefix..button.name:upper()
	if button.nested == 1 and type(button.nest) == "table" then
		for key,value in ipairs(button.nest) do
			UnitPopupButtons[value["NAME"]] = value["INFO"]
			if not UnitPopupMenus[name] then UnitPopupMenus[name] = {} end
			table.insert(UnitPopupMenus[name], value["NAME"] )
			if value["INFO"].func then onClickFunction[value["NAME"]] = value["INFO"].func end
		end
	end
end

for _, items in pairs(UnitPopupMenus) do
	local insertIndex
	for index, item in ipairs(items) do
		if item == "INTERACT_SUBSECTION_TITLE" then
			insertIndex = index
		end
		--if item == "WHISPER" then
			--insertIndex = index+1
		--end
	end
	if insertIndex then
		for index, button in ipairs(menu) do
			local name = addonData.prefix..button.name:upper()
				UnitPopupButtons[name] = button
				onClickFunction[name] = button.func
				table.insert(items, insertIndex + index - 1, name)
		end
	end
end

hooksecurefunc("UnitPopup_OnClick", function(self)
	if onClickFunction[self.value] then onClickFunction[self.value]() end
end)


-------------------------------------------------------------------------------
-- Slash Command to return current build being used
-------------------------------------------------------------------------------

SLASH_CCQAVERSION1, SLASH_CCQAVERSION2 = '/QuickApp', '/qa'; -- 3.
function SlashCmdList.CCQAVERSION(msg, editbox) -- 4.
 print("|cff00E5EEQuickApp v"..currentVersion);
end

--- End for now