local DCT = {}
local spellFormat = "%.1f"
local channelFormat = "%.1f"
local channelDelay = "|cffff2020%-.2f|r"
local castDelay = "|cffff2020%.2f|r"

function DCT:Enable()
	local path = GameFontHighlight:GetFont()

	for i = 1, 4 do
		self["castTimeText"..i] = _G["PartySpellBar"..i]:CreateFontString(nil, "ARTWORK")
		self["castTimeText"..i]:SetPoint("TOPRIGHT", _G["PartySpellBar"..i], "TOPRIGHT", 0, 19)
		self["castTimeText"..i]:SetFont(path, 12, "OUTLINE")
	end
end

local function PartyCastingBarFrame_OnUpdate(self, ...)
	if not self.unit then return end
	local castingBarFrame = _G[self:GetName()]
	
	if castingBarFrame.casting and castingBarFrame.maxValue then
		local text = castingBarFrame.casting and format(spellFormat, castingBarFrame.maxValue - GetTime()) or ""
		castingBarFrame.DCTCastTimeText:SetText(text)
		castingBarFrame.DCTCastTimeText:Show()
	elseif castingBarFrame.channeling and castingBarFrame.endTime then
		local text = castingBarFrame.channeling and format(channelFormat, castingBarFrame.endTime - GetTime()) or ""
		castingBarFrame.DCTCastTimeText:SetText(text)
		castingBarFrame.DCTCastTimeText:Show()
	else
		castingBarFrame.DCTCastTimeText:Hide()
	end
end

local function PartyCastingBarFrame_OnEvent(self, event, unit, ...)
	if not unit or string.sub(unit, 1, 5) ~= "party" then return end
	
	-- Additional event handling logic here...
	
	local castingBarFrame = _G[self:GetName()]
	
	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		castingBarFrame.spellPushback = nil
	end
end




function TargetofPartyHealthCheck()
	local prefix = this:GetParent():GetName();
	local unitHPMin, unitHPMax = this:GetMinMaxValues();	
	local unitCurrHP = this:GetValue();
	this:GetParent().unitHPPercent = unitCurrHP / unitHPMax;
	if ( UnitIsDead("party"..this:GetParent():GetID().."target") ) then
		getglobal(prefix.."Portrait"):SetVertexColor(0.35, 0.35, 0.35, 1.0);
	elseif ( UnitIsGhost("party"..this:GetParent():GetID().."target") ) then
		getglobal(prefix.."Portrait"):SetVertexColor(0.2, 0.2, 0.75, 1.0);
	elseif ( (this:GetParent().unitHPPercent > 0) and (this:GetParent().unitHPPercent <= 0.2) ) then
		getglobal(prefix.."Portrait"):SetVertexColor(1.0, 0.0, 0.0);
	else
		getglobal(prefix.."Portrait"):SetVertexColor(1.0, 1.0, 1.0, 1.0);
	end
	UnitFrameHealthBar_OnValueChanged(arg1);
end

function Party_Spellbar_OnLoad()
	local id = this:GetID();
	
	this:RegisterEvent("UNIT_TARGET");
	
	CastingBarFrame_OnLoad("party"..id, false);

	local barIcon = getglobal(this:GetName().."Icon");
	barIcon:Show();

	SetPartySpellbarAspect();
end

function Party_Spellbar_OnEvent()
	local id = this:GetID();
	
	local newevent = event;
	local newarg1 = arg1;
	--	Check for target specific events
	if ( event == "UNIT_TARGET" and arg1 == "party"..id) then
		-- check if the new target is casting a spell
		local nameChannel  = UnitChannelInfo(this.unit);
		local nameSpell  = UnitCastingInfo(this.unit);
		if ( nameChannel ) then
			newevent = "UNIT_SPELLCAST_CHANNEL_START";
			newarg1 = "party"..id;
		elseif ( nameSpell ) then
			newevent = "UNIT_SPELLCAST_START";
			newarg1 = "party"..id;
		else
			this.casting = nil;
			this.channeling = nil;
			this:SetMinMaxValues(0, 0);
			this:SetValue(0);
			this:Hide();
			return;
		end
	end
	CastingBarFrame_OnEvent(newevent, newarg1);
end

function SetPartySpellbarAspect()
	local barName = this:GetName();
	
	local frameText = getglobal(barName.."Text");
	if ( frameText ) then
		frameText:SetTextHeight(7);
		frameText:ClearAllPoints();
		frameText:SetPoint("TOP", barName, "TOP", 0, 6);
	end

	local frameBorder = getglobal(barName.."Border");
	if ( frameBorder ) then
		frameBorder:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small");
		frameBorder:SetWidth(118);
		frameBorder:SetHeight(29);
		frameBorder:ClearAllPoints();
		frameBorder:SetPoint("TOP", barName, "TOP", 0, 12);
	end

	local frameFlash = getglobal(barName.."Flash");
	if ( frameFlash ) then
		frameFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small");
		frameFlash:SetWidth(118);
		frameFlash:SetHeight(29);
		frameFlash:ClearAllPoints();
		frameFlash:SetPoint("TOP", barName, "TOP", 0, 12);
	end
	
	local frameIcon = getglobal(barName.."Icon");
	if ( frameIcon ) then
		frameIcon:SetWidth(10);
		frameIcon:SetHeight(10);
	end
end


function Party_Spellbar_AdjustPosition()
    local id = this:GetID();
    local yPos = 0;

	 -- Check if the party member has more than 10 buffs (second row)
	local buffCount = 0
    while (UnitBuff("party" .. id, buffCount + 1)) do
        buffCount = buffCount + 1
    end
    
    -- Check if the party member has a pet
    if ( getglobal("PartyMemberFrame"..id.."PetFrame"):IsShown() ) or ( buffCount >= 11 ) then
        yPos = yPos - 18;
    end

   
    

    -- Adjust the position
    this:SetPoint("TOP", "PartyMemberFrame"..id, "BOTTOM", 5, yPos);
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then  
		DCT.Enable(DCT)
		
		for i = 1, 4 do
	local castingBarFrame = _G["PartySpellBar"..i]
	castingBarFrame.DCTCastTimeText = castingBarFrame:CreateFontString(nil, "ARTWORK")
	castingBarFrame.DCTCastTimeText:SetFont(GameFontHighlight:GetFont(), 6, "OUTLINE")
	castingBarFrame.DCTCastTimeText:SetPoint("TOPRIGHT", castingBarFrame, "TOPRIGHT", 0, 1.5)
	
	castingBarFrame:HookScript("OnUpdate", PartyCastingBarFrame_OnUpdate)
	castingBarFrame:HookScript("OnEvent", PartyCastingBarFrame_OnEvent)
end

	end
end)