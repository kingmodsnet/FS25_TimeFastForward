--if (self:getIsServer() or self.isMasterUser) and not g_sleepManager:getIsSleeping() and not g_currentMission.guidedTour:getBlocksTimeChange() then
-- todo: mod is not implementing g_currentMission.guidedTour:getBlocksTimeChange()
--local hasMasterRights = self.isMasterUser or self.isServer

--
-- TimeFastForward_KingMods
--
-- Author: KingMods
-- Date: 12.11.2024
-- Version: 1.0.0.0
--
-- https://www.kingmods.net/
--

TimeFastForward = {}

TimeFastForward.active = false
TimeFastForward.previousTimeScale = nil

function TimeFastForward:loadMap(name)
    local timeScales = { 600, 1200, 2400, 4800, 9600 }
	
	for i = 1, #timeScales, 1 do
		table.insert(Platform.gameplay.timeScaleSettings, timeScales[i])
	end
end

function TimeFastForward:keyEvent(unicode, sym, modifier, isDown)
    if bitAND(modifier, Input.MOD_LCTRL) > 0 and bitAND(modifier, Input.MOD_LALT) > 0 and Input.isKeyPressed(Input.KEY_k) then
        if not TimeFastForward.active then
            if (g_currentMission:getIsServer() or g_currentMission.isMasterUser) and not g_sleepManager:getIsSleeping() then
                local timeScaleIndex = Utils.getTimeScaleIndex(g_currentMission.missionInfo.timeScale)
                local currentTimeScale = Utils.getTimeScaleFromIndex(timeScaleIndex)

                g_currentMission:setTimeScale(Platform.gameplay.timeScaleSettings[#Platform.gameplay.timeScaleSettings])

                TimeFastForward.previousTimeScale = currentTimeScale
                TimeFastForward.active = true
            end
        end
    else
        if TimeFastForward.active then
            g_currentMission:setTimeScale(TimeFastForward.previousTimeScale)

            TimeFastForward.active = false
            TimeFastForward.previousTimeScale = nil
        end
    end
end

addModEventListener(TimeFastForward)
