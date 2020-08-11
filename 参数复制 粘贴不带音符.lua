function manifest()
    myManifest = {
        name = "参数复制 粘贴不带音符",
        comment = "参数复制 粘贴不带音符",
        author = "白糖の正义铃 B站ID：180668218",
        pluginID = "{8C2176EE-2B4A-44ea-89B1-B3627085849F}",
        pluginVersion = "1.0.0.1",
        apiVersion = "3.0.0.1"
    }
    return myManifest
end

function split(str)
    local resultStrList = {}
    string.gsub(str, '[^' .. "," .. ']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end

function updateControl(valString, ctrlString, posInt)
    VSUpdateControlAt(ctrlString, posInt, tonumber(valString))
end

function main(processParam, envParam)
    local beginPosTick = processParam.beginPosTick
    local endPosTick = processParam.endPosTick
    local songPosTick = processParam.songPosTick
    local endStatus = 0

    local scriptDir = envParam.scriptDir
    local scriptName = envParam.scriptName
    local tempDir = envParam.tempDir

    local DYNArray = {}
    local BREArray = {}
    local BRIArray = {}
    local CLEArray = {}
    local GENArray = {}
    local PITArray = {}
    local PBSArray = {}
    local PORArray = {}
    local GWLArray = {}
    local XSYArray = {}
    local noteExArray = {}

    local idx = 1
    for line in io.lines("ParamCopy.dat") do
        if (idx == 1) then
            DYNArray = split(line)
        elseif (idx == 2) then
            BREArray = split(line)
        elseif (idx == 3) then
            BRIArray = split(line)
        elseif (idx == 4) then
            CLEArray = split(line)
        elseif (idx == 5) then
            GENArray = split(line)
        elseif (idx == 6) then
            PITArray = split(line)
        elseif (idx == 7) then
            PBSArray = split(line)
        elseif (idx == 8) then
            PORArray = split(line)
        elseif (idx == 9) then
            GWLArray = split(line)
        elseif (idx == 10) then
            XSYArray = split(line)
        end
        idx = idx + 1
    end

    local paramLen = table.getn(PITArray)
    local idx = 0
    for i = 1, paramLen do
        updateControl(DYNArray[i], "DYN", songPosTick + idx)
        updateControl(BREArray[i], "BRE", songPosTick + idx)
        updateControl(BRIArray[i], "BRI", songPosTick + idx)
        updateControl(CLEArray[i], "CLE", songPosTick + idx)
        updateControl(GENArray[i], "GEN", songPosTick + idx)
        updateControl(PITArray[i], "PIT", songPosTick + idx)
        updateControl(PBSArray[i], "PBS", songPosTick + idx)
        updateControl(PORArray[i], "POR", songPosTick + idx)
        updateControl(GWLArray[i], "GWL", songPosTick + idx)
        updateControl(XSYArray[i], "XSY", songPosTick + idx)
        idx = idx + 1
    end

    updateControl("64", "DYN", songPosTick + idx + 1)
    updateControl("0", "BRE", songPosTick + idx + 1)
    updateControl("64", "BRI", songPosTick + idx + 1)
    updateControl("0", "CLE", songPosTick + idx + 1)
    --updateControl("64", "GEN", songPosTick + idx + 1)
    updateControl("0", "PIT", songPosTick + idx + 1)
    --updateControl("2", "PBS", songPosTick + idx + 1)
    updateControl("64", "POR", songPosTick + idx + 1)
    updateControl("0", "GWL", songPosTick + idx + 1)
    --updateControl("0", "XSY", songPosTick + idx + 1)

    return endStatus
end
