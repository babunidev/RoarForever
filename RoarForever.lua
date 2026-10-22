local _, RF = ...
local frame = CreateFrame("Frame")

local EMOTE_COOLDOWN = 0.07
local lastPlayTimeBySenderAndEmote = {}

-- Blizzard FileDataIDs for player-character voice emotes.
-- Classic names come from the wowdev community listfile. Joke variants, and
-- every Skyborne ID, are the files in that emote's sound kit on Forever
-- build 1.60.1.70009. Skyborne files are not named in the listfile yet.
-- /retreat uses the flee voice. /yes is the nod emote; its files are the Yes lines.
-- Each value is an array so additional voice variants can be added without
-- changing the playback code.
local voiceSounds = {
    roar = {
        DwarfFemale = { 539992 },
        DwarfMale = { 540087 },
        GnomeFemale = { 540457 },
        GnomeMale = { 540497 },
        HumanFemale = { 540615 },
        HumanMale = { 540697 },
        NightElfFemale = { 541072 },
        NightElfMale = { 541132 },
        OrcFemale = { 541347 },
        OrcMale = { 541398 },
        TaurenFemale = { 543016 },
        TaurenMale = { 543062 },
        TrollFemale = { 543226 },
        TrollMale = { 543311 },
        UndeadFemale = { 542680 },
        UndeadMale = { 542740 },
        -- Skyborne roar kit from EmotesTextSound on Forever build 1.60.1.70009.
        -- High Order and Windshaper share this voice set.
        SkyborneFemale = { 8036579, 8036581, 8036583 },
        SkyborneMale = { 8062196, 8062198, 8062200 },
    },
    cheer = {
        DwarfFemale = { 540014 },
        DwarfMale = { 540024 },
        GnomeFemale = { 540434 },
        GnomeMale = { 540493 },
        HumanFemale = { 540628 },
        HumanMale = { 540694 },
        NightElfFemale = { 541043 },
        NightElfMale = { 541138 },
        OrcFemale = { 541328 },
        OrcMale = { 541435 },
        TaurenFemale = { 542976 },
        TaurenMale = { 543078 },
        TrollFemale = { 543253 },
        TrollMale = { 543331 },
        UndeadFemale = { 542697 },
        UndeadMale = { 542783 },
        SkyborneFemale = { 7744884, 7961127 },
        SkyborneMale = { 7744477, 7744478 },
    },
    laugh = {
        DwarfFemale = { 539798 },
        DwarfMale = { 539883 },
        GnomeFemale = { 540268 },
        GnomeMale = { 540267 },
        HumanFemale = { 540540 },
        HumanMale = { 540739 },
        NightElfFemale = { 540877 },
        NightElfMale = { 540945 },
        OrcFemale = { 541153 },
        OrcMale = { 541230 },
        TaurenFemale = { 542806 },
        TaurenMale = { 542898 },
        TrollFemale = { 543091 },
        TrollMale = { 543094 },
        UndeadFemale = { 542518 },
        UndeadMale = { 542595 },
        SkyborneFemale = { 8036475, 8036477, 8036479, 8036481 },
        SkyborneMale = { 8062277, 8062279, 8062282 },
    },
    joke = {
        -- /silly and /joke use the race/sex Pissed sound kit.
        -- CHAT_MSG_TEXT_EMOTE does not say which line the sender's client picked,
        -- so playback chooses one at random from that race and sex's verified kit.
        DwarfFemale = { 539989, 540017, 539993, 539999, 539970, 539968 },
        DwarfMale = { 540055, 540067, 540032, 540030, 540050, 540049, 540084 },
        GnomeFemale = { 540424, 540423, 540426, 540443 },
        GnomeMale = { 540517, 540468, 540467, 540464, 540495, 540492 },
        HumanFemale = { 540641, 540633, 540617, 540634, 540622, 540643, 540639 },
        HumanMale = { 540663, 540716, 540699, 540679, 540680, 540710 },
        NightElfFemale = { 541035, 541038, 541067, 541028, 541077 },
        NightElfMale = { 541122, 541125, 541084, 541133, 541134, 541082, 541098, 541120 },
        OrcFemale = { 541349, 541357, 541371, 541351, 541327, 541356 },
        OrcMale = { 541433, 541432, 541403, 541397, 541422, 541409 },
        TaurenFemale = { 542968, 542994, 542996, 542989 },
        TaurenMale = { 543055, 543082, 543058, 543065, 543026 },
        TrollFemale = { 543241, 543247, 543228, 543245, 543257 },
        TrollMale = { 543315, 543285, 543323, 543337, 543329, 543327 },
        UndeadFemale = { 542727, 542705, 542700, 542693, 542713, 542690, 542732, 542688 },
        UndeadMale = { 542753, 542788, 542773, 542766, 542757 },
        SkyborneFemale = { 7744915, 7744916, 7744917 },
        SkyborneMale = { 7744509, 7930423, 7930426 },
    },
    moo = {
        -- /moo has dedicated player voice files only for Tauren.
        TaurenFemale = { 542820 },
        TaurenMale = { 542894 },
    },
    flee = {
        DwarfFemale = { 540000, 540009 },
        DwarfMale = { 540037, 540079, 540081 },
        GnomeFemale = { 540453, 540441, 540458 },
        GnomeMale = { 540479, 540480, 540465 },
        HumanFemale = { 540616, 540646 },
        HumanMale = { 540692, 540678 },
        NightElfFemale = { 541048, 541063 },
        NightElfMale = { 541106, 541114 },
        OrcFemale = { 541366, 541360 },
        OrcMale = { 541392, 541419 },
        TaurenFemale = { 543011, 542984 },
        TaurenMale = { 543041, 543056 },
        TrollFemale = { 543246, 543260 },
        TrollMale = { 543335, 543320 },
        UndeadFemale = { 542689, 542707 },
        UndeadMale = { 542767, 542785 },
        SkyborneFemale = { 7744885, 7744886, 7744887 },
        SkyborneMale = { 7744481, 7744480, 7744479 },
    },
    welcome = {
        DwarfFemale = { 540016, 539987, 539967 },
        DwarfMale = { 540026, 540038, 540078 },
        GnomeFemale = { 540417, 540448, 540411 },
        GnomeMale = { 540462, 540488, 540499 },
        HumanFemale = { 540651, 540656, 540620 },
        HumanMale = { 540677, 540666, 540669 },
        NightElfFemale = { 541050, 541076, 541064 },
        NightElfMale = { 541102, 541095, 541108 },
        OrcFemale = { 541353, 541359, 541324 },
        OrcMale = { 541405, 541436, 541385 },
        TaurenFemale = { 543018, 542999, 543017 },
        TaurenMale = { 543081, 543079, 543066 },
        TrollFemale = { 543238, 543275, 543276 },
        TrollMale = { 543333, 543294, 543308 },
        UndeadFemale = { 542701, 542709, 542696 },
        UndeadMale = { 542770, 542758 },
        SkyborneFemale = { 7744924, 7744926 },
        SkyborneMale = { 7930417, 7930420 },
    },
    yes = {
        DwarfFemale = { 540002, 540011, 539982 },
        DwarfMale = { 540047, 540062, 540022, 540044 },
        GnomeFemale = { 540418, 540422, 540446 },
        GnomeMale = { 540471, 540477, 540483 },
        HumanFemale = { 540624, 540605, 540632 },
        HumanMale = { 540702, 540709, 540667 },
        NightElfFemale = { 541071, 541058, 541046 },
        NightElfMale = { 541099, 541130, 541137 },
        OrcFemale = { 541331, 541365, 541319, 541338 },
        OrcMale = { 541424, 541399, 541379, 541377 },
        TaurenFemale = { 543022, 542983, 543021 },
        TaurenMale = { 543046, 543030, 543036 },
        TrollFemale = { 543267, 543268, 543249 },
        TrollMale = { 543313, 543306, 543328, 543312 },
        UndeadFemale = { 542729, 542703, 542718 },
        UndeadMale = { 542750, 542741, 542789 },
        SkyborneFemale = { 7744909, 7744910, 7744911 },
        SkyborneMale = { 7744503, 7744504, 7744505 },
    },
    no = {
        DwarfFemale = { 540003, 540012, 539996 },
        DwarfMale = { 540054, 540056, 540040, 540074 },
        GnomeFemale = { 540440, 540429, 540433 },
        GnomeMale = { 540496, 540514, 540506 },
        HumanFemale = { 540614, 540658, 540607 },
        HumanMale = { 540673, 540683, 540700, 540698 },
        NightElfFemale = { 541068, 541039, 541074 },
        NightElfMale = { 541128, 541094, 541083 },
        OrcFemale = { 541340, 541326, 541343 },
        OrcMale = { 541428, 541390, 541416 },
        TaurenFemale = { 542980, 543005, 542979 },
        TaurenMale = { 543042, 543080, 543059 },
        TrollFemale = { 543252, 543240, 543239 },
        TrollMale = { 543324, 543296, 543286, 543295 },
        UndeadFemale = { 542681, 542675, 542723 },
        UndeadMale = { 542749, 542743, 542780 },
        SkyborneFemale = { 7744906, 7744907, 7744908 },
        SkyborneMale = { 7744500, 7744501, 7744502 },
    },
    healme = {
        DwarfFemale = { 540006, 540018, 539974 },
        DwarfMale = { 540069, 540089, 540080 },
        GnomeFemale = { 540439, 540431 },
        GnomeMale = { 540478, 540504 },
        HumanFemale = { 540642, 540647 },
        HumanMale = { 540668, 540706 },
        NightElfFemale = { 541078, 541034 },
        NightElfMale = { 541131, 541111 },
        OrcFemale = { 541345, 541336 },
        OrcMale = { 541427, 541434 },
        TaurenFemale = { 542992, 543020 },
        TaurenMale = { 543075, 543028 },
        TrollFemale = { 543231, 543262, 543265 },
        TrollMale = { 543314, 543338, 543304 },
        UndeadFemale = { 542692, 542728 },
        UndeadMale = { 542765, 542748 },
        SkyborneFemale = { 7744897, 7744898 },
        SkyborneMale = { 7744492, 7744491 },
    },
    rasp = {
        DwarfFemale = { 539995 },
        DwarfMale = { 540083 },
        -- The gnome female kit uses the same raspberry file as dwarf male.
        GnomeFemale = { 540083 },
        GnomeMale = { 540494 },
        HumanFemale = { 540626 },
        HumanMale = { 540695 },
        NightElfFemale = { 541024 },
        NightElfMale = { 541124 },
        OrcFemale = { 541321 },
        OrcMale = { 541414 },
        TaurenFemale = { 542977 },
        TaurenMale = { 543044 },
        TrollFemale = { 543251 },
        TrollMale = { 543317 },
        UndeadFemale = { 542698 },
        UndeadMale = { 542746 },
        SkyborneFemale = { 7744914 },
        SkyborneMale = { 7744508 },
    },
    flirt = {
        DwarfFemale = { 539964, 540010, 539998, 539969, 540001 },
        DwarfMale = { 540052, 540029, 540051, 540045, 540025, 540086 },
        GnomeFemale = { 540444, 540427, 540454, 540409, 540406 },
        GnomeMale = { 540484, 540470, 540508, 540503 },
        HumanFemale = { 540612, 540625, 540648 },
        HumanMale = { 540708, 540715, 540691, 540689, 540684, 540690 },
        NightElfFemale = { 541056, 541044, 541059, 541060 },
        NightElfMale = { 541091, 541129, 541118, 541105, 541110 },
        OrcFemale = { 541363, 541368, 541346, 541350, 541344, 541341 },
        OrcMale = { 541426, 541413, 541394, 541420, 541421, 541431 },
        TaurenFemale = { 543010, 543004, 543019, 542975, 543007 },
        TaurenMale = { 543031, 543077, 543052, 543064, 543033, 543037 },
        TrollFemale = { 543272, 543278, 543269, 543232, 543274 },
        TrollMale = { 543340, 543334, 543301, 543283 },
        UndeadFemale = { 542682, 542720, 542711, 542734, 542704, 542706 },
        UndeadMale = { 542759, 542754, 542742, 542760, 542786, 542777 },
        SkyborneFemale = { 7744888, 7744889, 7744890 },
        SkyborneMale = { 7744483, 7744484, 7744482 },
    },
    oom = {
        DwarfFemale = { 539983, 539980 },
        DwarfMale = { 540027, 540066 },
        GnomeFemale = { 540442, 540455 },
        GnomeMale = { 540498, 540518 },
        HumanFemale = { 540645, 540644 },
        HumanMale = { 540675, 540704 },
        NightElfFemale = { 541036, 541040 },
        NightElfMale = { 541117, 541104 },
        OrcFemale = { 541372, 541373 },
        OrcMale = { 541429, 541386 },
        TaurenFemale = { 543006, 543001 },
        TaurenMale = { 543049, 543053 },
        TrollFemale = { 543242, 543234 },
        TrollMale = { 543302, 543287 },
        UndeadFemale = { 542687, 542686 },
        UndeadMale = { 542772, 542778 },
        SkyborneFemale = { 7744968, 7744969, 7744970 },
        SkyborneMale = { 7744556, 7744557, 7744558 },
    },
    sigh = {
        DwarfFemale = { 539794 },
        DwarfMale = { 539873 },
        GnomeFemale = { 540266 },
        GnomeMale = { 540277 },
        HumanFemale = { 540524 },
        HumanMale = { 540729 },
        NightElfFemale = { 540865 },
        NightElfMale = { 540952 },
        OrcFemale = { 541151 },
        OrcMale = { 541236 },
        TaurenFemale = { 542813 },
        TaurenMale = { 542900 },
        TrollFemale = { 543089 },
        TrollMale = { 543088 },
        UndeadFemale = { 542524 },
        UndeadMale = { 542610 },
        SkyborneFemale = { 8036503, 8036505, 8036507, 8036509 },
        SkyborneMale = { 8062308, 8062305 },
    },
    charge = {
        DwarfFemale = { 540007, 539986 },
        DwarfMale = { 540085, 540088 },
        GnomeFemale = { 540425, 540452 },
        GnomeMale = { 540491, 540509, 540515 },
        HumanFemale = { 540623, 540618 },
        HumanMale = { 540696, 540717 },
        NightElfFemale = { 541023, 541026, 541025 },
        NightElfMale = { 541081, 541092 },
        OrcFemale = { 541367, 541342, 541354 },
        OrcMale = { 541389, 541391, 541400 },
        TaurenFemale = { 543008, 543002 },
        TaurenMale = { 543040, 543071, 543057 },
        TrollFemale = { 543254, 543266 },
        TrollMale = { 543284, 543293 },
        UndeadFemale = { 542712, 542725 },
        UndeadMale = { 542762, 542738 },
        SkyborneFemale = { 7744882, 7744883 },
        SkyborneMale = { 7744476, 7744475 },
    },
    cry = {
        DwarfFemale = { 539792 },
        DwarfMale = { 539875 },
        GnomeFemale = { 540273 },
        GnomeMale = { 540264 },
        HumanFemale = { 540533 },
        HumanMale = { 540736 },
        NightElfFemale = { 540873 },
        NightElfMale = { 540957 },
        OrcFemale = { 541149 },
        OrcMale = { 541240 },
        TaurenFemale = { 542815 },
        TaurenMale = { 542887 },
        TrollFemale = { 543084 },
        TrollMale = { 543090 },
        UndeadFemale = { 542519 },
        UndeadMale = { 542601 },
        SkyborneFemale = { 8036417, 8036419 },
        SkyborneMale = { 8062218, 8062220, 8062222 },
    },
    congrats = {
        DwarfFemale = { 539981, 539994, 539965, 540008 },
        DwarfMale = { 540065, 540058, 540039, 540042, 540063 },
        GnomeFemale = { 540432, 540449, 540420, 540415 },
        GnomeMale = { 540476, 540501, 540512 },
        HumanFemale = { 540654, 540640, 540655 },
        HumanMale = { 540703, 540676, 540712 },
        NightElfFemale = { 541045, 541031, 541033 },
        NightElfMale = { 541085, 541103, 541136 },
        OrcFemale = { 541317, 541358, 541332 },
        OrcMale = { 541396, 541401, 541423 },
        TaurenFemale = { 542997, 542981, 542995 },
        TaurenMale = { 543038, 543070, 543027 },
        TrollFemale = { 543273, 543233, 543243 },
        TrollMale = { 543307, 543291, 543336 },
        UndeadFemale = { 542684, 542694, 542724, 542726 },
        UndeadMale = { 542747, 542775, 542735 },
        SkyborneFemale = { 7997839, 7997842 },
        SkyborneMale = { 7997833, 7997836 },
    },
    followme = {
        DwarfFemale = { 540004, 539997 },
        DwarfMale = { 540057, 540053, 540043 },
        GnomeFemale = { 540419 },
        GnomeMale = { 540474, 540486 },
        HumanFemale = { 540631, 540653 },
        HumanMale = { 540711, 540705 },
        NightElfFemale = { 541066, 541057 },
        NightElfMale = { 541086, 541107 },
        OrcFemale = { 541337, 541362 },
        OrcMale = { 541410, 541387 },
        TaurenFemale = { 542972, 542986 },
        TaurenMale = { 543048, 543050 },
        TrollFemale = { 543258, 543264 },
        TrollMale = { 543288, 543339 },
        UndeadFemale = { 542695, 542714 },
        UndeadMale = { 542744, 542771 },
        SkyborneFemale = { 7744891, 7744892, 7744893 },
        SkyborneMale = { 7744487, 7744486, 7744485 },
    },
    train = {
        DwarfFemale = { 539802 },
        DwarfMale = { 539881 },
        GnomeFemale = { 540271 },
        GnomeMale = { 540275 },
        HumanFemale = { 540535 },
        HumanMale = { 540734 },
        NightElfFemale = { 540870 },
        NightElfMale = { 540947 },
        OrcFemale = { 541157 },
        OrcMale = { 541239 },
        TaurenFemale = { 542818 },
        TaurenMale = { 542896 },
        TrollFemale = { 543085 },
        TrollMale = { 543093 },
        UndeadFemale = { 542526 },
        UndeadMale = { 542600 },
        SkyborneFemale = { 7744921 },
        SkyborneMale = { 7744513 },
    },
    -- Faction-cry voices exist in the Forever CASC but are not wired through
    -- EmotesText / EmotesTextSound on build 1.60. FileDataIDs verified via
    -- wago.tools CASC for 1.60.1.70338. No Skyborne faction-cry lines found yet.
    forthehorde = {
        OrcFemale = { 1387393 },
        OrcMale = { 1387394 },
        TaurenFemale = { 1387399 },
        TaurenMale = { 1502107 },
        TrollFemale = { 1502159 },
        TrollMale = { 1512807 },
        UndeadFemale = { 1387400 },
        UndeadMale = { 1387401 },
    },
    forthealliance = {
        HumanFemale = { 1502108 },
        HumanMale = { 1502109 },
        DwarfFemale = { 1512964 },
        DwarfMale = { 1512853 },
        GnomeFemale = { 1387389 },
        GnomeMale = { 1512970 },
        NightElfFemale = { 1387392 },
        -- Listed under pcdhnightelfmale in the community listfile, but this is
        -- the non-DH Night Elf male "For the Alliance!" line and is present in Forever.
        NightElfMale = { 1512798 },
    },
}

voiceSounds.retreat = voiceSounds.flee
voiceSounds.congratulate = voiceSounds.congrats

-- Every race uses the same four whistle effects.
local whistleSounds = { 2445845, 2445847, 2445848, 2445849 }
voiceSounds.whistle = {}
for _, race in ipairs({ "Dwarf", "Gnome", "Human", "NightElf", "Orc", "Tauren", "Troll", "Undead", "Skyborne" }) do
    voiceSounds.whistle[race .. "Female"] = whistleSounds
    voiceSounds.whistle[race .. "Male"] = whistleSounds
end

local function NormalizeName(name)
    if not name then
        return nil
    end

    local dashPos = string.find(name, "-", 1, true)
    if dashPos then
        return string.sub(name, 1, dashPos - 1)
    end

    return name
end

local function NormalizeRace(raceFile)
    if raceFile == "Scourge" then
        return "Undead"
    end

    return raceFile
end

local function BuildVoiceKey(raceFile, sex)
    raceFile = NormalizeRace(raceFile)

    if not raceFile then
        return nil
    end

    if sex == 2 then
        return raceFile .. "Male"
    elseif sex == 3 then
        return raceFile .. "Female"
    end

    return nil
end

local function GetVoiceKeyForUnit(unit)
    if not UnitExists(unit) then
        return nil
    end

    local _, raceFile = UnitRace(unit)
    local sex = UnitSex(unit)
    return BuildVoiceKey(raceFile, sex)
end

local function GetVoiceKeyForGUID(guid)
    if type(guid) ~= "string" or guid == "" or not GetPlayerInfoByGUID then
        return nil
    end

    local ok, _, _, _, raceFile, sex = pcall(GetPlayerInfoByGUID, guid)
    if not ok then
        return nil
    end

    return BuildVoiceKey(raceFile, sex)
end

-- Verified SoundKitIDs for distance-aware C_Sound.PlaySound. Empty until
-- DB2/CASC mappings are confirmed; FileDataID playback remains the fallback.
local voiceSoundKits = {
    roar = {},
    train = {},
    forthehorde = {},
    forthealliance = {},
}

local COMM_PREFIX = "RoarForever"
local COMM_PROTOCOL = "1"
local COMM_EMOTES = {
    roar = true,
    train = true,
    forthehorde = true,
    forthealliance = true,
}
local FALLBACK_DELAY = 0.10
local COMM_DEDUPE_TTL = 2
local RECENT_COMM_TTL = 0.35
local MAX_AUDIBLE_DISTANCE = 50

-- Per-speaker exclusive playback: one active restored voice per player so that
-- player's spam/restart cuts their own previous line, while other players overlap.
local lastSoundHandleBySpeaker = {}
local previewSoundHandle

local function SpeakerKey(sender, guid)
    return guid or NormalizeName(sender) or "unknown"
end

local function LocalSpeakerKey()
    local guid = UnitGUID and UnitGUID("player") or nil
    local name = UnitName and UnitName("player") or "player"
    return SpeakerKey(name, guid)
end

local function StopSpeakerSound(speakerKey)
    if not speakerKey then
        return
    end
    local handle = lastSoundHandleBySpeaker[speakerKey]
    if handle and StopSound then
        StopSound(handle)
    end
    lastSoundHandleBySpeaker[speakerKey] = nil
end

local function PlaySoundFileForSpeaker(speakerKey, fileDataID)
    StopSpeakerSound(speakerKey)
    local willPlay, handle = PlaySoundFile(fileDataID, "Master")
    if willPlay then
        lastSoundHandleBySpeaker[speakerKey] = handle
    end
    return willPlay and true or false, handle
end

local function PlaySoundKitForSpeaker(speakerKey, soundKitID, volume)
    if not (C_Sound and C_Sound.PlaySound) then
        return false
    end
    StopSpeakerSound(speakerKey)
    local willPlay, handle = C_Sound.PlaySound(soundKitID, "SFX", false, false, nil, volume)
    if willPlay then
        lastSoundHandleBySpeaker[speakerKey] = handle
    end
    return willPlay and true or false, handle
end

local function VolumeForDistance(distance)
    if not distance then
        return 1.0
    end
    if distance <= 5 then
        return 1.0
    end
    if distance >= MAX_AUDIBLE_DISTANCE then
        return 0
    end
    local t = (distance - 5) / (MAX_AUDIBLE_DISTANCE - 5)
    return (1 - t) ^ 1.5
end

local function PlayEmoteByKey(emoteName, voiceKey, speakerKey)
    local emoteMap = voiceSounds[emoteName]
    local sounds = emoteMap and emoteMap[voiceKey]
    if not sounds or #sounds == 0 then
        return false
    end

    local fileDataID = sounds[math.random(#sounds)]
    local willPlay = PlaySoundFileForSpeaker(speakerKey or "unknown", fileDataID)
    return willPlay, fileDataID
end

-- positionStatus: "ok" | "mismatch" | "unavailable"
local function PlayRestoredVoice(emoteName, voiceKey, distance, positionStatus, speakerKey)
    if positionStatus == "mismatch" then
        return false
    end

    speakerKey = speakerKey or "unknown"
    local kitMap = voiceSoundKits[emoteName]
    local kit = kitMap and kitMap[voiceKey]

    if positionStatus == "ok" then
        if not distance or distance >= MAX_AUDIBLE_DISTANCE then
            return false
        end
        if kit then
            local volume = VolumeForDistance(distance)
            if volume <= 0 then
                return false
            end
            return PlaySoundKitForSpeaker(speakerKey, kit, volume)
        end
        return PlayEmoteByKey(emoteName, voiceKey, speakerKey)
    end

    -- Position unavailable: full-volume fallback.
    if kit then
        return PlaySoundKitForSpeaker(speakerKey, kit, 1.0)
    end
    return PlayEmoteByKey(emoteName, voiceKey, speakerKey)
end

-- Normalize chat formatting without lowercasing UTF-8 names or translated text.
local function NormalizeText(text)
    return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("|H.-|h(.-)|h", "%1"):gsub(" ", " "):gsub(" ", " ")
        :gsub("’", "'"):gsub("%s+", " "):match("^%s*(.-)%s*$"))
end

local function TemplatePattern(template)
    -- Russian declined names and French de/d' prefixes are rendered by WoW.
    template = template:gsub("|3%-%d%((.-)%)", "%1"):gsub("|2%s*", "")
    template = NormalizeText(template)
    template = template:gsub("%%[12]%$s", "%%s")
    local parts, pos = {"^"}, 1
    while true do
        local first, last = template:find("%s", pos, true)
        local literal = template:sub(pos, first and first - 1 or #template)
        parts[#parts + 1] = literal:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
        if not first then break end
        parts[#parts + 1] = ".+"
        pos = last + 1
    end
    return table.concat(parts) .. "$"
end

local patterns = {}
for _, entry in ipairs(RF.locale.templates) do
    patterns[#patterns + 1] = {entry[1], TemplatePattern(entry[2])}
end

local TRAIN_LINE = "blows a train whistle. Choo choo!"

-- Faction cries share slash/announce/detection logic. Sound tables stay separate.
local factionEmotes = {
    forthehorde = {
        faction = "Horde",
        token = "FORTHEHORDE",
        altTokens = { HORDE = true },
        line = "cheers for the Horde! For the Horde!",
        slash = "/forthehorde",
    },
    forthealliance = {
        faction = "Alliance",
        token = "FORTHEALLIANCE",
        altTokens = { ALLIANCE = true },
        line = "cheers for the Alliance! For the Alliance!",
        slash = "/forthealliance",
    },
}

local factionEmoteByToken = {}
for emoteName, info in pairs(factionEmotes) do
    factionEmoteByToken[info.token] = emoteName
    for alt in pairs(info.altTokens) do
        factionEmoteByToken[alt] = emoteName
    end
end

local function MatchesCustomEmoteLine(text, sender, line)
    return text == line
        or text == (sender or "") .. " " .. line
        or text == (NormalizeName(sender) or "") .. " " .. line
end

local function DetectEmote(text, event, sender)
    if type(text) ~= "string" then return nil end
    text = NormalizeText(text)
    if event == "CHAT_MSG_EMOTE" then
        -- Custom emotes are arbitrary prose. Accept only exact addon messages.
        if MatchesCustomEmoteLine(text, sender, TRAIN_LINE) then
            return "train"
        end
        for emoteName, info in pairs(factionEmotes) do
            if MatchesCustomEmoteLine(text, sender, info.line) then
                return emoteName
            end
        end
        return nil
    end
    for _, entry in ipairs(patterns) do
        if text:match(entry[2]) then
            -- Intentionally retain the existing ding exclusion, including names.
            if entry[1] == "congrats" and text:lower():find("ding", 1, true) then
                return nil
            end
            return entry[1]
        end
    end
end

local function FindUnitBySender(sender, guid)
    local wanted = sender
    if not wanted then
        return nil
    end

    local function Matches(unit)
        if not UnitExists(unit) then return false end
        if guid then return UnitGUID(unit) == guid end
        local name, realm
        if UnitFullName then name, realm = UnitFullName(unit) end
        if not name then name, realm = UnitName(unit) end
        if sender:find("-", 1, true) then
            if not realm or realm == "" then
                realm = GetNormalizedRealmName and GetNormalizedRealmName()
            end
            return realm and name .. "-" .. realm == wanted
        end
        return name == wanted
    end
    local units = { "player", "target", "mouseover", "focus" }

    for _, unit in ipairs(units) do
        if Matches(unit) then
            return unit
        end
    end

    if IsInRaid and IsInRaid() then
        for i = 1, 40 do
            local unit = "raid" .. i
            if Matches(unit) then
                return unit
            end
        end
    elseif IsInGroup and IsInGroup() then
        for i = 1, 4 do
            local unit = "party" .. i
            if Matches(unit) then
                return unit
            end
        end
    end

    return nil
end

local function FindGroupedUnitByGUID(guid)
    if type(guid) ~= "string" or guid == "" then
        return nil
    end

    if not IsInGroup or not IsInGroup() then
        return nil
    end

    if IsInRaid and IsInRaid() then
        for i = 1, 40 do
            local unit = "raid" .. i
            if UnitExists(unit) and UnitGUID(unit) == guid then
                return unit
            end
        end
    else
        for i = 1, 4 do
            local unit = "party" .. i
            if UnitExists(unit) and UnitGUID(unit) == guid then
                return unit
            end
        end
    end

    return nil
end

local function SettingsDB()
    if type(RoarForeverDB) ~= "table" then RoarForeverDB = {} end
    if type(RoarForeverDB.emotes) ~= "table" then RoarForeverDB.emotes = {} end
    return RoarForeverDB
end

local function AddonEnabled()
    return SettingsDB().enabled ~= false
end

local function SetAddonEnabled(enabled)
    SettingsDB().enabled = enabled and true or false
end

local function EmoteEnabled(emote)
    return SettingsDB().emotes[emote] ~= false
end

RF.SettingsDB = SettingsDB
RF.AddonEnabled = AddonEnabled
RF.SetAddonEnabled = SetAddonEnabled
RF.EmoteEnabled = EmoteEnabled

local previewPools = {}
function RF.Preview(emote)
    local pool = previewPools[emote]
    if not pool then
        pool = {}
        local seen = {}
        for _, sounds in pairs(voiceSounds[emote] or {}) do
            for _, id in ipairs(sounds) do
                if not seen[id] then pool[#pool + 1] = id; seen[id] = true end
            end
        end
        previewPools[emote] = pool
    end
    if #pool == 0 then return false end
    if previewSoundHandle and StopSound then
        StopSound(previewSoundHandle)
        previewSoundHandle = nil
    end
    local ok, handle = PlaySoundFile(pool[math.random(#pool)], "Master")
    if ok then
        previewSoundHandle = handle
    end
    return ok and true or false, handle
end

local function IsGroupedSender(sender, guid)
    if not IsInGroup or not IsInGroup() then
        return false
    end

    if FindGroupedUnitByGUID(guid) then
        return true
    end

    local unit = FindUnitBySender(sender, guid)
    if not unit or unit == "player" then
        return false
    end

    if IsInRaid and IsInRaid() then
        return UnitInRaid(unit) ~= nil
    end

    return UnitInParty(unit) and true or false
end

local function IsLocalPlayer(sender, guid)
    if guid then return guid == UnitGUID("player") end
    return FindUnitBySender(sender) == "player"
end

local function IsSkyborneVoiceKey(voiceKey)
    return type(voiceKey) == "string" and string.sub(voiceKey, 1, 8) == "Skyborne"
end

local function CanPlayForSender(sender, guid, emoteName)
    local senderKey = guid or NormalizeName(sender) or "unknown"
    local key = emoteName .. ":" .. senderKey
    local now = GetTime()
    local last = lastPlayTimeBySenderAndEmote[key]

    if last and (now - last) < EMOTE_COOLDOWN then
        return false
    end

    lastPlayTimeBySenderAndEmote[key] = now
    return true
end

local function GetSenderVoiceKey(sender, guid)
    local voiceKey = GetVoiceKeyForGUID(guid)
    if voiceKey then
        return voiceKey
    end

    local unit = FindGroupedUnitByGUID(guid) or FindUnitBySender(sender, guid)
    if unit then
        return GetVoiceKeyForUnit(unit)
    end

    return nil
end

local function SenderKey(sender, guid)
    return SpeakerKey(sender, guid)
end

local function RecentCommKey(sender, guid, emoteName)
    return SenderKey(sender, guid) .. "|" .. emoteName
end

-- Text-emote fallback timers waiting for a matching COMM packet.
local pendingFallbackByKey = {}
-- COMM already handled this sender+emote recently (COMM arrived before text).
local recentCommBySenderAndEmote = {}
-- Deduplicate the same eventID across SAY/PARTY/RAID copies.
local recentCommEventIDs = {}
local eventCounter = 0
local debugCommEnabled = false
local prefixRegistered = false

local function NextEventID()
    eventCounter = (eventCounter + 1) % 10000
    return tostring(eventCounter)
end

local function RegisterCommPrefix()
    if prefixRegistered then
        return
    end
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
        C_ChatInfo.RegisterAddonMessagePrefix(COMM_PREFIX)
        prefixRegistered = true
    end
end

local function ResolveDistance(senderX, senderY, senderInstance)
    if not UnitPosition then
        return nil, "unavailable"
    end
    local px, py, _, playerInstance = UnitPosition("player")
    if senderX == nil or senderY == nil or senderInstance == nil
        or px == nil or py == nil or playerInstance == nil then
        return nil, "unavailable"
    end
    if senderInstance ~= playerInstance then
        return nil, "mismatch"
    end
    local dx = senderX - px
    local dy = senderY - py
    return math.sqrt(dx * dx + dy * dy), "ok"
end

local function ShouldSuppressCommPlayback(emoteName, sender, guid, voiceKey)
    if IsLocalPlayer(sender, guid) then
        return true
    end
    -- Forever already plays group-member /train natively (0.5.1 fix).
    if emoteName == "train" and IsGroupedSender(sender, guid) then
        return true
    end
    local isSelfOrGroup = IsLocalPlayer(sender, guid) or IsGroupedSender(sender, guid)
    if emoteName == "roar" and isSelfOrGroup and IsSkyborneVoiceKey(voiceKey) then
        return true
    end
    return false
end

local function CancelPendingFallback(key)
    local pending = pendingFallbackByKey[key]
    if pending then
        pending.cancelled = true
        pendingFallbackByKey[key] = nil
    end
end

local function MarkRecentComm(sender, guid, emoteName)
    recentCommBySenderAndEmote[RecentCommKey(sender, guid, emoteName)] = GetTime()
end

local function HasRecentComm(sender, guid, emoteName)
    local key = RecentCommKey(sender, guid, emoteName)
    local seen = recentCommBySenderAndEmote[key]
    if not seen then
        return false
    end
    if (GetTime() - seen) > RECENT_COMM_TTL then
        recentCommBySenderAndEmote[key] = nil
        return false
    end
    return true
end

-- One logical broadcast per DoEmote (slash must not send a second copy).
local function BroadcastEmoteEvent(emoteName)
    if not AddonEnabled() or not EmoteEnabled(emoteName) or not COMM_EMOTES[emoteName] then
        return
    end
    if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then
        return
    end

    local voiceKey = GetVoiceKeyForUnit("player")
    if not voiceKey or not voiceSounds[emoteName] or not voiceSounds[emoteName][voiceKey] then
        return
    end

    RegisterCommPrefix()

    local x, y, _, instanceID
    if UnitPosition then
        x, y, _, instanceID = UnitPosition("player")
    end

    local eventID = NextEventID()
    local function coordField(n)
        if n == nil then
            return ""
        end
        return string.format("%.2f", n)
    end
    local payload = table.concat({
        COMM_PROTOCOL,
        "E",
        emoteName,
        voiceKey,
        eventID,
        coordField(x),
        coordField(y),
        instanceID ~= nil and tostring(instanceID) or "",
    }, "|")

    local function send(channel)
        pcall(C_ChatInfo.SendAddonMessage, COMM_PREFIX, payload, channel)
    end

    send("SAY")
    if IsInGroup and IsInGroup() then
        if IsInRaid and IsInRaid() then
            send("RAID")
        else
            send("PARTY")
        end
        if LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            send("INSTANCE_CHAT")
        end
    end
end

local function SplitPipe(message)
    local parts = {}
    local start = 1
    while true do
        local pos = string.find(message, "|", start, true)
        if not pos then
            parts[#parts + 1] = string.sub(message, start)
            break
        end
        parts[#parts + 1] = string.sub(message, start, pos - 1)
        start = pos + 1
    end
    return parts
end

local function ParseCommMessage(message)
    if type(message) ~= "string" or message == "" then
        return nil
    end
    local parts = SplitPipe(message)
    if #parts < 5 then
        return nil
    end
    local protocol, msgType, emoteName, voiceKey, eventID = parts[1], parts[2], parts[3], parts[4], parts[5]
    if protocol ~= COMM_PROTOCOL or msgType ~= "E" then
        return nil
    end
    if not COMM_EMOTES[emoteName] then
        return nil
    end
    if type(eventID) ~= "string" or eventID == "" or #eventID > 8 then
        return nil
    end
    if not voiceSounds[emoteName] or not voiceSounds[emoteName][voiceKey] then
        return nil
    end

    local xField, yField, instField = parts[6], parts[7], parts[8]
    local x, y, instanceID
    if xField and xField ~= "" and yField and yField ~= "" and instField and instField ~= "" then
        x = tonumber(xField)
        y = tonumber(yField)
        instanceID = tonumber(instField)
        if not x or not y or not instanceID then
            return nil
        end
        -- Reject absurd coordinates.
        if math.abs(x) > 100000 or math.abs(y) > 100000 then
            return nil
        end
    end

    return {
        emoteName = emoteName,
        voiceKey = voiceKey,
        eventID = eventID,
        x = x,
        y = y,
        instanceID = instanceID,
    }
end

local function PlayFromComm(sender, guid, parsed, channel)
    local emoteName = parsed.emoteName
    local voiceKey = parsed.voiceKey
    if not EmoteEnabled(emoteName) then
        return
    end
    if ShouldSuppressCommPlayback(emoteName, sender, guid, voiceKey) then
        return
    end

    local distance, positionStatus = ResolveDistance(parsed.x, parsed.y, parsed.instanceID)
    local volume = 1.0
    if positionStatus == "ok" then
        volume = VolumeForDistance(distance)
    end

    if debugCommEnabled then
        print(string.format(
            "RoarForever COMM\nsender: %s\nemote: %s\nvoice: %s\ndistance: %s\nvolume: %.2f\nchannel: %s\nevent: %s\nposition: %s",
            tostring(NormalizeName(sender) or sender),
            emoteName,
            voiceKey,
            distance and string.format("%.1f yd", distance) or "n/a",
            volume,
            tostring(channel or "?"),
            parsed.eventID,
            positionStatus
        ))
    end

    if not CanPlayForSender(sender, guid, emoteName) then
        return
    end

    PlayRestoredVoice(emoteName, voiceKey, distance, positionStatus, SpeakerKey(sender, guid))
end

local function HandleAddonMessage(prefix, message, channel, sender, _, _, _, _, _, _, _, guid)
    if prefix ~= COMM_PREFIX then
        return
    end
    if not AddonEnabled() then
        return
    end

    local parsed = ParseCommMessage(message)
    if not parsed then
        return
    end

    if type(guid) ~= "string" or guid == "" then
        guid = nil
    end

    local dedupeKey = SenderKey(sender, guid) .. ":" .. parsed.eventID
    local now = GetTime()
    local last = recentCommEventIDs[dedupeKey]
    if last and (now - last) < COMM_DEDUPE_TTL then
        return
    end
    recentCommEventIDs[dedupeKey] = now

    local fallbackKey = RecentCommKey(sender, guid, parsed.emoteName)
    CancelPendingFallback(fallbackKey)
    MarkRecentComm(sender, guid, parsed.emoteName)
    PlayFromComm(sender, guid, parsed, channel)
end

-- Returns true if the text-emote path should restore this sender/emote (legacy rules).
local function ShouldRestoreFromText(emoteName, sender, guid)
    local isSelf = IsLocalPlayer(sender, guid)
    local isSelfOrGroup = isSelf or IsGroupedSender(sender, guid)
    local isFactionCry = factionEmotes[emoteName] ~= nil

    if isFactionCry then
        if isSelf then
            return false
        end
    elseif emoteName ~= "roar" and isSelfOrGroup then
        return false
    end

    if emoteName == "roar" and isSelfOrGroup then
        local voiceKey = GetSenderVoiceKey(sender, guid)
        if IsSkyborneVoiceKey(voiceKey) then
            return false
        end
    end

    return true
end

local function PlayTextFallback(emoteName, sender, guid)
    if not AddonEnabled() or not EmoteEnabled(emoteName) then
        return
    end
    if not ShouldRestoreFromText(emoteName, sender, guid) then
        return
    end
    if not CanPlayForSender(sender, guid, emoteName) then
        return
    end
    local voiceKey = GetSenderVoiceKey(sender, guid)
    if voiceKey then
        PlayEmoteByKey(emoteName, voiceKey, SpeakerKey(sender, guid))
    end
end

local function ScheduleTextFallback(emoteName, sender, guid)
    local key = RecentCommKey(sender, guid, emoteName)
    if HasRecentComm(sender, guid, emoteName) then
        return
    end
    CancelPendingFallback(key)
    local pending = { cancelled = false }
    pendingFallbackByKey[key] = pending
    C_Timer.After(FALLBACK_DELAY, function()
        if pending.cancelled or pendingFallbackByKey[key] ~= pending then
            return
        end
        pendingFallbackByKey[key] = nil
        if HasRecentComm(sender, guid, emoteName) then
            return
        end
        PlayTextFallback(emoteName, sender, guid)
    end)
end

local function HandleChatEmote(event, text, sender, guid)
    if not AddonEnabled() then
        return
    end

    local emoteName = DetectEmote(text, event, sender)
    if not emoteName or not EmoteEnabled(emoteName) then
        return
    end

    -- Self roar: play immediately and let the DoEmote hook broadcast COMM.
    if emoteName == "roar" and IsLocalPlayer(sender, guid) then
        if not ShouldRestoreFromText(emoteName, sender, guid) then
            return
        end
        if not CanPlayForSender(sender, guid, emoteName) then
            return
        end
        local voiceKey = GetSenderVoiceKey(sender, guid)
        if voiceKey then
            PlayEmoteByKey(emoteName, voiceKey, SpeakerKey(sender, guid))
        end
        return
    end

    if COMM_EMOTES[emoteName] then
        if not ShouldRestoreFromText(emoteName, sender, guid) then
            return
        end
        ScheduleTextFallback(emoteName, sender, guid)
        return
    end

    -- Non-COMM emotes keep the immediate restore path.
    PlayTextFallback(emoteName, sender, guid)
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        RegisterCommPrefix()
        return
    end

    if event == "CHAT_MSG_ADDON" then
        HandleAddonMessage(...)
        return
    end

    if event ~= "CHAT_MSG_TEXT_EMOTE" and event ~= "CHAT_MSG_EMOTE" then
        return
    end

    local text, sender = ...
    local guid = select(12, ...)
    if type(guid) ~= "string" or guid == "" then
        guid = nil
    end
    HandleChatEmote(event, text, sender, guid)
end)

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
frame:RegisterEvent("CHAT_MSG_EMOTE")
RegisterCommPrefix()

SLASH_ROARFOREVER1 = "/roarforever"
SLASH_ROARFOREVER2 = "/rf"

SlashCmdList.ROARFOREVER = function(msg)
    local raw = (msg or ""):match("^%s*(.-)%s*$") or ""
    local lower = string.lower(raw)

    if lower == "" or lower == "config" or lower == "ui" then
        RF.OpenOptions()
        return
    end

    if lower == "off" or lower == "disable" then
        SetAddonEnabled(false)
        print("Roar Forever is off. /rf on turns it back on.")
        return
    end

    if lower == "on" or lower == "enable" then
        SetAddonEnabled(true)
        print("Roar Forever is on.")
        return
    end

    if lower == "debugcomm" then
        debugCommEnabled = not debugCommEnabled
        print("Roar Forever: debugcomm " .. (debugCommEnabled and "on" or "off"))
        return
    end

    if lower == "debugpos" then
        if not UnitPosition then
            print("Roar Forever: UnitPosition is unavailable.")
            return
        end
        local x, y, _, instanceID = UnitPosition("player")
        print(string.format(
            "Roar Forever position: x=%s y=%s instanceID=%s",
            x and string.format("%.2f", x) or "n/a",
            y and string.format("%.2f", y) or "n/a",
            instanceID ~= nil and tostring(instanceID) or "n/a"
        ))
        return
    end

    local kitID, kitVol = raw:match("^soundkit%s+(%d+)%s*([%d%.]*)$")
    if kitID then
        local id = tonumber(kitID)
        local volume = tonumber(kitVol)
        if not volume then
            volume = 1.0
        end
        if not (C_Sound and C_Sound.PlaySound) then
            print("Roar Forever: C_Sound.PlaySound is unavailable.")
            return
        end
        local ok, handle = PlaySoundKitForSpeaker(LocalSpeakerKey(), id, volume)
        print(string.format("Roar Forever: SoundKit %d @ %.2f -> %s %s", id, volume, tostring(ok), tostring(handle)))
        return
    end

    local voltestID = raw:match("^voltest%s+(%d+)$")
    if voltestID then
        local id = tonumber(voltestID)
        if not (C_Sound and C_Sound.PlaySound) then
            print("Roar Forever: C_Sound.PlaySound is unavailable.")
            return
        end
        local volumes = { 1.0, 0.7, 0.4, 0.2, 0.1 }
        local delay = 0
        for _, volume in ipairs(volumes) do
            local v = volume
            C_Timer.After(delay, function()
                PlaySoundKitForSpeaker(LocalSpeakerKey(), id, v)
                print(string.format("Roar Forever voltest: SoundKit %d @ %.0f%%", id, v * 100))
            end)
            delay = delay + 0.8
        end
        return
    end

    local testEmote = lower:match("^test%s*(%a*)$")
    if testEmote then
        if testEmote == "" then
            testEmote = "roar"
        end

        if not voiceSounds[testEmote] then
            print("Roar Forever: unknown test emote '" .. testEmote .. "'.")
            print("Roar Forever: test options are roar, cheer, laugh, joke, moo, flee, retreat, welcome, yes, no, healme, rasp, flirt, oom, sigh, charge, cry, congrats, congratulate, followme, train, whistle, forthehorde, forthealliance.")
            return
        end

        local voiceKey = GetVoiceKeyForUnit("player")
        if not voiceKey then
            print("Roar Forever: could not determine your race/sex.")
            return
        end

        local sounds = voiceSounds[testEmote][voiceKey]
        if not sounds or #sounds == 0 then
            print("Roar Forever: no " .. testEmote .. " sound mapped for " .. voiceKey .. ".")
            return
        end

        local ok, fileDataID = PlayEmoteByKey(testEmote, voiceKey, LocalSpeakerKey())
        print("Roar Forever: " .. testEmote .. " / " .. voiceKey .. " -> " .. fileDataID .. (ok and " (played)" or " (playback failed)"))
        return
    end

    if lower == "status" then
        local voiceKey = GetVoiceKeyForUnit("player") or "unknown"
        local mapped = {}

        for emoteName, emoteMap in pairs(voiceSounds) do
            if emoteMap[voiceKey] then
                table.insert(mapped, emoteName)
            end
        end

        table.sort(mapped)
        local state = AddonEnabled() and "on" or "off"
        print("Roar Forever is " .. state .. ". Detected " .. voiceKey .. "; mapped emotes: " .. (#mapped > 0 and table.concat(mapped, ", ") or "none"))
        return
    end

    local rawID = lower:match("^id%s+(%d+)$")
    if rawID then
        local fileDataID = tonumber(rawID)
        local ok, handle = PlaySoundFile(fileDataID, "Master")
        print("Roar Forever: FileDataID " .. fileDataID .. " ->", ok, handle)
        return
    end

    print("Roar Forever: /rf on | /rf off | /rf test [emote] | /rf status | /rf id <FileDataID> | /rf debugcomm | /rf debugpos | /rf soundkit <ID> [volume] | /rf voltest <ID>")
end

-- Forever never announces /train, and does not wire faction cries at all.
-- Take over those slash commands, play what the client can, then send a custom
-- /e line. COMM is the multiplayer signal for other Roar Forever users.
local lastCustomAnnounce = {}

local function SendEmoteLine(text)
    -- Match the pre-0.5.5 train path: C_ChatInfo first. Preferring global
    -- SendChatMessage caused "Interface action failed because of an AddOn".
    if C_ChatInfo and C_ChatInfo.SendChatMessage then
        C_ChatInfo.SendChatMessage(text, "EMOTE")
    elseif SendChatMessage then
        SendChatMessage(text, "EMOTE")
    end
end

local function CustomAnnounceEnabled()
    return SettingsDB().announceTrain ~= false
end

local function AnnounceCustomLine(emoteName, line)
    if not AddonEnabled() or not EmoteEnabled(emoteName) or not CustomAnnounceEnabled() then
        return
    end

    local now = GetTime()
    local last = lastCustomAnnounce[emoteName] or 0
    if now - last < 1 then
        return
    end

    lastCustomAnnounce[emoteName] = now
    SendEmoteLine(line)
end

local function AnnounceCustomLineSoon(emoteName, line)
    -- Send immediately on the slash/keybind call stack. Deferring with
    -- C_Timer.After breaks the hardware-event context and Forever then blocks
    -- the emote chat with "Interface action failed because of an AddOn".
    AnnounceCustomLine(emoteName, line)
end

local function IsTrainToken(emote)
    return type(emote) == "string" and string.upper(emote) == "TRAIN"
end

local function IsRoarToken(emote)
    return type(emote) == "string" and string.upper(emote) == "ROAR"
end

local function IsPlayerFaction(faction)
    return UnitFactionGroup and UnitFactionGroup("player") == faction
end

local function PlayLocalFactionCry(emoteName)
    local voiceKey = GetVoiceKeyForUnit("player")
    if not voiceKey then
        return false
    end
    local sounds = voiceSounds[emoteName] and voiceSounds[emoteName][voiceKey]
    if not sounds or #sounds == 0 then
        return false
    end
    local sender = UnitName and UnitName("player") or "player"
    local guid = UnitGUID and UnitGUID("player") or nil
    if not CanPlayForSender(sender, guid, emoteName) then
        return false
    end
    return PlayEmoteByKey(emoteName, voiceKey, SpeakerKey(sender, guid))
end

local function HandleFactionCry(emoteName, fromDoEmote)
    local info = factionEmotes[emoteName]
    if not info then
        return
    end

    if not IsPlayerFaction(info.faction) then
        if not fromDoEmote then
            print("Roar Forever: " .. info.slash .. " is only for " .. info.faction .. " characters.")
        end
        return
    end

    -- Forever 1.60 EmotesText has neither faction-cry token. Keep calling the
    -- retail token so a future build can supply the native cheer animation
    -- without an addon change. Do not fall back to CHEER: that would send the
    -- wrong emote text and play the cheer voice on top of the faction cry.
    -- Voice + announce stay on the slash/hook path; COMM is sent only from the
    -- DoEmote hook so slash + hook never double-broadcast.
    if not fromDoEmote and DoEmote then
        pcall(DoEmote, info.token)
    end

    if AddonEnabled() and EmoteEnabled(emoteName) then
        PlayLocalFactionCry(emoteName)
    end
    AnnounceCustomLineSoon(emoteName, info.line)
end

-- Slash commands are checked before built-in emote tokens, so this replaces
-- the silent game /train and still plays the choo-choo through DoEmote.
SLASH_ROARFOREVERTRAIN1 = "/train"
SlashCmdList.ROARFOREVERTRAIN = function()
    if DoEmote then
        DoEmote("TRAIN")
    end

    AnnounceCustomLineSoon("train", TRAIN_LINE)
end

SLASH_ROARFOREVERFTH1 = "/forthehorde"
if not SlashCmdList.FTH then
    SLASH_ROARFOREVERFTH2 = "/fth"
end
SlashCmdList.ROARFOREVERFTH = function()
    HandleFactionCry("forthehorde", false)
end

SLASH_ROARFOREVERFTA1 = "/forthealliance"
if not SlashCmdList.FTA then
    SLASH_ROARFOREVERFTA2 = "/fta"
end
SlashCmdList.ROARFOREVERFTA = function()
    HandleFactionCry("forthealliance", false)
end

if hooksecurefunc and DoEmote then
    -- Sole COMM transmitter for roar / train / faction cries. Slash handlers
    -- call DoEmote and must not BroadcastEmoteEvent themselves.
    hooksecurefunc("DoEmote", function(emote)
        if IsTrainToken(emote) then
            AnnounceCustomLineSoon("train", TRAIN_LINE)
            BroadcastEmoteEvent("train")
            return
        end

        if IsRoarToken(emote) then
            BroadcastEmoteEvent("roar")
            return
        end

        if type(emote) ~= "string" then
            return
        end

        local emoteName = factionEmoteByToken[string.upper(emote)]
        if emoteName then
            HandleFactionCry(emoteName, true)
            BroadcastEmoteEvent(emoteName)
        end
    end)
end
