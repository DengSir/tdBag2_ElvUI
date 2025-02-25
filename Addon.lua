-- tdBag2_Glass.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/25/2020, 3:07:22 AM
--
local Addon = tdBag2
if not Addon then
    return
end

if not ElvUI then
    return
end

local E = unpack(ElvUI)
local S = E:GetModule('Skins')

local function ApplyItemButton(button)
    button:SetNormalTexture(E.ClearTexture)
    button:SetTemplate(nil, true)
    button:StyleButton()

    local name = button:GetName()
    local icon = (name and _G[button:GetName() .. 'IconTexture']) or button.IconTexture or button.Icon or button.texture
    if icon then
        icon:SetInside()
        icon:SetTexCoord(unpack(E.TexCoords))
    end

    if button.IconBorder then
        button.IconBorder:Hide()
    end

    if button.Icon then
        button.Icon:SetDrawLayer('ARTWORK')
    end

    if button.texture and button.Center then
        print(button)
        print(button.Center:GetDrawLayer())
    end
end

Addon:RegisterStyle('ElvUI', {
    overrides = {
        Frame = { --
            TEMPLATE = 'tdBag2ElvUIBaseFrameTemplate',
        },

        PluginFrame = { --
            BUTTON_TEMPLATE = 'tdBag2ElvUIToggleButtonTemplate',
            SPACING = 2,
        },

        TitleContainer = { --
            SCROLL_TEMPLATE = 'tdBag2ElvUIScrollFrameTemplate',
        },

        BagFrame = { --
            KEYRING_TEMPLATE = 'tdBag2BagTemplate',
        },

        ContainerFrame = {
            TEMPLATE = 'tdBag2ElvUIFrameTemplate',

            PlaceSearchBox = function(self)
                self.SearchBox:Show()

                if self.BagFrame:IsShown() then
                    self.SearchBox:SetPoint('RIGHT', self.BagFrame, 'LEFT', -6, 0)
                else
                    self.SearchBox:SetPoint('RIGHT', self, 'TOPRIGHT', -6, -45)
                end
            end,
        },

        EquipFrame = { --
            CENTER_TEMPLATE = 'tdBag2ElvUIEquipContainerCenterFrameTemplate',
        },

        ItemBase = {
            EMPTY_SLOT_TEXTURE = [[]],

            ApplyBorderColor = function(self, shown, r, g, b, a)
                if shown then
                    self:SetBackdropBorderColor(r, g, b, 1)
                else
                    self:SetBackdropBorderColor(unpack(E.media.bordercolor))
                end
            end,
        },
    },

    hooks = {
        Frame = {
            Constructor = function(self, ...)
                self:SetTemplate(nil, true)
                S:HandleCloseButton(self.Close)

                if self.OwnerSelector then
                    ApplyItemButton(self.OwnerSelector)
                end
            end,
        },

        ContainerFrame = {
            PlacePluginFrame = function(self, ...)
                if not self.meta.profile.pluginButtons then
                    self.PluginFrame:SetWidth(0.1)
                end
            end,
        },

        GlobalSearchFrame = {
            Constructor = function(self, ...)
                self.TitleFrame:SetPoint('TOPLEFT', 8, -8)
            end,
        },

        TitleContainer = {
            Constructor = function(self, ...)
                S:HandleScrollBar(self.ScrollFrame.ScrollBar)
            end,
        },

        PluginFrame = {
            CreatePluginButton = function(self, plugin)
                ApplyItemButton(self.pluginButtons[plugin.key])
            end,
        },

        ItemBase = {Constructor = ApplyItemButton},
        Bag = {
            Constructor = function(self)
                ApplyItemButton(self)
            end,
        },
    },
})
