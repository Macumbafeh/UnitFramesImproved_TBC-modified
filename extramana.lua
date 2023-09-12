

    --if tonumber(GetCVar'modUnitFrame') == 0 then return end

    local _, class = UnitClass'player'
    if class ~= 'DRUID' then return end

    local TEXTURE       = [[Interface\AddOns\UnitFramesImproved_TBC\Textures\sb.tga]]
    local BACKDROP      = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
    --local DruidManaLib  = AceLibrary'DruidManaLib-1.0'
	local DruidManaLib  = AceLibrary'LibDruidMana-1.0'

    local f = CreateFrame'Frame'

    PlayerFrame.ExtraManaBar = CreateFrame('StatusBar', 'ExtraManaBar', PlayerFrame)
    PlayerFrame.ExtraManaBar:SetWidth(100)
    PlayerFrame.ExtraManaBar:SetHeight(10)
    PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 36)
    PlayerFrame.ExtraManaBar:SetStatusBarTexture(TEXTURE)
    PlayerFrame.ExtraManaBar:SetStatusBarColor(ManaBarColor[0].r, ManaBarColor[0].g, ManaBarColor[0].b)
    PlayerFrame.ExtraManaBar:SetBackdrop(BACKDROP)
    PlayerFrame.ExtraManaBar:SetBackdropColor(0, 0, 0)

    PlayerFrame.ExtraManaBar.Text = PlayerFrame.ExtraManaBar:CreateFontString('ExtraManaBarText', 'OVERLAY', 'TextStatusBarText')
    PlayerFrame.ExtraManaBar.Text:SetFont("Fonts\\FRIZQT__.TTF", 9, 'OUTLINE')
    PlayerFrame.ExtraManaBar.Text:SetPoint('TOP', PlayerFrame.ExtraManaBar, 'BOTTOM', 0, 8)
    PlayerFrame.ExtraManaBar.Text:SetTextColor(0.8, 0.9, 0.9)

    PlayerFrame.ExtraManaBar:SetScript('OnMouseUp', function(bu)
        PlayerFrame:Click(bu)
    end)

    modSkin(PlayerFrame.ExtraManaBar, 1)
    modSkinColor(PlayerFrame.ExtraManaBar, .7, .7, .7)

    local OnUpdate = function()
        --DruidManaLib:MaxManaScript()
        --local v, max = DruidManaLib:GetMana()

		DruidManaLib:GetMaximumMana()
        local v, max = DruidManaLib:GetMana()

        PlayerFrame.ExtraManaBar:SetMinMaxValues(0, max)
        PlayerFrame.ExtraManaBar:SetValue(v)
        --PlayerFrame.ExtraManaBar.Text:SetText(true_format(v))
		PlayerFrame.ExtraManaBar.Text:SetText(v)
    end

    local OnEvent = function()
        if event == 'PLAYER_AURAS_CHANGED' then
            if not PlayerFrame.ExtraManaBar:IsShown() then return end
        end
        if  f.loaded and UnitPowerType'player' ~= 0 then
            PlayerFrame.ExtraManaBar:Show()
        else
            PlayerFrame.ExtraManaBar:Hide()
            f.loaded = true
        end
    end

    f:RegisterEvent'UNIT_DISPLAYPOWER'
    f:RegisterEvent'PLAYER_AURAS_CHANGED'

    f:SetScript('OnUpdate', OnUpdate)
    f:SetScript('OnEvent', OnEvent)

    --
	
	local energytick = CreateFrame("Frame", nil, PlayerFrame.ExtraManaBar)
    energytick:SetAllPoints(PlayerFrame.ExtraManaBar)
    energytick:RegisterEvent("PLAYER_ENTERING_WORLD")
    energytick:RegisterEvent("UNIT_DISPLAYPOWER")
    energytick:RegisterEvent("UNIT_ENERGY")
    energytick:RegisterEvent("UNIT_MANA")
    energytick:SetScript("OnEvent", function()
      if UnitPowerType("player") == 3 and UnitFramesImprovedDB.ManaBarTicks then
        this.mode = "MANA"
        -- hide if full mana and not in combat
        if (UnitMana("player") == UnitManaMax("player")) and (not UnitAffectingCombat("player")) then
          this:Show()
        else
          this:Show()
        end
      else
        this:Hide()
      end

      if event == "PLAYER_ENTERING_WORLD" then
        this.lastMana = UnitMana("player")
        this.spark:SetVertexColor(1, 1, 1, 1)
      end

      if (event == "PLAYER_ENTERING_WORLD") or (event == "UNIT_MANA") and arg1 == "player" then
        this.currentMana = UnitMana("player")
        local diff = 0
        if this.lastMana then
          diff = this.currentMana - this.lastMana
        end

        if this.mode == "MANA" and diff < 0 then
          this.target = 5
        elseif this.mode == "MANA" and diff > 0 then
          if this.max ~= 5 and diff > (this.badtick and this.badtick*1.2 or 5) then
            this.target = 2
          else
            this.badtick = diff
          end
        
        end
        this.lastMana = this.currentMana      
      end
    end)
  
  local pheight, pwidth = PlayerFrame.ExtraManaBar:GetHeight(), PlayerFrame.ExtraManaBar:GetWidth()
  energytick:SetScript("OnUpdate", function()    
    if this.target then
      this.start, this.max = GetTime(), this.target
      this.target = nil
    end

    if not this.start then return end

    this.current = GetTime() - this.start

    if this.current > this.max then
      this.start, this.max, this.current = GetTime(), 2, 0
    end

    local pos = (pwidth ~= "-1" and pwidth or width) * (this.current / this.max)
    if not pheight then return end
    this.spark:SetPoint("LEFT", pos-((pheight+5)/2), 0)
  end)

  energytick.spark = energytick:CreateTexture(nil, 'OVERLAY')
  energytick.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
  energytick.spark:SetHeight(pheight + 10)
  energytick.spark:SetWidth(pheight + 4)
  energytick.spark:SetBlendMode('ADD')
