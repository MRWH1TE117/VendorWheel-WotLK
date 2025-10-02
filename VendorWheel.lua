-- VendorWheel (WotLK 3.3.5a)
-- Scroll w dół = następna strona, scroll w górę = poprzednia strona
-- Działa tylko na zakładce Vendor (MerchantFrame tab 1)
-- Shift + scroll = przeskok o 5 stron

local ADDON_NAME = ...

----------------------------------------------------------------------
-- Logika przewijania
----------------------------------------------------------------------
local function Page(delta)
  if not MerchantFrame or not MerchantFrame:IsShown() then return end
  -- tylko zakładka Vendor (1); pomiń Buyback (2)
  if MerchantFrame.selectedTab and MerchantFrame.selectedTab ~= 1 then return end

  local times = IsShiftKeyDown() and 5 or 1

  if delta < 0 then
    -- w dół -> następna strona
    for _ = 1, times do
      if MerchantNextPageButton
         and MerchantNextPageButton:IsShown()
         and (MerchantNextPageButton:IsEnabled() == 1 or MerchantNextPageButton:IsEnabled() == true)
      then
        MerchantNextPageButton:Click()
      else
        break
      end
    end
  else
    -- w górę -> poprzednia strona
    for _ = 1, times do
      if MerchantPrevPageButton
         and MerchantPrevPageButton:IsShown()
         and (MerchantPrevPageButton:IsEnabled() == 1 or MerchantPrevPageButton:IsEnabled() == true)
      then
        MerchantPrevPageButton:Click()
      else
        break
      end
    end
  end
end

----------------------------------------------------------------------
-- Bezpieczne podpinanie scrolla do ramek (pomija np. FontString)
----------------------------------------------------------------------
local function AttachWheel(frame)
  if not frame then return end
  if frame.__vw_attached then return end
  -- tylko obiekty-ramki z metodami wheel/hook
  if type(frame) ~= "table" then return end
  if type(frame.EnableMouseWheel) ~= "function" or type(frame.HookScript) ~= "function" then return end

  -- część ramek wymaga EnableMouse, część nie – sprawdź ostrożnie
  if type(frame.EnableMouse) == "function" then
    frame:EnableMouse(true)
  end

  frame:EnableMouseWheel(true)
  frame:HookScript("OnMouseWheel", function(_, delta) Page(delta) end)
  frame.__vw_attached = true
end

----------------------------------------------------------------------
-- Podpinanie do znanych elementów MerchantFrame
----------------------------------------------------------------------
local function AttachAll()
  if not MerchantFrame then return end

  -- Główna ramka handlarza
  AttachWheel(MerchantFrame)

  -- Sloty i przyciski – to są Frame/Button (mają wheel)
  local perPage = _G.MERCHANT_ITEMS_PER_PAGE or 10
  for i = 1, perPage do
    AttachWheel(_G["MerchantItem"..i])                -- cały slot
    AttachWheel(_G["MerchantItem"..i.."ItemButton"])  -- przycisk ikony
    -- NIE podpinamy MerchantItem..Name (FontString) – nie ma wheel
  end

  -- Buyback również często łapie kursor – podpinamy profilaktycznie
  AttachWheel(_G.MerchantBuyBackItem)
end

----------------------------------------------------------------------
-- Eventy i hooki
----------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then
    -- jeśli MerchantFrame już istnieje: podpinamy na OnShow
    if MerchantFrame then
      MerchantFrame:HookScript("OnShow", AttachAll)
      -- a jeśli akurat jest otwarty (rzadkie), podpinamy od razu
      if MerchantFrame:IsShown() then
        AttachAll()
      end
    else
      -- fallback: MerchantFrame bywa tworzony dopiero przy pierwszym otwarciu
      local waiter = CreateFrame("Frame")
      waiter:SetScript("OnUpdate", function(self)
        if MerchantFrame then
          MerchantFrame:HookScript("OnShow", AttachAll)
          if MerchantFrame:IsShown() then
            AttachAll()
          end
          self:SetScript("OnUpdate", nil)
        end
      end)
    end
  end
end)
