function manifest()
    myManifest = {
        name = "参数复制 复制",
        comment = "参数复制 复制",
        author = "白糖の正义铃 B站ID：180668218",
        pluginID = "{8A2176EE-2B4A-44ea-89B1-B3627085849F}",
        pluginVersion = "1.0.0.1",
        apiVersion = "3.0.0.1"
    }
    return myManifest
end

function copyNoteEx(note_ex_src)
    local note_ex_new = {}
    --Normal Note Properties
    note_ex_new.posTick = note_ex_src.posTick
    note_ex_new.durTick = note_ex_src.durTick
    note_ex_new.noteNum = note_ex_src.noteNum
    note_ex_new.velocity = note_ex_src.velocity
    note_ex_new.phonemes = note_ex_src.phonemes
    note_ex_new.lyric = note_ex_src.lyric
    --Extended Note Properties
    note_ex_new.bendDepth = note_ex_src.bendDepth
    note_ex_new.bendLength = note_ex_src.bendLength
    note_ex_new.risePort = note_ex_src.risePort
    note_ex_new.fallPort = note_ex_src.fallPort
    note_ex_new.decay = note_ex_src.decay
    note_ex_new.accent = note_ex_src.accent
    note_ex_new.opening = note_ex_src.opening
    note_ex_new.vibratoLength = note_ex_src.vibratoLength
    note_ex_new.vibratoType = note_ex_src.vibratoType
    return note_ex_new
end

function writeArray(array, file)
    local arrayLen = table.getn(array)
    for idx = 1, arrayLen do
        if (idx == 1) then
            file:write(array[idx])
        else
            file:write("," .. array[idx])
        end
    end
    file:write("\n")
end

function writeNote(noteEx, file)
    file:write(noteEx.posTick .. ",")
    file:write(noteEx.durTick .. ",")
    file:write(noteEx.noteNum .. ",")
    file:write(noteEx.velocity .. ",")
    file:write(noteEx.lyric .. ",")
    file:write(noteEx.phonemes .. ",")
    if (noteEx.phLock == nil) then
        file:write(0 .. ",")
    else
        file:write(1 .. ",")
    end
    file:write(noteEx.bendDepth .. ",")
    file:write(noteEx.bendLength .. ",")
    file:write(noteEx.risePort .. ",")
    file:write(noteEx.fallPort .. ",")
    file:write(noteEx.decay .. ",")
    file:write(noteEx.accent .. ",")
    file:write(noteEx.opening .. ",")
    file:write(noteEx.vibratoLength .. ",")
    file:write(noteEx.vibratoType)
    file:write("\n")
end

function main(processParam, envParam)
    local beginPosTick = processParam.beginPosTick
    local endPosTick = processParam.endPosTick
    local songPosTick = processParam.songPosTick
    local endStatus = 0

    local scriptDir = envParam.scriptDir
    local scriptName = envParam.scriptName
    local tempDir = envParam.tempDir

    local noteEx = {}
    local noteExList = {}
    local noteCount
    local retCode
    local idx

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

    idx = 1
    for i = beginPosTick, endPosTick do
        local r, DYNVal = VSGetControlAt("DYN", i)
        local r, BREVal = VSGetControlAt("BRE", i)
        local r, BRIVal = VSGetControlAt("BRI", i)
        local r, CLEVal = VSGetControlAt("CLE", i)
        local r, GENVal = VSGetControlAt("GEN", i)
        local r, PITVal = VSGetControlAt("PIT", i)
        local r, PBSVal = VSGetControlAt("PBS", i)
        local r, PORVal = VSGetControlAt("POR", i)
        local r, GWLVal = VSGetControlAt("GWL", i)
        local r, XSYVal = VSGetControlAt("XSY", i)
        DYNArray[idx] = DYNVal
        BREArray[idx] = BREVal
        BRIArray[idx] = BRIVal
        CLEArray[idx] = CLEVal
        GENArray[idx] = GENVal
        PITArray[idx] = PITVal
        PBSArray[idx] = PBSVal
        PORArray[idx] = PORVal
        GWLArray[idx] = GWLVal
        XSYArray[idx] = XSYVal
        idx = idx + 1
    end

    VSSeekToBeginNote()
    idx = 1
    retCode, noteEx = VSGetNextNoteEx()
    while (retCode == 1) do
        noteExList[idx] = noteEx
        retCode, noteEx = VSGetNextNoteEx()
        idx = idx + 1
    end

    noteCount = table.getn(noteExList)

    local noteIdx = 1
    if (noteCount ~= 0) then
        for idx = 1, noteCount do
            local note = noteExList[idx]
            if (note.posTick >= beginPosTick and note.posTick + note.durTick <= endPosTick) then
                local newNote = copyNoteEx(note)
                newNote.posTick = note.posTick - beginPosTick
                noteExArray[noteIdx] = newNote
                noteIdx = noteIdx + 1
            end
        end
    end

    local f = io.open("ParamCopy.dat", "w")
    if f ~= nil then
        writeArray(DYNArray, f)
        writeArray(BREArray, f)
        writeArray(BRIArray, f)
        writeArray(CLEArray, f)
        writeArray(GENArray, f)
        writeArray(PITArray, f)
        writeArray(PBSArray, f)
        writeArray(PORArray, f)
        writeArray(GWLArray, f)
        writeArray(XSYArray, f)
    end
    if f ~= nil then
        f:close()
    end

    local noteArrayLen = table.getn(noteExArray)
    local fn = io.open("NoteCopy.dat", "w")
    if fn ~= nil then
        for i = 1, noteArrayLen do
            writeNote(noteExArray[i], fn)
        end
    end
    if fn ~= nil then
        fn:close()
    end

    return endStatus
end
