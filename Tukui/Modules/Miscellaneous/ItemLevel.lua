local T, C, L = unpack((select(2, ...)))

local Miscellaneous = T["Miscellaneous"]
local ItemLevel = CreateFrame("Frame")
local GetItemQualityColor = (C_Item and C_Item.GetItemQualityColor) or GetItemQualityColor

function ItemLevel:Update()
	if not self then
		return
	end
	
	local Name = self.GetName and self:GetName() or ""
	local IsTarget = string.find(Name, "Inspect") and true or false

	if not self.ItemLevel then
		self.ItemLevel = self:CreateFontString(nil, "OVERLAY")
		self.ItemLevel:SetPoint("TOPRIGHT", 1, -1)
		self.ItemLevel:SetFont(C.Medias.Font, 14, "OUTLINE")
		self.ItemLevel:SetJustifyH("RIGHT")
	end

	local SlotID = self:GetID()

	if (SlotID >= INVSLOT_FIRST_EQUIPPED and SlotID <= INVSLOT_LAST_EQUIPPED) then
		local Level, Rarity

		if IsTarget then
			local ItemLink = GetInventoryItemLink("target", SlotID)

			if ItemLink then
				Level = GetDetailedItemLevelInfo(ItemLink)
				Rarity = GetInventoryItemQuality("target", SlotID)
			end
		else
			local Button = Item:CreateFromEquipmentSlot(SlotID)

			Level = Button:GetCurrentItemLevel()
			Rarity = GetInventoryItemQuality("player", SlotID)
		end

		if Level then
			self.ItemLevel:SetText(Level)

			if Rarity then
				local R, G, B = GetItemQualityColor(Rarity)
				self.ItemLevel:SetTextColor(R, G, B)
			else
				self.ItemLevel:SetTextColor(1, 1, 1)
			end
		else
			self.ItemLevel:SetText("")
		end
	end
end

function ItemLevel:AddPlayer()
	hooksecurefunc("PaperDollItemSlotButton_Update", ItemLevel.Update)
end

function ItemLevel:AddTarget()
	hooksecurefunc("InspectPaperDollItemSlotButton_Update", ItemLevel.Update)
end

function ItemLevel:OnEvent(event, addon)
	if addon == "Blizzard_InspectUI" then
		self:AddTarget()

		self:UnregisterAllEvents()
	end
end

function ItemLevel:Enable()
	if not C.Misc.ItemLevel then
		return
	end

	self:AddPlayer()

	self:RegisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", self.OnEvent)
end

Miscellaneous.ItemLevel = ItemLevel
