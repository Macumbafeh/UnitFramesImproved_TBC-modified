-- Credits to stassart on curse.com for suggesting to use InCombatLockdown() checks in the code

local ADDON_NAME = "UnitFramesImproved"

-- Debug function. Adds message to the chatbox (only visible to the loacl player)
function dout(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

-- Additional debug info can be found on http://www.wowwiki.com/Blizzard_DebugTools
-- /framestack [showhidden]
--		showhidden - if "true" then will also display information about hidden frames
-- /eventtrace [command]
-- 		start - enables event capturing to the EventTrace frame
--		stop - disables event capturing
--		number - captures the provided number of events and then stops
--		If no command is given the EventTrace frame visibility is toggled. The first time the frame is displayed, event tracing is automatically started.
-- /dump expression
--		expression can be any valid lua expression that results in a value. So variable names, function calls, frames or tables can all be dumped.

UNITFRAMESIMPROVED_UI_COLOR = {r = .3, g = .3, b = .3}
FLAT_TEXTURE   = [[Interface\AddOns\UnitFramesImproved_TBC\Textures\flat.tga]]
ORIG_TEXTURE   = [[Interface\TargetingFrame\UI-StatusBar.blp]]

function tokenize(str)
	local tbl = {};
	for v in string.gmatch(str, "[^ ]+") do
		tinsert(tbl, v);
	end
	return tbl;
end

-- Default UnitFramesImprovedDB
local defaultUnitFramesImprovedDB = {
    ManaBarTicks = true,
	ClassTargetColor = false,
	ClassFriendlyTargetColor = false,
	targetframeflash = false,
	playerframe = 1.3,
	targetframe = 1.3,
	focusframe = 1.3,
	buffframe = 1.6,
	partyframe = 1.6,
	largeBuffSize = LARGE_BUFF_SIZE,
	smallBuffSize = SMALL_BUFF_SIZE,
	targetbuffsperrow = 6,
	EnableGrid = false,
	GridSize = 30,
	enablemoveunitframe = false,
	targetbuffplacement = 1,
}


-- Saved variables
UnitFramesImprovedDB = UnitFramesImprovedDB or {defaultUnitFramesImprovedDB}

-- Create the addon main instance
local UnitFramesImproved = CreateFrame('Button', 'UnitFramesImproved');


-- Interface options
local options = {
    type = "group",
    name = ADDON_NAME,
	width = "full",
    args = {
	   
	   optionframe = {
         type = "group",
         name = "Toggle Options",
         inline = true,
         order = 1,
		 width = "full",
         args = {
		 
        ManaBarTicks = {
			type = "toggle",
			name = "Enable Mana Bar ticks",
			desc = "Toggle ticks on Mana bar for druids",
			order = 0,
			width = "full",
			get = function()
				if UnitFramesImprovedDB.ManaBarTicks == nil then
					UnitFramesImprovedDB.ManaBarTicks = defaultUnitFramesImprovedDB.ManaBarTicks -- Set the default index
				end
					return UnitFramesImprovedDB.ManaBarTicks
				end,
			set = function(_, value)
				UnitFramesImprovedDB.ManaBarTicks = value
			end,
				},
				
		ClassTargetColor = {
			type = "toggle",
			name = "Enable Class Color on Enemy Target",
			desc = "Toggle Class Color on Enemy Target",
			order = 1,
			width = "full",
			get = function()
				if UnitFramesImprovedDB.ClassTargetColor == nil then
					UnitFramesImprovedDB.ClassTargetColor = defaultUnitFramesImprovedDB.ClassTargetColor -- Set the default index
				end
					return UnitFramesImprovedDB.ClassTargetColor
				end,
			set = function(_, value)
				UnitFramesImprovedDB.ClassTargetColor = value
			end,
				},
		ClassFriendlyTargetColor = {
			type = "toggle",
			name = "Enable Class Color on Friendly Players",
			desc = "Toggle Class Color on Friendly Players",
			order = 2,
			width = "full",
			get = function()
				if UnitFramesImprovedDB.ClassFriendlyTargetColor == nil then
					UnitFramesImprovedDB.ClassFriendlyTargetColor = defaultUnitFramesImprovedDB.ClassFriendlyTargetColor -- Set the default index
				end
					return UnitFramesImprovedDB.ClassFriendlyTargetColor
				end,
			set = function(_, value)
				UnitFramesImprovedDB.ClassFriendlyTargetColor = value
			end,
				},
		targetframeflash = {
			type = "toggle",
			name = "Disable TargetFrameFlash",
			desc = "Disable TargetFrameFlash on Target Frame",
			order = 3,
			width = "full",
			get = function()
				if UnitFramesImprovedDB.targetframeflash == nil then
					UnitFramesImprovedDB.targetframeflash = defaultUnitFramesImprovedDB.targetframeflash -- Set the default index
				end
					return UnitFramesImprovedDB.targetframeflash
				end,
			set = function(_, value)
				UnitFramesImprovedDB.targetframeflash = value
			end,
				},
		enablemoveunitframe = {
			type = "toggle",
			name = "Enable/disable the Move Frame feature",
			desc = "Drag them with shift or ctrl and left click",
			order = 4,
			width = "full",
			get = function()
				if UnitFramesImprovedDB.enablemoveunitframe == nil then
					UnitFramesImprovedDB.enablemoveunitframe = defaultUnitFramesImprovedDB.enablemoveunitframe -- Set the default index
				end
					return UnitFramesImprovedDB.enablemoveunitframe
				end,
			set = function(_, value)
				UnitFramesImprovedDB.enablemoveunitframe = value
			end,
				},
	},
},
	optionframetwo = {
         type = "group",
         name = "Frame Options",
         inline = true,
         order = 2,
		 width = "full",
         args = {
		
		playerframe = {
            type = "range",
            name = "Player Frame scale",
			order = 1,
			-- width = "full",
            desc = "Set the scale of the Player Frame",
            min = 0,
            max = 2,
            step = 0.1,
            get = function()
				if UnitFramesImprovedDB.playerframe == nil then
				UnitFramesImprovedDB.playerframe = defaultUnitFramesImprovedDB.playerframe 
				end
                return UnitFramesImprovedDB.playerframe
            end,
            set = function(info, value)
                UnitFramesImprovedDB.playerframe = value
            end
				},
		targetframe = {
            type = "range",
            name = "Target Frame scale",
			order = 2,
			-- width = "full",
            desc = "Set the scale of the Target Frame",
            min = 0,
            max = 2,
            step = 0.1,
            get = function()
				if UnitFramesImprovedDB.targetframe == nil then
				UnitFramesImprovedDB.targetframe = defaultUnitFramesImprovedDB.targetframe 
				end
                return UnitFramesImprovedDB.targetframe
            end,
            set = function(info, value)
                UnitFramesImprovedDB.targetframe = value
            end
				},
		focusframe = {
            type = "range",
            name = "Focus Frame scale",
			order = 3,
			-- width = "full",
            desc = "Set the scale of the Focus Frame (FocusFrame or ExtendedUnitFrame addon are needed!)",
            min = 0,
            max = 2,
            step = 0.1,
            get = function()
				if UnitFramesImprovedDB.focusframe == nil then
				UnitFramesImprovedDB.focusframe = defaultUnitFramesImprovedDB.focusframe
				end
                return UnitFramesImprovedDB.focusframe
            end,
            set = function(info, value)
                UnitFramesImprovedDB.focusframe = value
            end
				},
		buffframe = {
            type = "range",
            name = "Buff Frame scale",
			order = 4,
			-- width = "full",
            desc = "Set the scale of the Buff Frame",
            min = 0,
            max = 2,
            step = 0.1,
            get = function()
				if UnitFramesImprovedDB.buffframe == nil then
				UnitFramesImprovedDB.buffframe = defaultUnitFramesImprovedDB.buffframe 
				end
                return UnitFramesImprovedDB.buffframe
            end,
            set = function(info, value)
                UnitFramesImprovedDB.buffframe = value
            end
				},
		partyframe = {
            type = "range",
            name = "Party Frame scale",
			order = 5,
			-- width = "full",
            desc = "Set the scale of the Party Frame",
            min = 0,
            max = 2,
            step = 0.1,
            get = function()
				if UnitFramesImprovedDB.partyframe == nil then
				UnitFramesImprovedDB.partyframe = defaultUnitFramesImprovedDB.partyframe 
				end
                return UnitFramesImprovedDB.partyframe
            end,
            set = function(info, value)
                UnitFramesImprovedDB.partyframe = value
            end
				},
		largeBuffSize = {
				order = 6,
				name = "Large buff size",
				desc = "Set the size of your own debuff on the Target Frame",
				type = "range",
				min = 10, max = 50, step = 1,
				get = function()
				if UnitFramesImprovedDB.largeBuffSize == nil then
				UnitFramesImprovedDB.largeBuffSize = defaultUnitFramesImprovedDB.largeBuffSize 
				end
                return UnitFramesImprovedDB.largeBuffSize
			end,
            set = function(info, value)
                UnitFramesImprovedDB.largeBuffSize = value
            end
			},
		smallBuffSize = {
				order = 7,
				name = "Small buff size",
				type = "range",
				desc = "Set the size of other players debuff on the Target Frame",
				min = 10, max = 50, step = 1,
				get = function()
				if UnitFramesImprovedDB.smallBuffSize == nil then
				UnitFramesImprovedDB.smallBuffSize = defaultUnitFramesImprovedDB.smallBuffSize 
				end
                return UnitFramesImprovedDB.smallBuffSize
            end,
            set = function(info, value)
                UnitFramesImprovedDB.smallBuffSize = value
            end
			},
		targetbuffsperrow = {
				order = 8,
				name = "Target buffs per row",
				type = "range",
				desc = "Set the amount of buffs per lines",
				min = 2, max = 15, step = 1,
				get = function()
				if UnitFramesImprovedDB.targetbuffsperrow == nil then
				UnitFramesImprovedDB.targetbuffsperrow = defaultUnitFramesImprovedDB.targetbuffsperrow 
				end
                return UnitFramesImprovedDB.targetbuffsperrow
            end,
            set = function(info, value)
                UnitFramesImprovedDB.targetbuffsperrow = value
            end
			},
			
		targetbuffplacement = {
    type = "select",
    name = "Target Buff Placement",
    desc = "Set the placement of the Target Buffs and Debuffs",
    get = function()
		if UnitFramesImprovedDB.targetbuffplacement == nil then
            UnitFramesImprovedDB.targetbuffplacement = defaultUnitFramesImprovedDB.targetbuffplacement -- Set the default index for the harmful spells
        end
        return UnitFramesImprovedDB.targetbuffplacement
    end,
    set = function(info, value)
        UnitFramesImprovedDB.targetbuffplacement = value;
    end,
    values = {
    -- below
	"|TInterface\\CHATFRAME\\UI-ChatIcon-ScrollDown-Up:15:15|t All Below the Target Frame", 
	-- TopBuffOnTop
	"|TInterface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Up:15:15|t All Above with Debuffs at Top and Buffs at Bottom", 
	-- TopDebuffOnTop
	"|TInterface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Disabled:15:15|t All Above with Buffs at Top and Debuffs at Bottom",
	-- BuffOnTop and DebuffOnBot
	"|TInterface\\CHATFRAME\\UI-ChatIcon-Minimize-Up:15:15|t Buffs Above and Debuffs Below the Target Frame",
	},
    order = 9,
    width = "full",            
 },
		SaveAndReload = {
    type = "execute",
    name = "Save & Reload",
    desc = "Save the settings and reload the UI, if you have some issue click on this button to reload the game",
    func = function()
        StaticPopupDialogs["CONFIRM_RELOADUI"] = {
            text = "Are you sure you want to reload the UI?",
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                ReloadUI()
            end,
            OnCancel = function()
                -- Do nothing if the user cancels
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3, -- Ensure the dialog appears above other UI elements
        }

        StaticPopup_Show("CONFIRM_RELOADUI")
    end,
    order = 10,
		},
	},
		},
	optionframethree = {
         type = "group",
         name = "Grid Options",
         inline = true,
         order = 3,
		 width = "full",
         args = {
		EnableGrid = {
                    type = "toggle",
                    name = "Enable Grid",
                    desc = "Toggle the grid on or off.",
                    order = 0,
                    width = "full",
                    get = function()
                        if UnitFramesImprovedDB.EnableGrid == nil then
                            UnitFramesImprovedDB.EnableGrid = defaultUnitFramesImprovedDB.EnableGrid
                        end
                        return UnitFramesImprovedDB.EnableGrid
                    end,
                    set = function(_, value)
                        UnitFramesImprovedDB.EnableGrid = value
                        if value then
							if not grid then
								UnitFramesImproved:CreateGrid(UnitFramesImprovedDB.GridSize)
							else
								grid:Show()  -- Show the existing grid frame
							end
						else
							if grid then
								grid:Hide()  -- Hide the grid frame
							end
						end
					end,
                },
                GridSize = {
						type = "input",
						name = "Grid Size",
				        desc = "Set the size of the grid. Enter a number between 1 and 256. Advice numbers : 36, 62, 126, 256",
				        order = 1,
				        width = "full",
				        get = function()
				            return tostring(UnitFramesImprovedDB.GridSize)
				        end,
				        set = function(_, value)
				            value = tonumber(value)
							if value and value >= 1 and value <= 256 then
				                UnitFramesImprovedDB.GridSize = value
				                if UnitFramesImprovedDB.EnableGrid then
				                    UnitFramesImproved:CreateGrid(value)
				                end
				            end
				        end,
				        validate = function(_, value)
				            local num = tonumber(value)
				            if num and num >= 1 and num <= 256 then
				                return true
				            else
				                return "Please enter a number between 1 and 256."
				            end
				        end,
				        disabled = function() return not UnitFramesImprovedDB.EnableGrid end,
				    },
				GridBorderColor = {
				        type = "color",
				        name = "Grid Color",
				        desc = "Set the color of the Grid. Change the numbers or reload to set the color",
				        order = 3,
				        get = function()
				            local color = UnitFramesImprovedDB.GridBorderColor or { r = 0, g = 0, b = 0, a = 1 } -- Default black color
				            return color.r, color.g, color.b, color.a
				        end,
				        set = function(_, r, g, b, a)
				            UnitFramesImprovedDB.GridBorderColor = { r = r, g = g, b = b, a = a }
				    		-- print("GridBorderColor set to:", r, g, b, a) -- Debugging line
				        end,
 				       hasAlpha = true,
				        disabled = function()
				            return not UnitFramesImprovedDB.EnableGrid
				        end,
				    },
				},
			  },	
	},
}

-- Target Buff Blizzard position
function BuffSizer_TargetBuffDebuffBelow()
function TargetFrame_UpdateBuffAnchor(buffName, index, numFirstRowBuffs, numDebuffs, buffSize, offset, hasTargetofTarget)
	local buff = getglobal(buffName..index);
	
	if ( TargetofTargetFrame:IsShown() ) then
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	else
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	end
	
	if ( index == 1 ) then
		if ( UnitIsFriend("player", "target") ) then
			buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", TargetFrame.buffStartX, TargetFrame.buffStartY);
		else
			if ( numDebuffs > 0 ) then
				buff:SetPoint("TOPLEFT", TargetFrameDebuffs, "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			else
				buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", TargetFrame.buffStartX, TargetFrame.buffStartY);
			end
		end
		TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
		TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..1), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
		TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (2*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (3*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(2*numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (4*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(3*numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (5*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(4*numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (6*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(5*numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (7*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(6*numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end

	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
end
end

-- Target Buff Top with Buff at bottom and Debuff at top
function BuffSizer_TargetAllTopBuffBotDebuffTop()
function TargetFrame_UpdateBuffAnchor(buffName, index, numFirstRowBuffs, numDebuffs, buffSize, offset, hasTargetofTarget)
	local buff = getglobal(buffName..index);
	
	if ( TargetofTargetFrame:IsShown() ) then
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	else
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	end
	
	if ( index == 1 ) then
		if ( UnitIsFriend("player", "target") ) then
				buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -3);
			else
				--if ( numDebuffs > 0 ) then
					--buff:SetPoint("BOTTOMLEFT", TargetFrameDebuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
				--else
					buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -3);
				--end
			end
		TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..1), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (2*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (3*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(2*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (4*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(3*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (5*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(4*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (6*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(5*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (7*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(6*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end

	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
end

	-- Update debuff positioning/size
	function TargetFrame_UpdateDebuffAnchor(buffName, index, numFirstRowBuffs, numBuffs, buffSize, offset, ...)
		local buff = getglobal(buffName..index);
		
		if ( index == 1 ) then
			if ( UnitIsFriend("player", "target") and (numBuffs > 0) ) then
				buff:SetPoint("BOTTOMLEFT", TargetFrameBuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
			else
				if ( numBuffs > 0 ) then
					buff:SetPoint("BOTTOMLEFT", TargetFrameBuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
				else
					buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -20);
				end
			end
			TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..1), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( (index > numFirstRowBuffs) and (mod(index+(TARGET_DEBUFFS_PER_ROW-numFirstRowBuffs), TARGET_DEBUFFS_PER_ROW) == 1)) then
			-- Make a new row
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(index-TARGET_DEBUFFS_PER_ROW)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		else
			-- Just anchor to previous
			buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
		end
		
		-- Resize
		buff:SetWidth(buffSize);
		buff:SetHeight(buffSize);
		local debuffFrame = getglobal(buffName..index.."Border");
		debuffFrame:SetWidth(buffSize+2);
		debuffFrame:SetHeight(buffSize+2);
	end
end


-- Target Buff Blizzard position above the target frame
function BuffSizer_TargetAllTopDebuffBotBuffTop()
function TargetFrame_UpdateBuffAnchor(buffName, index, numFirstRowBuffs, numDebuffs, buffSize, offset, hasTargetofTarget)
	local buff = getglobal(buffName..index);
	
	if ( TargetofTargetFrame:IsShown() ) then
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	else
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	end
	
	if (index == 1) then
    if (UnitIsFriend("player", "target")) then
        if (numDebuffs > 0) then
            buff:SetPoint("BOTTOMLEFT", TargetFrameDebuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
        else
            buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -3);
        end
    else
        if (numDebuffs > 0) then
            buff:SetPoint("BOTTOMLEFT", TargetFrameDebuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
        else
            buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -3);
        end
    end
    buff:Show()  -- Ensure the buff is visible
    TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
    TargetFrame.buffRows = TargetFrame.buffRows+1;

	elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..1), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (2*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (3*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(2*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (4*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(3*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (5*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(4*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (6*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(5*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (7*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(6*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end

	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
end

-- Update debuff positioning/size
	function TargetFrame_UpdateDebuffAnchor(buffName, index, numFirstRowBuffs, numBuffs, buffSize, offset, hasTargetofTarget)
	local buff = getglobal(buffName..index);

	if (index == 1) then
    if (UnitIsFriend("player", "target") and (numBuffs > 0)) then
        -- Here we modify the debuff positioning to be dynamic based on the presence of buffs
       buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", 5, -TargetFrame.buffSpacing+120);
    end
		TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..1), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing+120);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( hasTargetofTarget and index == (2*numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing+120);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( (index > numFirstRowBuffs) and (mod(index+(TARGET_DEBUFFS_PER_ROW-numFirstRowBuffs), TARGET_DEBUFFS_PER_ROW) == 1) and not hasTargetofTarget ) then
		-- Make a new row
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-TARGET_DEBUFFS_PER_ROW)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing+120);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end
	
	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
	local debuffFrame = getglobal(buffName..index.."Border");
	debuffFrame:SetWidth(buffSize+2);
	debuffFrame:SetHeight(buffSize+2);
end
end


-- Target Buff with Debuff at bottom and Buff at top
function BuffSizer_TargetBuffTopDebuffBot()
function TargetFrame_UpdateBuffAnchor(buffName, index, numFirstRowBuffs, numDebuffs, buffSize, offset, hasTargetofTarget)
	local buff = getglobal(buffName..index);
	
	if ( TargetofTargetFrame:IsShown() ) then
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	else
		numFirstRowBuffs = UnitFramesImprovedDB.targetbuffsperrow;
	end
	
	if ( index == 1 ) then
		if ( UnitIsFriend("player", "target") ) then
				buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -3);
			else
				--if ( numDebuffs > 0 ) then
					--buff:SetPoint("BOTTOMLEFT", TargetFrameDebuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
				--else
					buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -3);
				--end
			end
		TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..1), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (2*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (3*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(2*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (4*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(3*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (5*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(4*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (6*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(5*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (7*numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(6*numFirstRowBuffs+1)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end

	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
end

	-- Update debuff positioning/size
	function TargetFrame_UpdateDebuffAnchor(buffName, index, numFirstRowBuffs, numBuffs, buffSize, offset, hasTargetofTarget)
	local buff = getglobal(buffName..index);

	if ( index == 1 ) then
		if ( UnitIsFriend("player", "target") and (numBuffs > 0) ) then
			buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", 5, -TargetFrame.buffSpacing+33);
		else
			buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", TargetFrame.buffStartX, TargetFrame.buffStartY);
		end
		TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( index == (numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..1), "BOTTOMLEFT", 5, -TargetFrame.buffSpacing+33);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( hasTargetofTarget and index == (2*numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "BOTTOMLEFT", 5, -TargetFrame.buffSpacing+33);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	elseif ( (index > numFirstRowBuffs) and (mod(index+(TARGET_DEBUFFS_PER_ROW-numFirstRowBuffs), TARGET_DEBUFFS_PER_ROW) == 1) and not hasTargetofTarget ) then
		-- Make a new row
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-TARGET_DEBUFFS_PER_ROW)), "BOTTOMLEFT", 5, -TargetFrame.buffSpacing+33);
		TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		TargetFrame.buffRows = TargetFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end
	
	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
	local debuffFrame = getglobal(buffName..index.."Border");
	debuffFrame:SetWidth(buffSize+2);
	debuffFrame:SetHeight(buffSize+2);
end
end


-- Function to register options
local function RegisterOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME, ADDON_NAME)
end


-- Call function to register options
RegisterOptions()

-- Event listener to make sure we enable the addon at the right time
function UnitFramesImproved:PLAYER_ENTERING_WORLD()
	if not UnitFramesImprovedDB.playerframe
	or not UnitFramesImprovedDB.targetframe
	or not UnitFramesImprovedDB.focusframe
	or not UnitFramesImprovedDB.buffframe
	or not UnitFramesImprovedDB.partyframe
	or not UnitFramesImprovedDB.largeBuffSize
	or not UnitFramesImprovedDB.smallBuffSize
	or not UnitFramesImprovedDB.targetbuffsperrow
	then
        UnitFramesImprovedDB = defaultUnitFramesImprovedDB 
    end
	

	-- Set some default settings
	if (characterSettings == nil) then
		UnitFramesImproved_LoadDefaultSettings();
	end
	
	EnableUnitFramesImproved();
		-- Interface
BuffFrame:SetScale(UnitFramesImprovedDB.buffframe)


for i=1,4 do _G["PartyMemberFrame"..i.."HealthBarText"]:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")end
for i=1,4 do _G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("TOP", 20, -13)end
for i=1,4 do _G["PartyMemberFrame"..i.."ManaBarText"]:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")end
for i=1,4 do _G["PartyMemberFrame" .. i]:SetScale(UnitFramesImprovedDB.partyframe)end


for i=1,4 do _G["PartyMemberFrame"..i.."Name"]:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")end
for i=1,4 do _G["PartyMemberFrame"..i.."PVPIcon"]:Hide()end

PlayerFrame:SetScale(UnitFramesImprovedDB.playerframe) 
PlayerPVPIcon:Hide()
PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
PlayerName:SetPoint("CENTER",50,38);
PlayerFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
PlayerFrameHealthBarText:SetPoint("CENTER", 50, 13);
PlayerFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");

TargetFrame:SetScale(UnitFramesImprovedDB.targetframe) 
TargetPVPIcon:Hide()
TargetName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
TargetName:SetPoint("CENTER",-50,38);
TargetFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
TargetFrameHealthBarText:SetPoint("TOP", -50,-33);
TargetFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");

FocusFrame:SetScale(UnitFramesImprovedDB.focusframe)
FocusName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
FocusName:SetPoint("CENTER",-50,38);
FocusFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
FocusFrameHealthBarText:SetPoint("TOP", -50,-31);
FocusFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");

	if UnitFramesImprovedDB.targetframeflash then
		TargetFrameFlash:SetAlpha(0)
	else
		TargetFrameFlash:SetAlpha(1)
	end
	
ComboFrame:SetScale(UnitFramesImprovedDB.targetframe)

self:ReloadVisual("largeBuffSize")
self:ReloadVisual("smallBuffSize")
UnitFramesImprovedDB.EnableGrid = false
self:CallBuffType()
end



function UnitFramesImproved:ReloadVisual(arg)
    if (arg == "largeBuffSize") then
        LARGE_BUFF_SIZE = UnitFramesImprovedDB.largeBuffSize
    elseif (arg == "smallBuffSize") then
        SMALL_BUFF_SIZE = UnitFramesImprovedDB.smallBuffSize
	end
end


function UnitFramesImproved:CallBuffType()
	if UnitFramesImprovedDB.targetbuffplacement == 1 then
		BuffSizer_TargetBuffDebuffBelow()
	elseif UnitFramesImprovedDB.targetbuffplacement == 2 then
		BuffSizer_TargetAllTopBuffBotDebuffTop()
	elseif UnitFramesImprovedDB.targetbuffplacement == 3 then
		BuffSizer_TargetAllTopDebuffBotBuffTop()
	elseif UnitFramesImprovedDB.targetbuffplacement == 4 then
		BuffSizer_TargetBuffTopDebuffBot()
	end
end

-- Create a table to store indicators for all frames
local moveIndicators = {}

-- Function to create a square indicator
-- Function to create a square indicator with a customizable size
local function CreateMoveIndicator(parentFrame, size)
    size = size or 16  -- Default size is 16 if not specified
    local indicator = CreateFrame("Frame", nil, parentFrame)
    indicator:SetFrameStrata("BACKGROUND")
    indicator:SetAllPoints(parentFrame)
    indicator:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        tile = true,
        tileSize = size,  -- Set the size of the indicator
        insets = { left = size / 4, right = size / 4, top = size / 4, bottom = size / 4 }
    })
    indicator:SetBackdropColor(0, 1, 1, 0.5)
    indicator:Hide()
    return indicator
end


-- Function to show/hide indicators based on Alt key state
local function UpdateMoveIndicators()
    local altKeyDown = IsAltKeyDown()
    for _, indicator in ipairs(moveIndicators) do
        if altKeyDown and UnitFramesImprovedDB.enablemoveunitframe then
            indicator:Show()
        else
            indicator:Hide()
        end
    end
end

local function ConditionallyAddFrame(frames, frame)
if frame then
	frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")

    local indicator = CreateMoveIndicator(frame)
    table.insert(moveIndicators, indicator)

    frame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    frame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
		end
		end)
	end
end

-- Attach drag functionality and create indicators for frames
local framesToMakeMovable = {PlayerFrame, TargetFrame, MinimapCluster, PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4,
							PetFrame, TotemFrame, TargetofTargetFrame, CastingBarFrame, MirrorTimer1, AlwaysUpFrame1, WorldStateAlwaysUpFrame
} -- Add more frames as needed

local durabilityFrame = DurabilityFrame
if durabilityFrame then
	local frameDurability = CreateFrame("Frame", "DragFrameDurability", UIParent)
    durabilityFrame:EnableMouse(true)
    durabilityFrame:SetMovable(true)
    durabilityFrame:RegisterForDrag("LeftButton")
	DurabilityFrame:SetScale(1.3)
    -- Create a larger square indicator for durabilityFrame
    local indicator = CreateMoveIndicator(durabilityFrame, 270)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    durabilityFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    durabilityFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	DurabilityFrame.SetPoint = function() end
end

local shapeshiftBarFrame = ShapeshiftBarFrame
if shapeshiftBarFrame then
    shapeshiftBarFrame:EnableMouse(true)
    shapeshiftBarFrame:SetMovable(true)
    shapeshiftBarFrame:RegisterForDrag("LeftButton")

    -- Create a larger square indicator for ShapeshiftBarFrame
    local indicator = CreateMoveIndicator(shapeshiftBarFrame, 200)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    shapeshiftBarFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    shapeshiftBarFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
end

local petActionBarFrame = PetActionBarFrame
if petActionBarFrame then
	-- Set the X and Y coordinates for the PetActionBarFrame
    local petActionBarXPos = 480  -- Replace with your desired X coordinate
    local petActionBarYPos = 140  -- Replace with your desired Y coordinate

	local framePetActionBarFrame = CreateFrame("Frame", "DragFramePetActionBarFrame", UIParent)
    petActionBarFrame:EnableMouse(true)
    petActionBarFrame:SetMovable(true)
    petActionBarFrame:RegisterForDrag("LeftButton")

	PetActionBarFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", petActionBarXPos, petActionBarYPos);



    -- Create a larger square indicator for petActionBarFrame
    local indicator = CreateMoveIndicator(petActionBarFrame, nil)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    petActionBarFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    petActionBarFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	petActionBarFrame.SetPoint = function() end
end

local questwatchFrame = QuestWatchFrame
if questwatchFrame then
	local frameQuestWatchFrame = CreateFrame("Frame", "DragFrameQuestWatchFrame", UIParent)
    questwatchFrame:EnableMouse(true)
    questwatchFrame:SetMovable(true)
    questwatchFrame:RegisterForDrag("LeftButton")

    -- Create a larger square indicator for questwatchFrame
    local indicator = CreateMoveIndicator(questwatchFrame, nil)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    questwatchFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    questwatchFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	questwatchFrame.SetPoint = function() end
end

local buffFrame = BuffFrame
if buffFrame then
	local frameBuffFrame = CreateFrame("Frame", "DragFrameBuffFrame", UIParent)
    buffFrame:EnableMouse(true)
    buffFrame:SetMovable(true)
    buffFrame:RegisterForDrag("LeftButton")
	BuffFrame:SetPoint("TOPRIGHT", "TemporaryEnchantFrame", "TOPLEFT", -5, 0);
	
	
    -- Create a larger square indicator for buffFrame
    local indicator = CreateMoveIndicator(buffFrame, nil)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    buffFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    buffFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	buffFrame.SetPoint = function() end
end

local temporaryEnchantFrame = TemporaryEnchantFrame
if temporaryEnchantFrame then
	local frameTemporaryEnchantFrame = CreateFrame("Frame", "DragFrameTemporaryEnchantFrame", UIParent)
    temporaryEnchantFrame:EnableMouse(true)
    temporaryEnchantFrame:SetMovable(true)
    temporaryEnchantFrame:RegisterForDrag("LeftButton")

    -- Create a larger square indicator for temporaryEnchantFrame
    local indicator = CreateMoveIndicator(temporaryEnchantFrame, 250)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    temporaryEnchantFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    temporaryEnchantFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	temporaryEnchantFrame.SetPoint = function() end
end


-- Define a variable to track the state of the custom frame
local customDebuffFrame2 = nil

-- Function to create or load the custom debuff frame
local function GetCustomDebuffFrame()
    if not customDebuffFrame2 then
	
	 local buffHeight = TempEnchant1:GetHeight() or 0;
        customDebuffFrame2 = CreateFrame("Frame", "CustomDebuffFrame2", UIParent)
        customDebuffFrame2:SetSize(80, 80)
        customDebuffFrame2:EnableMouse(true)
        customDebuffFrame2:SetMovable(true)
        customDebuffFrame2:RegisterForDrag("LeftButton")

        -- Load the saved position from SavedVariables or set a default position
        local savedPosition = characterSettings.CustomDebuffFrame2Position
        if savedPosition then
            customDebuffFrame2:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", savedPosition.x, savedPosition.y)
        else
            customDebuffFrame2:SetPoint("TOPRIGHT", TempEnchant1, "BOTTOMRIGHT", 0, -1*((2*BUFF_ROW_SPACING)+buffHeight));
        end
		
        -- Create a larger square indicator for debuffFrame
        local indicator = CreateMoveIndicator(customDebuffFrame2, nil)  -- Set a larger size (e.g., 32)
        table.insert(moveIndicators, indicator)

        customDebuffFrame2:SetScript("OnDragStart", function(self)
            if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
                self.isMoving = true
                self:StartMoving()
            end
        end)

        customDebuffFrame2:SetScript("OnDragStop", function(self)
            if self.isMoving then
                self.isMoving = false
                self:StopMovingOrSizing()
                UpdateMoveIndicators()

                -- Save the new position to SavedVariables
                local x, y = self:GetLeft() * self:GetEffectiveScale(), self:GetTop() * self:GetEffectiveScale()
                characterSettings.CustomDebuffFrame2Position = { x = x, y = y }
            end
        end)
        customDebuffFrame2.SetPoint = function() end
    end
	
    return customDebuffFrame2
end





function BuffButton_UpdateAnchors(buttonName, index, filter)
    local rows = ceil(BUFF_ACTUAL_DISPLAY / BUFFS_PER_ROW);
    local buff = getglobal(buttonName .. index);
    local buffHeight = BuffButton1:GetHeight();

    if (filter == "HELPFUL") then
        if ((index > 1) and (mod(index, BUFFS_PER_ROW) == 1)) then
            -- New row
            if (index == BUFFS_PER_ROW + 1) then
                buff:SetPoint("TOP", BuffButton1, "BOTTOM", 0, -BUFF_ROW_SPACING);
            else
                buff:SetPoint("TOP", getglobal(buttonName .. (index - BUFFS_PER_ROW)), "BOTTOM", 0, -BUFF_ROW_SPACING);
            end
        elseif (index == 1) then
            buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0);
        else
            buff:SetPoint("RIGHT", getglobal(buttonName .. (index - 1)), "LEFT", -5, 0);
        end
    else
        -- Position debuffs
        if (filter == "HARMFUL") then
		local customDebuffFrame2 = GetCustomDebuffFrame()
            -- Modify the debuff anchoring here
            local customDebuffFrame = getglobal("CustomDebuffFrame") -- Change to your custom debuff frame name
            local debuffSpacing = 5  -- Adjust the spacing between debuffs

            if (customDebuffFrame and customDebuffFrame:IsShown()) then
                -- If your custom debuff frame exists and is shown
                local debuffIndex = index - BUFF_MAX_DISPLAY
                local numRows = ceil(DEBUFF_ACTUAL_DISPLAY / BUFFS_PER_ROW)

                local row = ceil(debuffIndex / BUFFS_PER_ROW)
                local col = debuffIndex % BUFFS_PER_ROW
                if (col == 0) then
                    col = BUFFS_PER_ROW
                end

                local xOffset = (col - 1) * (buff:GetWidth() + debuffSpacing)
                local yOffset = -((row - 1) * (buff:GetHeight() + debuffSpacing))
                buff:SetPoint("TOPLEFT", customDebuffFrame, "TOPLEFT", xOffset, yOffset)
            else
                -- Fall back to the original anchoring if your custom debuff frame is not shown
                if ((index > 1) and (mod(index, BUFFS_PER_ROW) == 1)) then
                    -- New row
                    buff:SetPoint("TOP", getglobal(buttonName .. (index - BUFFS_PER_ROW)), "BOTTOM", 0, -BUFF_ROW_SPACING)
                elseif (index == 1) then
                    if (rows < 2) then
                        buff:SetPoint("CENTER", customDebuffFrame2, "CENTER")
                    else
                        buff:SetPoint("CENTER", customDebuffFrame2, "CENTER")
                    end
                else
                    buff:SetPoint("RIGHT", getglobal(buttonName .. (index - 1)), "LEFT", -5, 0)
                end
            end
        end
    end
end




-- Loop through all party member pet frames
for i = 1, 4 do
    local partypetFrame = _G["PartyMemberFrame" .. i .. "PetFrame"]
    if partypetFrame then
		local partyframe = "PartyMemberFrame"..i;
        local frameName = "DragFramePartyMemberFrame" .. i .. "PetFrame"
        local framePartyMemberPet = CreateFrame("Frame", frameName, UIParent)
        
        partypetFrame:EnableMouse(true)
        partypetFrame:SetMovable(true)
        partypetFrame:RegisterForDrag("LeftButton")
		if ( SHOW_PARTY_PETS == "1" ) then
		partypetFrame:SetPoint("TOPLEFT", partyframe, "TOPLEFT", 23, -43);
	else
		partypetFrame:SetPoint("TOPLEFT", partyframe, "TOPLEFT", 23, -27);
	end
        -- Create a larger square indicator for partypetFrame
        local indicator = CreateMoveIndicator(partypetFrame, nil)  -- Set a larger size (e.g., 32)
        table.insert(moveIndicators, indicator)

        partypetFrame:SetScript("OnDragStart", function(self)
            if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
                self.isMoving = true
                self:StartMoving()
            end
        end)

        partypetFrame:SetScript("OnDragStop", function(self)
            if self.isMoving then
                self.isMoving = false
                self:StopMovingOrSizing()
                UpdateMoveIndicators()
            end
        end)
        partypetFrame.SetPoint = function() end
    end
end

local targetFrameSpellBar = TargetFrameSpellBar
if TargetFrameSpellBar then
	local frameTargetFrameSpellBar = CreateFrame("Frame", "DragFrameTargetFrameSpellBar", UIParent)
    TargetFrameSpellBar:EnableMouse(true)
    TargetFrameSpellBar:SetMovable(true)
    TargetFrameSpellBar:RegisterForDrag("LeftButton")
	TargetFrameSpellBar:SetPoint("BOTTOM", "TargetFrame", "BOTTOM", -15, -25);
    -- Create a larger square indicator for TargetFrameSpellBar
    local indicator = CreateMoveIndicator(TargetFrameSpellBar, nil)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    TargetFrameSpellBar:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    TargetFrameSpellBar:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	TargetFrameSpellBar.SetPoint = function() end
end

local targetofFocusFrame = TargetofFocusFrame
if targetofFocusFrame then
	local frametargetofFocusFrame = CreateFrame("Frame", "DragFrameTargetofFocusFrame", UIParent)
    targetofFocusFrame:EnableMouse(true)
    targetofFocusFrame:SetMovable(true)
    targetofFocusFrame:RegisterForDrag("LeftButton")

    -- Create a larger square indicator for targetofFocusFrame
    local indicator = CreateMoveIndicator(targetofFocusFrame, nil)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    targetofFocusFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    targetofFocusFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	targetofFocusFrame.SetPoint = function() end
end



if NUM_EXTENDED_UI_FRAMES then
local lastBar = nil
for i = 1, NUM_EXTENDED_UI_FRAMES do
local worldStateCaptureBar1 = _G["WorldStateCaptureBar"..i]

	local frameWorldStateCaptureBar1 = CreateFrame("Frame", "DragFrameWorldStateCaptureBar1", UIParent)
    worldStateCaptureBar1:EnableMouse(true)
    worldStateCaptureBar1:SetMovable(true)
    worldStateCaptureBar1:RegisterForDrag("LeftButton")
	local captureBar = getglobal("WorldStateCaptureBar"..i)
				if captureBar and captureBar:IsVisible() then
				
					captureBar:ClearAllPoints()
					if i==1 then
						captureBar:SetPoint("CENTER", Minimap, "CENTER", -90, -110)
					else
						captureBar:SetPoint("CENTER", lastBar, "CENTER", -90, -110)
					end
					lastBar = captureBar
				end
    -- Create a larger square indicator for worldStateCaptureBar1
    local indicator = CreateMoveIndicator(worldStateCaptureBar1, nil)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    worldStateCaptureBar1:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    worldStateCaptureBar1:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	worldStateCaptureBar1.SetPoint = function() end
end

end

-- Create a single draggable frame
local dragFrame = CreateFrame("Frame", "DragFrameWorldStateCaptureBars", UIParent)
dragFrame:SetClampedToScreen(true)
dragFrame:EnableMouse(true)
dragFrame:SetMovable(true)
dragFrame:RegisterForDrag("LeftButton")
dragFrame:SetPoint("CENTER", Minimap, "CENTER", -90, -110)
dragFrame:SetSize(200, 200) -- Adjust the size as needed

dragFrame:SetScript("OnDragStart", function(self)
    if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
        self.isMoving = true
        self:StartMoving()
    end
end)

dragFrame:SetScript("OnDragStop", function(self)
    if self.isMoving then
        self.isMoving = false
        self:StopMovingOrSizing()
        UpdateMoveIndicators()
    end
end)

--[[for i = 1, NUM_EXTENDED_UI_FRAMES do
local cb = _G["WorldStateCaptureBar"..i]
hooksecurefunc(cb, "SetPoint", function(self, _, parent)
    if parent and (parent == "MinimapCluster" or parent == _G["MinimapCluster"]) then
        cb:ClearAllPoints()
        cb:SetPoint("CENTER", Minimap, "CENTER", -790, -110)
    end
end)
end]]

local function captureupdate()
    local nexty = 0
    for i = 1, NUM_EXTENDED_UI_FRAMES do
        local cb = _G["WorldStateCaptureBar"..i]
        if cb and cb:IsShown() then
            cb:ClearAllPoints()
            cb:SetPoint("CENTER", dragFrame, "CENTER")
            nexty = nexty + cb:GetHeight()
        end
    end
end

hooksecurefunc("WorldStateAlwaysUpFrame_Update", captureupdate)

-- Now, conditionally add each capture bar to the draggable frame
for i = 1, NUM_EXTENDED_UI_FRAMES do
    local cb = _G["WorldStateCaptureBar"..i]
    ConditionallyAddFrame(cb)
end
	
local possessBarFrame = PossessBarFrame
if possessBarFrame ~= nil then
	local framePossessBarFrame = CreateFrame("Frame", "DragFramePossessBarFrame", UIParent)
    possessBarFrame:EnableMouse(true)
    possessBarFrame:SetMovable(true)
    possessBarFrame:RegisterForDrag("LeftButton")
	possessBarFrame:SetPoint("LEFT", "MultiBarBottomLeft", "LEFT", -0, -975)
    -- Create a larger square indicator for possessBarFrame
    local indicator = CreateMoveIndicator(possessBarFrame, 270)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    possessBarFrame:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    possessBarFrame:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	
end




--[[local targetFrameBuffs = TargetFrameToT:GetChildren()]  -- Replace buffFrameName with the actual name you find
if targetFrameBuffs then
    local frameTargetFrameBuffs = CreateFrame("Frame", "DragFrameTargetFrameBuffs", UIParent)
    targetFrameBuffs:EnableMouse(true)
    targetFrameBuffs:SetMovable(true)
    targetFrameBuffs:RegisterForDrag("LeftButton")

    -- Create a larger square indicator for targetFrameBuffs
    local indicator = CreateMoveIndicator(targetFrameBuffs, nil)  -- Set a larger size (e.g., 32)
    table.insert(moveIndicators, indicator)

    targetFrameBuffs:SetScript("OnDragStart", function(self)
        if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
            self.isMoving = true
            self:StartMoving()
        end
    end)

    targetFrameBuffs:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self.isMoving = false
            self:StopMovingOrSizing()
            UpdateMoveIndicators()
        end
    end)
	targetFrameBuffs.SetPoint = function() end
end]]



for _, frame in ipairs(framesToMakeMovable) do
    ConditionallyAddFrame(framesToMakeMovable, frame)
end	
	

-- Listen for Alt key press/release to update indicators
local altKeyFrame = CreateFrame("Frame")
altKeyFrame:SetScript("OnUpdate", function()
	if IsAltKeyDown() and UnitFramesImprovedDB.enablemoveunitframe then
		Minimap:EnableMouse(false)
		for i = 1, 6 do
            local shapeshiftButton = _G["PetActionButton" .. i]
            if shapeshiftButton then
                shapeshiftButton:EnableMouse(false)
            end
        end
		for i = 1, 10 do
            local petActionButton = _G["PetActionButton" .. i]
            if petActionButton then
                petActionButton:EnableMouse(false)
            end
        end
		for i = 1, 32 do
            local buffButton = _G["BuffButton" .. i]
            if buffButton then
                buffButton:EnableMouse(false)
            end
        end
		for i = 1, 2 do
            local TempEnchant = _G["TempEnchant" .. i]
            if TempEnchant then
                TempEnchant:EnableMouse(false)
            end
        end
		for i = 1, 4 do
            local totemFrameTotem = _G["TotemFrameTotem" .. i]
            if totemFrameTotem then
                totemFrameTotem:EnableMouse(false)
            end
		end
		for i = 1, 10 do
            local possessButton = _G["PossessButton" .. i]
            if possessButton then
                possessButton:EnableMouse(false)
            end
		end
		for i = 1, 10 do
            local dragFrameWorldStateCaptureBars = DragFrameWorldStateCaptureBars
            if dragFrameWorldStateCaptureBars then
                dragFrameWorldStateCaptureBars:EnableMouse(true)
            end
		end
		
	else 
	
		Minimap:EnableMouse(true)
		for i = 1, 6 do
            local shapeshiftButton = _G["PetActionButton" .. i]
            if shapeshiftButton then
                shapeshiftButton:EnableMouse(true)
            end
        end
		for i = 1, 10 do
            local petActionButton = _G["PetActionButton" .. i]
            if petActionButton then
                petActionButton:EnableMouse(true)
            end
        end
		for i = 1, 32 do
            local buffButton = _G["BuffButton" .. i]
            if buffButton then
                buffButton:EnableMouse(true)
            end
        end
		for i = 1, 2 do
            local TempEnchant = _G["TempEnchant" .. i]
            if TempEnchant then
                TempEnchant:EnableMouse(true)
            end
        end
		for i = 1, 4 do
            local totemFrameTotem = _G["TotemFrameTotem" .. i]
            if totemFrameTotem then
                totemFrameTotem:EnableMouse(true)
            end
		end
		for i = 1, 10 do
            local possessButton = _G["PossessButton" .. i]
            if possessButton then
                possessButton:EnableMouse(true)
            end
		end
		for i = 1, 10 do
            local dragFrameWorldStateCaptureBars = DragFrameWorldStateCaptureBars
            if dragFrameWorldStateCaptureBars then
                dragFrameWorldStateCaptureBars:EnableMouse(false)
            end
		end
		for i = 1, 32 do
            local buffButton = _G["DebuffButton" .. i]
            if buffButton then
                buffButton:EnableMouse(true)
            end
        end
	end
	UpdateMoveIndicators()
end)



-- Event listener to make sure we've loaded our settings and thta we apply them
function UnitFramesImproved:VARIABLES_LOADED()
	dout("UnitFramesImproved settings loaded!");
	
	-- Set some default settings
	if (characterSettings == nil) then
		UnitFramesImproved_LoadDefaultSettings();
	end
	
	if (not (characterSettings["PlayerFrameAnchor"] == nil)) then
		StaticPopup_Show("LAYOUT_RESETDEFAULT");
		characterSettings["PlayerFrameX"] = nil;
		characterSettings["PlayerFrameY"] = nil;
		characterSettings["PlayerFrameMoved"] = nil;
		characterSettings["PlayerFrameAnchor"] = nil;
	end
	
	UnitFramesImproved_ApplySettings(characterSettings);
	-- Call the function to apply the custom debuff frame's position
    local customDebuffFrame2 = GetCustomDebuffFrame()
    if customDebuffFrame2 then
        local buffHeight = TempEnchant1:GetHeight();
        customDebuffFrame2:SetPoint("TOPRIGHT", TempEnchant1, "BOTTOMRIGHT", 0, -1*((2*BUFF_ROW_SPACING)+buffHeight))
	end
end

function UnitFramesImproved_ApplySettings(settings)
	UnitFramesImproved_SetFrameScale(settings["FrameScale"])
	
end

function UnitFramesImproved_LoadDefaultSettings()
    characterSettings = characterSettings or {}
    characterSettings["FrameScale"] = "1.0";

    if not TargetFrame:IsUserPlaced() then
        TargetFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", 36, 0);
    end

    
end


function EnableUnitFramesImproved()
	-- Generic status text hook
	--hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", UnitFramesImproved_TextStatusBar_UpdateTextStringWithValues);
	--hooksecurefunc("TextStatusBar_UpdateTextString", UnitFramesImproved_TextStatusBar_UpdateTextStringWithValues);
	
	-- Hook PlayerFrame functions
	--hooksecurefunc("PlayerFrame_ToPlayerArt", UnitFramesImproved_PlayerFrame_ToPlayerArt);
	--hooksecurefunc("PlayerFrame_OnUpdate", UnitFramesImproved_PlayerFrame_ToPlayerArt);
	hooksecurefunc("HealthBar_OnValueChanged", UnitFramesImproved_ColorUpdate);
	hooksecurefunc("PlayerFrame_OnUpdate", UnitFramesImproved_ColorUpdate);
	--HealthBar_OnValueChanged = UnitFramesImproved_ColorUpdate;
	--hooksecurefunc("PlayerFrame_ToVehicleArt", UnitFramesImproved_PlayerFrame_ToVehicleArt);
	
	-- Hook TargetFrame functions
	hooksecurefunc("TargetFrame_CheckDead", UnitFramesImproved_TargetFrame_Update);
	hooksecurefunc("TargetFrame_Update", UnitFramesImproved_TargetFrame_Update);
	hooksecurefunc("TargetFrame_OnUpdate", UnitFramesImproved_TargetFrame_Update);
	--hooksecurefunc("TargetFrame_OnUpdate", UnitFramesImproved_TargetFrame_Update);
	hooksecurefunc("TargetFrame_CheckFaction", UnitFramesImproved_TargetFrame_CheckFaction);
	hooksecurefunc("TargetFrame_CheckClassification", UnitFramesImproved_TargetFrame_CheckClassification);
	hooksecurefunc("TargetofTarget_Update", UnitFramesImproved_TargetFrame_Update);
	-- Hook FocusFrame functions
	hooksecurefunc("FocusFrame_CheckDead", UnitFramesImproved_FocusFrame_Update);
	hooksecurefunc("FocusFrame_Update", UnitFramesImproved_FocusFrame_Update);
	hooksecurefunc("FocusFrame_OnUpdate", UnitFramesImproved_FocusFrame_Update);
	--hooksecurefunc("FocusFrame_OnUpdate", UnitFramesImproved_FocusFrame_Update);
	hooksecurefunc("FocusFrame_CheckFaction", UnitFramesImproved_FocusFrame_CheckFaction);
	hooksecurefunc("FocusFrame_CheckClassification", UnitFramesImproved_FocusFrame_CheckClassification);
	hooksecurefunc("TargetofFocus_Update", UnitFramesImproved_FocusFrame_Update);
	
	-- BossFrame hooks
	--hooksecurefunc("BossTargetFrame_OnLoad", UnitFramesImproved_BossTargetFrame_Style);

	-- Setup relative layout for targetframe compared to PlayerFrame
	if not TargetFrame:IsUserPlaced() then
		if not InCombatLockdown() then 
			TargetFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", 36, 0);
		end
	end
	
	-- Set up some stylings
	UnitFramesImproved_Style_PlayerFrame();
	--UnitFramesImproved_BossTargetFrame_Style(Boss1TargetFrame);
	--UnitFramesImproved_BossTargetFrame_Style(Boss2TargetFrame);
	--UnitFramesImproved_BossTargetFrame_Style(Boss3TargetFrame);
	--UnitFramesImproved_BossTargetFrame_Style(Boss4TargetFrame);
	UnitFramesImproved_Style_TargetFrame(TargetFrame);
	UnitFramesImproved_Style_TargetFrame(FocusFrame);
	UnitFramesImproved_Style_TargetOfTargetFrame();
	UnitFramesImproved_Style_TargetOfFocusFrame();
	-- Update some values
	TextStatusBar_UpdateTextString(PlayerFrame.healthbar);
	TextStatusBar_UpdateTextString(PlayerFrame.manabar);

	-- Dark mode and flat textures
	UnitFramesImproved_DarkMode();
	--UnitFramesImproved_HealthBarTexture(FLAT_TEXTURE);

	PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
	TargetName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
	FocusName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");

	--PlayerFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE');
	--PlayerFrameManaBarText:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE');
	PetFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE');
	PetFrameManaBarText:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE');

end

function UnitFramesImproved_Style_TargetOfTargetFrame()
    if not InCombatLockdown() then
        TargetofTargetHealthBar.lockColor = true;
        TargetofTargetFrame.portrait:SetPoint("CENTER", 20, 0);
        
        hooksecurefunc("TargetofTarget_Update", function()
            local targetTargetUnit = "targettarget";
            local isTapped = UnitIsTapped(targetTargetUnit);
            local isTappedByPlayer = UnitIsTappedByPlayer(targetTargetUnit);
            local reaction = UnitReaction("targettarget", "player");
            
            if isTapped and not isTappedByPlayer then
                -- Tapped by other players, set health bar color to gray
                TargetofTargetHealthBar:SetStatusBarColor(0.5, 0.5, 0.5);
            else
                local isPlayerControlled = UnitPlayerControlled(targetTargetUnit);
                if isPlayerControlled then
                    -- Player-controlled target's target, set health bar color based on class etc.
                    TargetofTargetHealthBar:SetStatusBarColor(UnitColorToT(targetTargetUnit));
                else
                    local canAttack = UnitCanAttack("player", targetTargetUnit);
                    if (canAttack and reaction and not reaction == 4) or (canAttack and reaction and reaction <= 3)  then
                        -- Enemy target's target, set health bar color to red
                        TargetofTargetHealthBar:SetStatusBarColor(1, 0, 0);
                    else
                        if reaction and reaction == 4 then
						-- Neutral target's target, set health bar color to yellow
                            TargetofTargetHealthBar:SetStatusBarColor(1, 1, 0);
                        elseif reaction and reaction >= 4 then
                             -- Friendly target's target, set health bar color to green
                            TargetofTargetHealthBar:SetStatusBarColor(0, 1, 0);
                        end
                    end
                end
            end
        end);
    end
end




function UnitFramesImproved_Style_TargetOfFocusFrame()
	if not InCombatLockdown() then 
		TargetofFocusHealthBar.lockColor = true;
		TargetofFocusFrame.portrait:SetPoint("CENTER",20,0);
		
		hooksecurefunc("TargetofFocus_Update", function()
            local targetFocusUnit = "focustarget";
            local isTapped = UnitIsTapped(targetFocusUnit);
            local isTappedByPlayer = UnitIsTappedByPlayer(targetFocusUnit);
            local reaction = UnitReaction("focustarget", "player");
            
            if isTapped and not isTappedByPlayer then
                -- Tapped by other players, set health bar color to gray
                TargetofFocusHealthBar:SetStatusBarColor(0.5, 0.5, 0.5);
            else
                local isPlayerControlled = UnitPlayerControlled(targetFocusUnit);
                if isPlayerControlled then
                    -- Player-controlled target's target, set health bar color based on class etc.
                    TargetofFocusHealthBar:SetStatusBarColor(UnitColorToT(targetFocusUnit));
                else
                    local canAttack = UnitCanAttack("player", targetFocusUnit);
                    if (canAttack and reaction and not reaction == 4) or (canAttack and reaction and reaction <= 3)  then
                        -- Enemy target's target, set health bar color to red
                        TargetofFocusHealthBar:SetStatusBarColor(1, 0, 0);
                    else
                        if reaction and reaction == 4 then
						-- Neutral target's target, set health bar color to yellow
                            TargetofFocusHealthBar:SetStatusBarColor(1, 1, 0);
                        elseif reaction and reaction >= 4 then
                             -- Friendly target's target, set health bar color to green
                            TargetofFocusHealthBar:SetStatusBarColor(0, 1, 0);
                        end
                    end
                end
            end
        end);
	end
end

function UnitFramesImproved_ColorUpdate(self)
	--if this == PlayerFrameHealthBar then
		PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
	--else
	--	this.healthbar:SetStatusBarColor(UnitColor(this.healthbar.unit));
	--end
end

function UnitFramesImproved_Style_PlayerFrame()
	if not InCombatLockdown() then 
		PlayerFrameHealthBar.lockColor = true;
		PlayerFrameHealthBar.capNumericDisplay = true;
		PlayerFrameHealthBar:SetWidth(119);
		PlayerFrameHealthBar:SetHeight(29);
		PlayerFrameHealthBar:SetPoint("TOPLEFT",106,-22);
		PlayerFrameHealthBarText:SetPoint("CENTER",50,6);
	end
	
	PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame");
	PlayerStatusTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-Player-Status");
	PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
end

function UnitFramesImproved_Style_TargetFrame(self)
	--if not InCombatLockdown() then
		local classification = UnitClassification("target");
		if (classification == "minus") then
			TargetFrameHealthBar:SetHeight(12);
			TargetFrameHealthBar:SetPoint("TOPLEFT",6,-41); -- 7

			TargetFrameManaBar:SetPoint("TOPLEFT",6,-51);

			TargetFrameHealthBar.TextString:SetPoint("CENTER",-50,4);
			TargetDeadText:SetPoint("CENTER",-50,13);
			--TargetFrameNameBackground:SetPoint("TOPLEFT",7,-41);
			TargetFrameNameBackground:Hide();
		else
			TargetFrameHealthBar:SetHeight(29);
			TargetFrameHealthBar:SetPoint("TOPLEFT",6,-22);

			TargetFrameManaBar:SetPoint("TOPLEFT",6,-51);

			TargetFrameHealthBar.TextString:SetPoint("CENTER",-50,6);
			TargetDeadText:SetPoint("CENTER",-50,13);
			TargetFrameNameBackground:Hide();
			--TargetFrameNameBackground:SetPoint("TOPLEFT",7,-22);
		end
		
		TargetFrameHealthBar:SetWidth(119);
		TargetFrameHealthBar.lockColor = true;
	--end
end

function UnitFramesImproved_Style_FocusFrame(self)
	--if not InCombatLockdown() then
		local classification = UnitClassification("focus");
		if (classification == "minus") then
			FocusFrameHealthBar:SetHeight(12);
			FocusFrameHealthBar:SetPoint("TOPLEFT",6,-41); -- 7

			FocusFrameManaBar:SetPoint("TOPLEFT",6,-51);

			FocusFrameHealthBar.TextString:SetPoint("CENTER",-50,4);
			FocusDeadText:SetPoint("CENTER",-50,13);
			--FocusFrameNameBackground:SetPoint("TOPLEFT",7,-41);
			FocusFrameNameBackground:Hide();
		else
			FocusFrameHealthBar:SetHeight(29);
			FocusFrameHealthBar:SetPoint("TOPLEFT",6,-22);

			FocusFrameManaBar:SetPoint("TOPLEFT",6,-51);

			FocusFrameHealthBar.TextString:SetPoint("CENTER",-50,6);
			FocusDeadText:SetPoint("CENTER",-50,13);
			FocusFrameNameBackground:Hide();
			--FocusFrameNameBackground:SetPoint("TOPLEFT",7,-22);
		end
		
		FocusFrameHealthBar:SetWidth(119);
		FocusFrameHealthBar.lockColor = true;
	--end
end

function UnitFramesImproved_BossTargetFrame_Style(self)
	self.borderTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-UnitFrame-Boss");

	UnitFramesImproved_Style_TargetFrame(self);
	if (not (characterSettings["FrameScale"] == nil)) then
		if not InCombatLockdown() then 
			self:SetScale(characterSettings["FrameScale"] * 0.9);
		end
	end
end

function UnitFramesImproved_SetFrameScale(scale)
	if not InCombatLockdown() then 
		-- Scale the main frames
		PlayerFrame:SetScale(scale);
		TargetFrame:SetScale(scale);
		FocusFrame:SetScale(scale);
		
		-- Scale sub-frames
		ComboFrame:SetScale(scale); -- Still needed
		--RuneFrame:SetScale(scale); -- Can't do this as it messes up the scale horribly
		--RuneButtonIndividual1:SetScale(scale); -- No point in doing these either as the runeframes are now sacled to parent
		--RuneButtonIndividual2:SetScale(scale); -- No point in doing these either as the runeframes are now sacled to parent
		--RuneButtonIndividual3:SetScale(scale); -- No point in doing these either as the runeframes are now sacled to parent
		--RuneButtonIndividual4:SetScale(scale); -- No point in doing these either as the runeframes are now sacled to parent
		--RuneButtonIndividual5:SetScale(scale); -- No point in doing these either as the runeframes are now sacled to parent
		--RuneButtonIndividual6:SetScale(scale); -- No point in doing these either as the runeframes are now sacled to parent
		
		-- Scale the BossFrames, skip now as this seems to break
		-- Boss1TargetFrame:SetScale(scale*0.9);
		-- Boss2TargetFrame:SetScale(scale*0.9);
		-- Boss3TargetFrame:SetScale(scale*0.9);
		-- Boss4TargetFrame:SetScale(scale*0.9);
		
		characterSettings["FrameScale"] = scale;
	end
end


-- Slashcommand stuff
SLASH_UNITFRAMESIMPROVED1 = "/unitframesimproved";
SLASH_UNITFRAMESIMPROVED2 = "/ufi";
SlashCmdList["UNITFRAMESIMPROVED"] = function(msg, editBox)
	local tokens = tokenize(msg);
	if(table.getn(tokens) > 0 and strlower(tokens[1]) == "reset") then
		StaticPopup_Show("LAYOUT_RESET");
	elseif(table.getn(tokens) > 0 and strlower(tokens[1]) == "resetdebuff") then
		StaticPopup_Show("LAYOUT_RESETDEBUFF");
	elseif(table.getn(tokens) > 0 and strlower(tokens[1]) == "settings") then
		InterfaceOptionsFrame_Show(UnitFramesImproved.panelSettings);
	elseif(table.getn(tokens) > 0 and strlower(tokens[1]) == "scale") then
		if(table.getn(tokens) > 1) then
			UnitFramesImproved_SetFrameScale(tokens[2]);
		else
			dout("Please supply a number, between 0.0 and 10.0 as the second parameter.");
		end
	elseif(table.getn(tokens) > 0 and strlower(tokens[1]) == "gui") then
		InterfaceOptionsFrame_OpenToFrame(ADDON_NAME)
	elseif(table.getn(tokens) > 0 and strlower(tokens[1]) == "align") then
        local spacing = tonumber(tokens[2]) or -1
       UnitFramesImproved:CreateGridcmd(spacing) -- Call the grid creation function
	else
		dout("Valid commands for UnitFramesImproved are:")
		dout("    help    (shows this message)");
		dout("    scale # (scales the player frames)");
		dout("    reset   (resets the scale of the player frames)");
		dout("    resetdebuff   (resets the debuff frame of the player)");
		dout("    gui   (Open the interface option panel)");
		dout("    align #  (Create a grid with specified spacing)");
		dout("");
	end
end





-- Setup the static popup dialog for resetting the UI
StaticPopupDialogs["LAYOUT_RESET"] = {
	text = "Are you sure you want to reset your scale?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		UnitFramesImproved_LoadDefaultSettings();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

StaticPopupDialogs["LAYOUT_RESETDEFAULT"] = {
	text = "In order for UnitFramesImproved to work properly,\nyour old layout settings need to be reset.\nThis will reload your UI.",
	button1 = "Reset",
	button2 = "Ignore",
	OnAccept = function()
		PlayerFrame:SetUserPlaced(false);
		ReloadUI();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

StaticPopupDialogs["LAYOUT_RESETDEBUFF"] = {
	text = "The Debuff Frame will be in default position, This will reload your UI.",
	button1 = "Reset",
	button2 = "Ignore",
	OnAccept = function()
	UnitFramesImproved_ResetCustomDebuffFramePosition()
		ReloadUI();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

-- Define the grid creation function
function UnitFramesImproved:CreateGrid(spacing)
if UnitFramesImprovedDB.EnableGrid then
local color = UnitFramesImprovedDB.GridBorderColor or { r = 0, g = 0, b = 0, a = 1 } -- Default black color
-- print("Grid line color:", color.r, color.g, color.b, color.a)
	if grid then
            local regions = { grid:GetRegions() }
            for _, region in pairs(regions) do
                region:Hide()
            end
       else
            grid = CreateFrame("Frame", "grid", UIParent)
            grid:SetAllPoints(UIParent)
       end
    -- Your grid creation logic here using the 'spacing' variable
	CreateFrame("Frame", "grid", UIParent)
	grid:SetAllPoints(UIParent)
    regions = {grid:GetRegions()}
    for i,region in pairs(regions) do
        region:Hide()
        region = nil
    end
    if (spacing or -1) > 3 then
        local x = 0
        repeat
            local lastXLine = grid:CreateTexture(nil, "BORDER")
            lastXLine:SetWidth(1)
            lastXLine:SetHeight(grid:GetHeight())
            lastXLine:SetPoint("CENTER", x*spacing, 0)
            if x == 0 then
                lastXLine:SetTexture(1,0,0)
                lastXLine:SetDrawLayer("ARTWORK")
            else
                lastXLine:SetTexture(color.r, color.g, color.b, color.a)
            end
            x = x + 1
        until(x*spacing > (grid:GetWidth() /2))
        x = 1
        repeat
            local lastXLine = grid:CreateTexture(nil, "BORDER")
            lastXLine:SetWidth(1)
            lastXLine:SetHeight(grid:GetHeight())
            lastXLine:SetPoint("CENTER", -x*spacing, 0)
            lastXLine:SetTexture(color.r, color.g, color.b, color.a)
            x = x + 1
        until(x*spacing > (grid:GetWidth() /2))
        local y = 0
        repeat
            local lastYLine = grid:CreateTexture(nil, "BORDER")
            lastYLine:SetHeight(1)
            lastYLine:SetWidth(grid:GetWidth())
            lastYLine:SetPoint("CENTER", 0, y*spacing)
            if y == 0 then
                lastYLine:SetTexture(1,0,0)
                lastYLine:SetDrawLayer("ARTWORK")
            else            
                lastYLine:SetTexture(color.r, color.g, color.b, color.a)
            end
            y = y + 1
        until(y*spacing > (grid:GetHeight() / 2))
        y = 1
        repeat
            local lastYLine = grid:CreateTexture(nil, "BORDER")
            lastYLine:SetHeight(1)
            lastYLine:SetWidth(grid:GetWidth())
            lastYLine:SetPoint("CENTER", 0, -y*spacing)
			lastYLine:SetTexture(color.r, color.g, color.b, color.a)
            y = y + 1
        until(y*spacing > (grid:GetHeight() / 2))
       
    elseif grid then
        grid:Hide()
    end
end
end

function UnitFramesImproved:CreateGridcmd(spacing)
    -- Your grid creation logic here using the 'spacing' variable
	CreateFrame("Frame", "grid2", UIParent)
	grid2:SetAllPoints(UIParent)
    regions = {grid2:GetRegions()}
    for i,region in pairs(regions) do
        region:Hide()
        region = nil
    end
    if (spacing or -1) > 3 then
        local x = 0
        repeat
            local lastXLine = grid2:CreateTexture(nil, "BORDER")
            lastXLine:SetWidth(1)
            lastXLine:SetHeight(grid2:GetHeight())
            lastXLine:SetPoint("CENTER", x*spacing, 0)
            if x == 0 then
                lastXLine:SetTexture(1,0,0)
                lastXLine:SetDrawLayer("ARTWORK")
            else
                lastXLine:SetTexture(0,0,0)
            end
            x = x + 1
        until(x*spacing > (grid2:GetWidth() /2))
        x = 1
        repeat
            local lastXLine = grid2:CreateTexture(nil, "BORDER")
            lastXLine:SetWidth(1)
            lastXLine:SetHeight(grid2:GetHeight())
            lastXLine:SetPoint("CENTER", -x*spacing, 0)
            lastXLine:SetTexture(0,0,0)
            x = x + 1
        until(x*spacing > (grid2:GetWidth() /2))
        local y = 0
        repeat
            local lastYLine = grid2:CreateTexture(nil, "BORDER")
            lastYLine:SetHeight(1)
            lastYLine:SetWidth(grid2:GetWidth())
            lastYLine:SetPoint("CENTER", 0, y*spacing)
            if y == 0 then
                lastYLine:SetTexture(1,0,0)
                lastYLine:SetDrawLayer("ARTWORK")
            else            
                lastYLine:SetTexture(0,0,0)
            end
            y = y + 1
        until(y*spacing > (grid2:GetHeight() / 2))
        y = 1
        repeat
            local lastYLine = grid2:CreateTexture(nil, "BORDER")
            lastYLine:SetHeight(1)
            lastYLine:SetWidth(grid2:GetWidth())
            lastYLine:SetPoint("CENTER", 0, -y*spacing)
			lastYLine:SetTexture(0,0,0)
            y = y + 1
        until(y*spacing > (grid2:GetHeight() / 2))
        
	
	end
end


function UnitFramesImproved_TextStatusBar_UpdateTextStringWithValues(textStatusBar)
	if ( not textStatusBar ) then
		textStatusBar = this;
	end
	local textString = textStatusBar.TextString;
	if(textString) then
		local value = textStatusBar:GetValue();
		local valueMin, valueMax = textStatusBar:GetMinMaxValues();

		if ( ( tonumber(valueMax) ~= valueMax or valueMax > 0 ) and not ( textStatusBar.pauseUpdates ) ) then
			textStatusBar:Show();
			if ( value and valueMax > 0 and ( GetCVar("statusTextPercentage") == "1" or textStatusBar.showPercentage ) ) then
				if ( value == 0 and textStatusBar.zeroText ) then
					textString:SetText(textStatusBar.zeroText);
					textStatusBar.isZero = 1;
					textString:Show();
					return;
				end
				value = tostring(math.ceil((value / valueMax) * 100)) .. "%";
				if ( textStatusBar.prefix and (textStatusBar.alwaysPrefix or not (textStatusBar.cvar and GetCVar(textStatusBar.cvar) == "1" and textStatusBar.textLockable) ) ) then
					textString:SetText(textStatusBar.prefix .. " " .. value);
				else
					textString:SetText(value);
				end
			elseif ( value == 0 and textStatusBar.zeroText ) then
				textString:SetText(textStatusBar.zeroText);
				textStatusBar.isZero = 1;
				textString:Show();
				return;
			else
				textStatusBar.isZero = nil;
				if ( textStatusBar.prefix and (textStatusBar.alwaysPrefix or not (textStatusBar.cvar and GetCVar(textStatusBar.cvar) == "1" and textStatusBar.textLockable) ) ) then
					textString:SetText(textStatusBar.prefix.." "..value.." / "..valueMax);
				else
					textString:SetText(value.." / "..valueMax);
				end
			end
			
			if ( (textStatusBar.cvar and GetCVar(textStatusBar.cvar) == "1" and textStatusBar.textLockable) or textStatusBar.forceShow ) then
				textString:Show();
			elseif ( textStatusBar.lockShow > 0 ) then
				textString:Show();
			else
				textString:Hide();
			end
		else
			textString:Hide();
			textStatusBar:Hide();
		end
	end
end

function UnitFramesImproved_PlayerFrame_ToPlayerArt(self)
	if not InCombatLockdown() then
		UnitFramesImproved_Style_PlayerFrame();
	end
end

function UnitFramesImproved_PlayerFrame_ToVehicleArt(self)
	if not InCombatLockdown() then
		PlayerFrameHealthBar:SetHeight(12);
		PlayerFrameHealthBarText:SetPoint("CENTER",50,3);
	end
end

function UnitFramesImproved_TargetFrame_Update(self)
	-- Set back color of health bar
	if ( not UnitPlayerControlled("target") and UnitIsTapped("target") and not UnitIsTappedByPlayer("target") ) then
		-- Gray if npc is tapped by other player
		this.healthbar:SetStatusBarColor(0.5, 0.5, 0.5);
	else
		-- Standard by class etc if not
		this.healthbar:SetStatusBarColor(UnitColor(this.healthbar.unit));
	end
end

function UnitFramesImproved_FocusFrame_Update(self)
	-- Set back color of health bar
	if ( not UnitPlayerControlled("focus") and UnitIsTapped("focus") and not UnitIsTappedByPlayer("focus") ) then
		-- Gray if npc is tapped by other player
		this.healthbar:SetStatusBarColor(0.5, 0.5, 0.5);
	else
		-- Standard by class etc if not
		this.healthbar:SetStatusBarColor(UnitColor(this.healthbar.unit));
	end
end

function UnitFramesImproved_TargetFrame_CheckClassification()

	local classification = UnitClassification("target");
		if ( classification == "worldboss" ) then
			TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Elite");
		elseif ( classification == "rareelite"  ) then
			TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Rare-Elite");
		elseif ( classification == "elite"  ) then
			TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Elite");
		elseif ( classification == "rare"  ) then
			TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Rare");
		else
			TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame");
		end
end

function UnitFramesImproved_FocusFrame_CheckClassification()

	local classification = UnitClassification("focus");
		if ( classification == "worldboss" ) then
			FocusFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Elite");
		elseif ( classification == "rareelite"  ) then
			FocusFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Rare-Elite");
		elseif ( classification == "elite"  ) then
			FocusFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Elite");
		elseif ( classification == "rare"  ) then
			FocusFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame-Rare");
		else
			FocusFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_TBC\\Textures\\UI-TargetingFrame");
		end
end

function UnitFramesImproved_TargetFrame_CheckFaction(self)
	local factionGroup = UnitFactionGroup("target");
	--dout(UnitClass("target")); -- For debug purpose
	if ( UnitIsPVPFreeForAll("target") ) then
		TargetPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		PlayerPVPIcon:Hide()
		TargetPVPIcon:Hide();
		for i=1,4 do _G["PartyMemberFrame"..i.."PVPIcon"]:Hide()end
	elseif ( factionGroup and UnitIsPVP(this.unit) and UnitIsEnemy("player", this.unit) ) then
		TargetPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		PlayerPVPIcon:Hide()
		TargetPVPIcon:Hide();
		for i=1,4 do _G["PartyMemberFrame"..i.."PVPIcon"]:Hide()end
	elseif ( factionGroup == "Alliance" or factionGroup == "Horde" ) then
		TargetPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		PlayerPVPIcon:Hide()
		TargetPVPIcon:Hide();
		for i=1,4 do _G["PartyMemberFrame"..i.."PVPIcon"]:Hide()end
	else
		PlayerPVPIcon:Hide()
		TargetPVPIcon:Hide();
		for i=1,4 do _G["PartyMemberFrame"..i.."PVPIcon"]:Hide()end
	end
	
	UnitFramesImproved_Style_TargetFrame(this.unit);
end

function UnitFramesImproved_FocusFrame_CheckFaction(self)
	local factionGroup = UnitFactionGroup("focus");
	--dout(UnitClass("focus")); -- For debug purpose
	if ( UnitIsPVPFreeForAll("focus") ) then
		FocusPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		FocusPVPIcon:Hide();
	elseif ( factionGroup and UnitIsPVP(this.unit) and UnitIsEnemy("player", this.unit) ) then
		FocusPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		FocusPVPIcon:Hide();
	elseif ( factionGroup == "Alliance" or factionGroup == "Horde" ) then
		FocusPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		FocusPVPIcon:Hide();
	else
		FocusPVPIcon:Hide();
	end
	
	UnitFramesImproved_Style_FocusFrame(this.unit);
end

-- Utility functions
function UnitColor(unit)
    local r, g, b;
    local sr, sg, sb = TargetFrameNameBackground:GetVertexColor();

    local localizedClass, englishClass = UnitClass(unit);
    local classColor = RAID_CLASS_COLORS[englishClass];

    if (not UnitIsPlayer(unit)) then
        if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
            -- Color it gray
            r, g, b = 0.5, 0.5, 0.5;
        else
            -- Color NPCs using the background color
            r, g, b = sr, sg, sb;
        end
    elseif (UnitIsPlayer(unit) and UnitIsFriend("player", unit) and UnitFramesImprovedDB.ClassFriendlyTargetColor) or (UnitFramesImprovedDB.ClassTargetColor and UnitIsPlayer(unit) and not UnitIsFriend("player", unit)) then
        if (classColor) then
            r, g, b = classColor.r, classColor.g, classColor.b;
        else
            -- Color friendly players who don't have a class color as green
            r, g, b = 0.0, 1.0, 0.0;
        end
		if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
            -- Color it gray
            r, g, b = 0.5, 0.5, 0.5;
		end
    else
        if UnitFramesImprovedDB.ClassTargetColor then
			r, g, b = 0, 1.0, 0.0; -- Color friendly players as green
		elseif UnitFramesImprovedDB.ClassFriendlyTargetColor then
			r, g, b = 1.0, 0.0, 0.0; -- Color enemy players as red
		else
			if UnitIsPlayer(unit) and UnitIsFriend("player", unit) then
				r, g, b = 0, 1.0, 0.0; -- Color friendly players as green
			elseif UnitIsPlayer(unit) and not UnitIsFriend("player", unit) then
				r, g, b = 1.0, 0.0, 0.0; -- Color enemy players as red
			end
		end
    end
	
    return r, g, b;
end

-- Handle coloring for TargetOfTarget (ToT)
function UnitColorToT(unit)
    local r, g, b;
    

    if (UnitIsPlayer(unit) and UnitIsFriend("player", unit)) then
        
           
            r, g, b = 0.0, 1.0, 0.0; -- Color friendly players without class color as green
        
    else
        r, g, b = 1.0, 0.0, 0.0; -- Color enemy players as red
    end

    return r, g, b;
end

function FocusColor(unit)
	local r, g, b;
	local sr, sg, sb = FocusFrameNameBackground:GetVertexColor();

	local localizedClass, englishClass = UnitClass(unit);
	local classColor = RAID_CLASS_COLORS[englishClass];

	--DEBUG MSG
	--DEFAULT_CHAT_FRAME:AddMessage(UnitClass(unit));

	if ( ( not UnitIsPlayer(unit) ) and ( ( not UnitIsConnected(unit) ) or ( UnitIsDeadOrGhost(unit) ) ) ) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
	elseif ( UnitIsPlayer(unit) ) then
		--Try to color it by class.
		
		if ( classColor ) then
			r, g, b = classColor.r, classColor.g, classColor.b;
		else
			if ( UnitIsFriend("player", unit) ) then
				r, g, b = 0.0, 1.0, 0.0;
				--DEFAULT_CHAT_FRAME:AddMessage(UnitClass("I PUT GREEN"));
			else
				r, g, b = 1.0, 0.0, 0.0;
			end
		end
	else -- IF NPC COLOR IT HERE!
		--if ( classColor ) then
		--	r, g, b = classColor.r, classColor.g, classColor.b;
		--else 
		--	r, g, b = 0, 1, 0;
		--end

		r, g, b = sr, sg, sb;
	end
	
	return r, g, b;
end

--------------------------------------------------------------------
-- Not being used but left it for future purposes
function UnitFramesImproved_AbbreviateLargeNumbers(value)
	local strLen = strlen(value);
	local retString = value;
	if (true) then
		if ( strLen >= 10 ) then
			retString = string.sub(value, 1, -10).."."..string.sub(value, -9, -9).."G";
		elseif ( strLen >= 7 ) then
			retString = string.sub(value, 1, -7).."."..string.sub(value, -6, -6).."M";
		elseif ( strLen >= 4 ) then
			retString = string.sub(value, 1, -4).."."..string.sub(value, -3, -3).."k";
		end
	else
		if ( strLen >= 10 ) then
			retString = string.sub(value, 1, -10).."G";
		elseif ( strLen >= 7 ) then
			retString = string.sub(value, 1, -7).."M";
		elseif ( strLen >= 4 ) then
			retString = string.sub(value, 1, -4).."k";
		end
	end
	return retString;
end

-- Bootstrap
function UnitFramesImproved_StartUp(self) 
	self:SetScript('OnEvent', function(self, event) self[event](self) end);
	self:RegisterEvent('PLAYER_ENTERING_WORLD');
	self:RegisterEvent('VARIABLES_LOADED');
end

UnitFramesImproved_StartUp(UnitFramesImproved);

-- Table Dump Functions -- http://lua-users.org/wiki/TableSerialization
function print_r (t, indent, done)
  done = done or {}
  indent = indent or ''
  local nextIndent -- Storage for next indentation value
  for key, value in pairs (t) do
    if type (value) == "table" and not done [value] then
      nextIndent = nextIndent or
          (indent .. string.rep(' ',string.len(tostring (key))+2))
          -- Shortcut conditional allocation
      done [value] = true
      print (indent .. "[" .. tostring (key) .. "] => Table {");
      print  (nextIndent .. "{");
      print_r (value, nextIndent .. string.rep(' ',2), done)
      print  (nextIndent .. "}");
    else
      print  (indent .. "[" .. tostring (key) .. "] => " .. tostring (value).."")
    end
  end
end

function UnitFramesImproved_DarkMode()
	-- Dark borders UI, code from modUI
	for _, v in pairs({
			-- MINIMAP CLUSTER
		--MinimapBorder,
		--MiniMapMailBorder,
		--MiniMapTrackingBorder,
		--MiniMapMeetingStoneBorder,
		--MiniMapMailBorder,
		--MiniMapBattlefieldBorder,
			-- UNIT & CASTBAR
		PlayerFrameTexture,
		TargetFrameTexture,
		FocusFrameTexture,
		PetFrameTexture,
		PartyMemberFrame1Texture,
		PartyMemberFrame2Texture,
		PartyMemberFrame3Texture,
		PartyMemberFrame4Texture,
		PartyMemberFrame1PetFrameTexture,
		PartyMemberFrame2PetFrameTexture,
		PartyMemberFrame3PetFrameTexture,
		PartyMemberFrame4PetFrameTexture,
		TargetofTargetTexture,
		TargetofFocusTexture,
		--CastingBarBorder,

		--[[
			-- MAIN MENU BAR
		MainMenuBarTexture0,
		MainMenuBarTexture1,
		MainMenuBarTexture2,
		MainMenuBarTexture3,
		MainMenuMaxLevelBar0,
		MainMenuMaxLevelBar1,
		MainMenuMaxLevelBar2,
		MainMenuMaxLevelBar3,
		MainMenuXPBarTextureLeftCap,
		MainMenuXPBarTextureRightCap,
		MainMenuXPBarTextureMid,
		BonusActionBarTexture0,
		BonusActionBarTexture1,
		ReputationWatchBarTexture0,
		ReputationWatchBarTexture1,
		ReputationWatchBarTexture2,
		ReputationWatchBarTexture3,
		ReputationXPBarTexture0,
		ReputationXPBarTexture1,
		ReputationXPBarTexture2,
		ReputationXPBarTexture3,
		SlidingActionBarTexture0,
		SlidingActionBarTexture1,
		MainMenuBarLeftEndCap,
		MainMenuBarRightEndCap,
		ExhaustionTick:GetNormalTexture(),
		]]

	})	do 
		v:SetVertexColor(UNITFRAMESIMPROVED_UI_COLOR.r, UNITFRAMESIMPROVED_UI_COLOR.g, UNITFRAMESIMPROVED_UI_COLOR.b)
	end
end

function UnitFramesImproved_HealthBarTexture(NAME_TEXTURE)
	PlayerFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	PlayerFrameManaBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetFrameManaBar:SetStatusBarTexture(NAME_TEXTURE)
	FocusFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	FocusFrameManaBar:SetStatusBarTexture(NAME_TEXTURE)
	PetFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	PetFrameManaBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetofTargetHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetofTargetManaBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetofFocusHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetofFocusManaBar:SetStatusBarTexture(NAME_TEXTURE)
	--Add party frames
	for i=1,4 do _G["PartyMemberFrame"..i.."HealthBar"]:SetStatusBarTexture(NAME_TEXTURE)end
	for i=1,4 do _G["PartyMemberFrame"..i.."ManaBar"]:SetStatusBarTexture(NAME_TEXTURE)end
end