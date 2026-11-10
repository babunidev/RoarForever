"""Run with Python + lupa (Lua 5.1). No files are written to the game folder."""
from pathlib import Path
import re
from lupa.lua51 import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]

def boot(locale='enUS', saved=None):
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.globals().testLocale = locale
    lua.execute('''
        frames={}; sounds={}; soundKits={}; sent={}; stopped={}; timers={}; addonSent={}; SlashCmdList={}; UISpecialFrames={}
        now=100; grouped=false; playerPos={x=0,y=0,instanceID=0}; addonSendResult=0; instanceType='none'
        secretValues={}; secretChecks={}
        function issecretvalue(v)
            if v==nil then return false end
            if secretValues[v] then
                secretChecks[v]=(secretChecks[v] or 0)+1
                return true
            end
            return false
        end
        units={player={name='Tester',realm='Home',guid='Player-self'},
            target={name='Other',realm='Away',guid='Player-other'}}
        function GetLocale() return testLocale end
        local noop=function() end
        local methods={}
        for _,k in ipairs({'SetSize','SetPoint','SetFrameStrata','SetClampedToScreen',
            'SetMovable','EnableMouse','RegisterForDrag','StartMoving','StopMovingOrSizing',
            'SetWidth','SetJustifyH','SetScrollChild','SetTexture','SetOwner'}) do methods[k]=noop end
        function methods:SetText(t) self.text=t end
        function methods:RegisterEvent(e) self.events[e]=true end
        function methods:SetScript(e,f) self.scripts[e]=f end
        function methods:GetChecked() return self.checked end
        function methods:SetChecked(v) self.checked=v end
        function methods:IsShown() return self.shown end
        function methods:Show() self.shown=true; if self.scripts.OnShow then self.scripts.OnShow(self) end end
        function methods:Hide() self.shown=false end
        function methods:CreateFontString() return CreateFrame('FontString') end
        function methods:CreateTexture() return CreateFrame('Texture') end
        function CreateFrame(kind,name,parent,template)
            local f=setmetatable({kind=kind,name=name,parent=parent,template=template,events={},scripts={}}, {__index=methods})
            if template=='BasicFrameTemplateWithInset' then f.TitleText=CreateFrame('FontString') end
            if name then _G[name]=f end
            frames[#frames+1]=f
            return f
        end
        UIParent=CreateFrame('Frame'); GameTooltip=CreateFrame('Tooltip')
        function UnitExists(u) return units[u]~=nil end
        function UnitGUID(u) return units[u] and units[u].guid end
        function UnitName(u) local p=units[u]; if p then return p.name,p.realm end end
        UnitFullName=UnitName
        guidRace={['Player-self']='Gnome',['Player-other']='Gnome',['Player-friend']='Gnome',['Player-stranger']='Gnome'}
        function UnitRace(u)
            local p=units[u]; local r=(p and guidRace[p.guid]) or 'Gnome'
            return r,r
        end
        function GetNormalizedRealmName() return 'Home' end
        function GetPlayerInfoByGUID(guid)
            local r=guidRace[guid] or 'Gnome'
            local sex=(guidSex[guid]) or ((r=='Orc' or r=='Human') and 2) or 3
            return 'Warrior','WARRIOR',r,r,sex
        end
        guidSex={}
        function UnitSex(u)
            local p=units[u]
            if p and guidSex[p.guid] then return guidSex[p.guid] end
            local r=p and guidRace[p.guid]
            if r=='Orc' or r=='Human' then return 2 end
            return 3
        end
        playerFaction='Horde'
        function UnitFactionGroup() return playerFaction end
        function IsInGroup() return grouped end
        function IsInRaid() return raided or false end
        function IsInInstance() return instanceType~='none', instanceType end
        function UnitInParty(u) return u:match('^party')~=nil end
        function GetTime() return now end
        function UnitPosition() return playerPos.x, playerPos.y, 0, playerPos.instanceID end
        function PlaySoundFile(id) sounds[#sounds+1]=id; return true,#sounds end
        function StopSound(id) stopped[#stopped+1]=id end
        C_Sound={PlaySound=function(id,_,_,_,_,volume)
            soundKits[#soundKits+1]={id=id, volume=volume or 1}
            return true, #soundKits
        end}
        function SendChatMessage(text, kind) sent[#sent+1]={text=text, kind=kind or 'SAY'} end
        -- Match production: prefer C_ChatInfo when present (pre-0.5.5 train path).
        C_ChatInfo={
            SendChatMessage=function(text, kind) sent[#sent+1]={text=text, kind='C_'..(kind or 'SAY')} end,
            RegisterAddonMessagePrefix=function(prefix) registeredPrefix=prefix end,
            SendAddonMessage=function(prefix, payload, channel)
                addonSent[#addonSent+1]={prefix=prefix, payload=payload, channel=channel}
                return addonSendResult
            end,
        }
        doEmoteCallsHook=true; doEmoteCalls={}
        function DoEmote(token)
            doEmoteCalls[#doEmoteCalls+1]=token
            if doEmoteCallsHook and emoteHook then emoteHook(token) end
        end
        function hooksecurefunc(_,fn) emoteHook=fn end
        C_Timer={After=function(_,fn) timers[#timers+1]=fn end}
        function flush() local pending=timers; timers={}; for _,f in ipairs(pending) do f() end end
        function upvalue(fn,key)
            for i=1,100 do local k,v=debug.getupvalue(fn,i); if k==key then return v end; if not k then break end end
        end
        function event(kind,text,sender,guid)
            for _,f in ipairs(frames) do if f.events[kind] then
                f.scripts.OnEvent(f,kind,text,sender,nil,nil,nil,nil,nil,nil,nil,nil,nil,guid)
            end end
        end
        function addon(prefix,payload,channel,sender)
            for _,f in ipairs(frames) do if f.events.CHAT_MSG_ADDON then
                -- Forever CHAT_MSG_ADDON has no sender GUID; model the real payload.
                f.scripts.OnEvent(f,'CHAT_MSG_ADDON',prefix,payload,channel,sender,nil,nil,nil,nil,nil)
            end end
        end
    ''')
    ns=lua.table()
    for name in ('Locales.lua','RoarForever.lua','Options.lua'):
        lua.execute((ROOT/name).read_text(encoding='utf-8'), 'RoarForever', ns)
    lua.globals().RF=ns
    if saved: lua.execute(saved)
    lua.execute('''
        for _,f in ipairs(frames) do
            if f.events.CHAT_MSG_TEXT_EMOTE then
                handler=f.scripts.OnEvent
                HandleChatEmote=upvalue(handler,'HandleChatEmote')
                DetectEmote=upvalue(HandleChatEmote,'DetectEmote')
                PlayTextFallback=upvalue(HandleChatEmote,'PlayTextEmote')
                IsLocalPlayer=upvalue(upvalue(PlayTextFallback,'ShouldRestoreFromText'),'IsLocalPlayer')
                CanPlayForSender=upvalue(PlayTextFallback,'CanPlayForSender')
                GetSenderVoiceKey=upvalue(PlayTextFallback,'GetSenderVoiceKey')
                FindUnitBySender=upvalue(GetSenderVoiceKey,'FindUnitBySender')
            end
        end
    ''')
    return lua,ns

count=0
for locale in ('enUS','deDE','frFR','esES','ruRU','enGB','esMX'):
    lua,ns=boot(locale)
    detect=lua.globals().DetectEmote
    for _,row in ns.locale.templates.items():
        text=row[2]
        text=re.sub(r'\|3-\d\((.*?)\)',r'\1',text).replace('|2 ', 'de ')
        text=re.sub(r'%(?:[12]\$)?s','Alice',text)
        result=detect(text,'CHAT_MSG_TEXT_EMOTE','Alice')
        assert result==row[1], (locale,text,row[1],result)
        count+=1
    ns.OpenOptions()
    assert len(lua.globals().RoarForeverOptions.rows)==0  # keyed table, checked below
    assert sum(1 for _ in lua.globals().RoarForeverOptions.rows.items())==22

lua,ns=boot()
lua.execute('''
local detect=DetectEmote
assert(detect('Other checks her mana potions.','CHAT_MSG_EMOTE','Other')==nil)
assert(detect('Other roars with laughter.','CHAT_MSG_EMOTE','Other')==nil)
assert(detect('Other checks her mana potions.','CHAT_MSG_TEXT_EMOTE','Other')==nil)
assert(detect('Other congratulates Dingle.','CHAT_MSG_TEXT_EMOTE','Other')=='congrats')
assert(detect('Dingbat congratulates everyone.','CHAT_MSG_TEXT_EMOTE','Dingbat')=='congrats')
assert(detect('Other congratulates Alice.','CHAT_MSG_TEXT_EMOTE','Other')=='congrats')
assert(detect('Other blows a train whistle. Choo choo!','CHAT_MSG_EMOTE','Other')=='train')
assert(detect('Other discusses a train whistle.','CHAT_MSG_EMOTE','Other')==nil)
assert(detect('Other cheers for the Horde! For the Horde!','CHAT_MSG_EMOTE','Other')=='forthehorde')
assert(detect('Other cheers for the Horde!','CHAT_MSG_EMOTE','Other')==nil)
assert(detect('Other yells for the Horde in general.','CHAT_MSG_EMOTE','Other')==nil)
assert(detect('Other cheers for the Alliance! For the Alliance!','CHAT_MSG_EMOTE','Other')=='forthealliance')
assert(detect('Other cheers for the Alliance!','CHAT_MSG_EMOTE','Other')==nil)
assert(detect('Other talks about the Alliance casually.','CHAT_MSG_EMOTE','Other')==nil)
local isSelf=IsLocalPlayer
assert(not isSelf('Tester-Away','Player-other'))
assert(not isSelf('Tester-Away',nil))
assert(isSelf('Tester-Home',nil))
assert(isSelf('Different display name','Player-self'))

-- Forever restricted maps can return secret unit identity values for target/focus/mouseover.
-- The simulator cannot create Blizzard-tagged secret Lua values, so mark ordinary sentinels
-- and assert the production guard detects and skips them before identity matching.
local originalTarget=units.target
units.target={name='DungeonMob',realm='Away',guid='Creature-secret'}
secretValues.DungeonMob=true
secretValues['Creature-secret']=true
local beforeSecretTargetChecks=secretChecks.DungeonMob or 0
assert(isSelf('Tester',nil))
assert((secretChecks.DungeonMob or 0)==beforeSecretTargetChecks)
assert(FindUnitBySender('Nobody',nil)==nil)
assert((secretChecks.DungeonMob or 0)>beforeSecretTargetChecks)
assert(FindUnitBySender('Nobody','Player-missing')==nil)
assert((secretChecks['Creature-secret'] or 0)>0)
secretValues.HiddenSender=true
assert(not isSelf('HiddenSender',nil))
assert((secretChecks.HiddenSender or 0)>0)
secretValues['Secret-event-guid']=true
assert(not isSelf('Other','Secret-event-guid'))
assert((secretChecks['Secret-event-guid'] or 0)>0)
units.target=originalTarget

event('CHAT_MSG_TEXT_EMOTE','Other cheers!','Other','Player-other'); assert(#sounds==1)
event('CHAT_MSG_TEXT_EMOTE','Other cheers!','Other','Player-other'); assert(#sounds==1)
now=101; RF.SettingsDB().emotes.cheer=false
event('CHAT_MSG_TEXT_EMOTE','Other cheers!','Other','Player-other'); assert(#sounds==1)
RF.SetAddonEnabled(false); now=102
event('CHAT_MSG_TEXT_EMOTE','Other roars with bestial vigor. So fierce!','Other','Player-other'); flush(); assert(#sounds==1)
-- Preview works even while automatic playback is disabled and sends no chat.
-- Preview stops only its previous preview sample.
local stoppedBeforePreview=#stopped
RF.Preview('cheer'); RF.Preview('joke'); assert(#sounds==3 and #stopped==stoppedBeforePreview+1 and #sent==0)
-- Same speaker restarts (spam): previous handle for that player is stopped.
RF.SetAddonEnabled(true); RF.SettingsDB().emotes.cheer=true; RF.SettingsDB().emotes.roar=true
now=102.5; event('CHAT_MSG_TEXT_EMOTE','Other roars with bestial vigor. So fierce!','Other','Player-other'); flush()
local roarHandle=#sounds
now=103; event('CHAT_MSG_TEXT_EMOTE','Other roars with bestial vigor. So fierce!','Other','Player-other'); flush()
assert(#sounds==roarHandle+1 and stopped[#stopped]==roarHandle)
-- Different speaker overlaps: does not stop the other player's voice.
local stoppedAfterSame=#stopped
units.party1={name='Friend',realm='Home',guid='Player-friend'}; grouped=true
now=103.2; event('CHAT_MSG_TEXT_EMOTE','Friend roars with bestial vigor. So fierce!','Friend','Player-friend'); flush()
assert(#sounds==roarHandle+2 and #stopped==stoppedAfterSame)
grouped=false; units.party1=nil
RF.SetAddonEnabled(false); RF.SettingsDB().emotes.cheer=false
local pools=upvalue(RF.Preview,'previewPools')
assert(#pools.joke>60 and #pools.cheer>16)
RF.OpenOptions()
local panel=RoarForeverOptions
assert(panel.master.checked==false and panel.rows.cheer.checked==false)
panel.rows.cheer.checked=true; panel.rows.cheer.scripts.OnClick(panel.rows.cheer)
assert(RF.EmoteEnabled('cheer'))
panel.master.checked=true; panel.master.scripts.OnClick(panel.master)
assert(RF.AddonEnabled())
panel.announce.checked=false; panel.announce.scripts.OnClick(panel.announce)
local beforeAddon=#addonSent
SlashCmdList.ROARFOREVERTRAIN(); flush(); assert(#sent==0)
-- Chat-only restoration never broadcasts addon packets.
assert(#addonSent==beforeAddon)
panel.announce.checked=true; panel.announce.scripts.OnClick(panel.announce)
SlashCmdList.ROARFOREVERTRAIN(); assert(#sent==1 and sent[1].text=='blows a train whistle. Choo choo!' and sent[1].kind=='C_EMOTE')
now=104; RF.SettingsDB().emotes.train=false
SlashCmdList.ROARFOREVERTRAIN(); assert(#sent==1)
RF.SettingsDB().emotes.train=true
grouped=true; units.party1={name='Friend',realm='Home',guid='Player-friend'}
now=105; event('CHAT_MSG_TEXT_EMOTE','Friend cheers!','Friend','Player-friend'); assert(#sounds==6)
units.target={name='Friend',realm='Away',guid='Player-stranger'}
now=106; event('CHAT_MSG_TEXT_EMOTE','Friend cheers!','Friend','Player-stranger'); assert(#sounds==7)
-- Self/group roar still plays for races without a client roar.
now=107; event('CHAT_MSG_TEXT_EMOTE','You roar with bestial vigor. So fierce!','Tester','Player-self'); assert(#sounds==8)
now=108; event('CHAT_MSG_TEXT_EMOTE','Friend roars with bestial vigor. So fierce!','Friend','Player-friend'); flush(); assert(#sounds==9)
-- Skyborne roar follows the same rule as every other race.
guidRace['Player-self']='Skyborne'; guidRace['Player-friend']='Skyborne'
now=109; event('CHAT_MSG_TEXT_EMOTE','You roar with bestial vigor. So fierce!','Tester','Player-self'); assert(#sounds==10)
now=110; event('CHAT_MSG_TEXT_EMOTE','Friend roars with bestial vigor. So fierce!','Friend','Player-friend'); flush(); assert(#sounds==11)
-- Nearby non-grouped Skyborne roar is still restored.
guidRace['Player-stranger']='Skyborne'
now=111; event('CHAT_MSG_TEXT_EMOTE','Friend roars with bestial vigor. So fierce!','Friend','Player-stranger'); flush(); assert(#sounds==12)
-- /forthehorde: Horde orc plays locally via DoEmote hook; Alliance is refused.
guidRace['Player-self']='Orc'; guidRace['Player-friend']='Orc'; guidRace['Player-stranger']='Orc'; guidRace['Player-other']='Orc'
playerFaction='Alliance'; local beforeSent=#sent; local beforeSounds=#sounds
SlashCmdList.ROARFOREVERFTH(); flush()
assert(#sent==beforeSent and #sounds==beforeSounds)
playerFaction='Horde'; now=112
beforeAddon=#addonSent; local beforeDoEmote=#doEmoteCalls
SlashCmdList.ROARFOREVERFTH()
assert(#sent==beforeSent+1 and sent[#sent].text=='cheers for the Horde! For the Horde!' and sent[#sent].kind=='C_EMOTE')
assert(#sounds==beforeSounds+1 and sounds[#sounds]==1387394)
assert(#addonSent==beforeAddon and #doEmoteCalls==beforeDoEmote)
-- Own announce must not double-play; nearby and grouped others play once from received chat.
now=113; event('CHAT_MSG_EMOTE','cheers for the Horde! For the Horde!','Tester','Player-self'); flush(); assert(#sounds==beforeSounds+1)
now=114; event('CHAT_MSG_EMOTE','cheers for the Horde! For the Horde!','Other','Player-other'); flush(); assert(#sounds==beforeSounds+2)
now=115; event('CHAT_MSG_EMOTE','cheers for the Horde! For the Horde!','Friend','Player-friend'); flush(); assert(#sounds==beforeSounds+3)
RF.SetAddonEnabled(false); now=116
SlashCmdList.ROARFOREVERFTH(); assert(#sounds==beforeSounds+3)
RF.SetAddonEnabled(true)
-- /forthealliance: Alliance human plays; Horde is refused.
guidRace['Player-self']='Human'; guidRace['Player-friend']='Human'; guidRace['Player-other']='Human'
playerFaction='Horde'; beforeSent=#sent; beforeSounds=#sounds
SlashCmdList.ROARFOREVERFTA()
assert(#sent==beforeSent and #sounds==beforeSounds)
playerFaction='Alliance'; now=117
beforeAddon=#addonSent; beforeDoEmote=#doEmoteCalls
SlashCmdList.ROARFOREVERFTA()
assert(#sent==beforeSent+1 and sent[#sent].text=='cheers for the Alliance! For the Alliance!' and sent[#sent].kind=='C_EMOTE')
assert(#sounds==beforeSounds+1 and sounds[#sounds]==1502109)
assert(#doEmoteCalls==beforeDoEmote)
-- Legacy packets cannot replay local faction cries, even with another display name.
addon('RoarForever','1|E|forthealliance|HumanMale|1|||','PARTY','Different local display')
assert(#sounds==beforeSounds+1 and #addonSent==beforeAddon)
now=118; event('CHAT_MSG_EMOTE','cheers for the Alliance! For the Alliance!','Tester','Player-self'); flush(); assert(#sounds==beforeSounds+1)
now=119; event('CHAT_MSG_EMOTE','cheers for the Alliance! For the Alliance!','Other','Player-other'); flush(); assert(#sounds==beforeSounds+2)
now=120; event('CHAT_MSG_EMOTE','cheers for the Alliance! For the Alliance!','Friend','Player-friend'); flush(); assert(#sounds==beforeSounds+3)
-- Slash path is independent of DoEmote entirely; disabling the hook must not matter.
doEmoteCallsHook=false; now=121; beforeSent=#sent; beforeSounds=#sounds; beforeAddon=#addonSent; beforeDoEmote=#doEmoteCalls
SlashCmdList.ROARFOREVERFTA()
assert(#sent==beforeSent+1 and sent[#sent].kind=='C_EMOTE')
assert(#sounds==beforeSounds+1)
assert(#addonSent==beforeAddon and #doEmoteCalls==beforeDoEmote)
doEmoteCallsHook=true

-- Legacy COMM at any time/channel must never trigger sound. Text is authoritative.
grouped=true; units.party1={name='Friend Surname',realm='',guid='Player-friend'}
guidRace['Player-friend']='Human'
local payload='1|E|roar|HumanMale|7|||'
local before=#sounds
for _,channel in ipairs({'SAY','PARTY','RAID','INSTANCE_CHAT'}) do
    addon('RoarForever',payload,channel,'Friend Surname')
end
assert(#sounds==before)
now=130
event('CHAT_MSG_TEXT_EMOTE','Friend Surname roars with bestial vigor. So fierce!','Friend Surname','Player-friend')
assert(#sounds==before+1)
local handle=#sounds
for _,delay in ipairs({0.05,0.1,0.25,0.5,2,10}) do
    now=130+delay
    for _,channel in ipairs({'SAY','PARTY','RAID','INSTANCE_CHAT'}) do
        addon('RoarForever',payload,channel,'Friend Surname')
        addon('RoarForever',payload,channel,'Different local display')
    end
    flush()
    assert(#sounds==before+1)
end
-- Next real roar replaces that player's handle, never another player's handle.
now=141
event('CHAT_MSG_TEXT_EMOTE','Friend Surname roars with bestial vigor. So fierce!','Friend Surname','Player-friend')
assert(#sounds==before+2 and stopped[#stopped]==handle)
-- Group train and ordinary voices remain native; group faction cry is restored.
now=142; before=#sounds
event('CHAT_MSG_EMOTE','blows a train whistle. Choo choo!','Friend Surname','Player-friend')
event('CHAT_MSG_TEXT_EMOTE','Friend Surname cheers!','Friend Surname','Player-friend')
assert(#sounds==before)
event('CHAT_MSG_EMOTE','cheers for the Alliance! For the Alliance!','Friend Surname','Player-friend')
assert(#sounds==before+1)
-- Raid membership uses raid tokens and keeps the same native exclusions.
raided=true; units.raid1=units.party1; units.party1=nil
now=142.5; before=#sounds
event('CHAT_MSG_TEXT_EMOTE','Friend Surname cheers!','Friend Surname','Player-friend')
event('CHAT_MSG_EMOTE','blows a train whistle. Choo choo!','Friend Surname','Player-friend')
assert(#sounds==before)
event('CHAT_MSG_TEXT_EMOTE','Friend Surname roars with bestial vigor. So fierce!','Friend Surname','Player-friend')
assert(#sounds==before+1)
raided=false; units.party1=units.raid1; units.raid1=nil
-- Missing/secret coordinates are never read. No packet is required for text playback.
UnitPosition=function() error('chat-only playback must not query coordinates') end
now=143
event('CHAT_MSG_TEXT_EMOTE','Friend Surname roars with bestial vigor. So fierce!','Friend Surname','Player-friend')
assert(#sounds==before+2)
-- Slash never invokes protected DoEmote. A direct player/macro DoEmote call is
-- still observed by the hook and restores the faction voice once.
local originalDoEmote=DoEmote
DoEmote=function(token) now=now+0.2; originalDoEmote(token); now=now+0.2 end
now=150; before=#sounds; beforeDoEmote=#doEmoteCalls
SlashCmdList.ROARFOREVERFTA(); assert(#sounds==before+1 and #doEmoteCalls==beforeDoEmote)
now=152; DoEmote('FORTHEALLIANCE'); assert(#sounds==before+2 and #doEmoteCalls==beforeDoEmote+1)
assert(#addonSent==0 and registeredPrefix==nil)
-- Own roar is driven only by its chat event; arbitrary legacy echo names do nothing.
now=154; before=#sounds
DoEmote('ROAR')
event('CHAT_MSG_TEXT_EMOTE','You roar with bestial vigor. So fierce!','Tester','Player-self')
for _,channel in ipairs({'PARTY','RAID','INSTANCE_CHAT'}) do
    addon('RoarForever',payload,channel,'Different local display')
end
assert(#sounds==before+1)
-- An intentional repeat after the short cooldown still restarts the voice.
now=now+0.1
event('CHAT_MSG_TEXT_EMOTE','You roar with bestial vigor. So fierce!','Tester','Player-self')
assert(#sounds==before+2 and stopped[#stopped]==before+1)
-- Even if DoEmote would fail or be protected, the addon slash never calls it.
DoEmote=function() error('protected or unsupported native token') end
now=155; before=#sounds
SlashCmdList.ROARFOREVERFTA(); assert(#sounds==before+1)
DoEmote=originalDoEmote
now=156; DoEmote('FORTHEALLIANCE'); assert(#sounds==before+2)

-- Battleground hard-disable: no restored playback, previews, custom slash action,
-- announcements, raw test playback, or hook work while instance type is "pvp".
instanceType='pvp'; now=157
local bgSounds=#sounds; local bgSent=#sent; local bgDoEmote=#doEmoteCalls
event('PLAYER_ENTERING_WORLD')
event('CHAT_MSG_TEXT_EMOTE','Friend Surname roars with bestial vigor. So fierce!','Friend Surname','Player-friend')
assert(#sounds==bgSounds)
assert(not RF.Preview('roar') and #sounds==bgSounds)
SlashCmdList.ROARFOREVER('test roar'); assert(#sounds==bgSounds)
SlashCmdList.ROARFOREVER('id 539992'); assert(#sounds==bgSounds)
SlashCmdList.ROARFOREVERTRAIN(); assert(#sounds==bgSounds and #sent==bgSent and #doEmoteCalls==bgDoEmote)
SlashCmdList.ROARFOREVERFTA(); assert(#sounds==bgSounds and #sent==bgSent and #doEmoteCalls==bgDoEmote)
SlashCmdList.ROARFOREVERFTH(); assert(#sounds==bgSounds and #sent==bgSent and #doEmoteCalls==bgDoEmote)
DoEmote('FORTHEALLIANCE'); assert(#sounds==bgSounds and #sent==bgSent and #doEmoteCalls==bgDoEmote+1)

-- Leaving the battleground automatically restores the prior enabled state.
instanceType='none'; now=158
event('PLAYER_ENTERING_WORLD')
event('CHAT_MSG_TEXT_EMOTE','Friend Surname roars with bestial vigor. So fierce!','Friend Surname','Player-friend')
assert(#sounds==bgSounds+1)

-- All per-speaker state has a hard cap, then expires while idle.
local speakerState=upvalue(CanPlayForSender,'SpeakerState')
local states=upvalue(speakerState,'speakerStates')
local function stateCount() local n=0; for _ in pairs(states) do n=n+1 end; return n end
for i=1,2000 do
    now=160+i*0.001
    event('CHAT_MSG_TEXT_EMOTE','Visitor laughs.','Visitor '..i,'Player-visitor'..i)
    assert(stateCount()<=128)
end
assert(stateCount()==128)
now=230
for _,f in ipairs(frames) do if f.scripts.OnUpdate then f.scripts.OnUpdate(f,5) end end
assert(stateCount()==0)
-- Duplicate chat callbacks within the cooldown remain suppressed.
now=240; before=#sounds
for i=1,2 do event('CHAT_MSG_TEXT_EMOTE','Visitor laughs.','Visitor','Player-visitor') end
assert(#sounds==before+1)
''')
# Saved options load after the addon files: no eager defaults overwrite them.
lua,ns=boot(saved="RoarForeverDB={enabled=false,emotes={joke=false},announceTrain=false,existing='kept'}")
assert not ns.AddonEnabled() and not ns.EmoteEnabled('joke') and ns.EmoteEnabled('roar')
assert ns.SettingsDB().existing=='kept' and not ns.SettingsDB().announceTrain
lua.execute('''
RF.OpenOptions()
for key,row in pairs(RoarForeverOptions.rows) do
    row.checked=false; row.scripts.OnClick(row)
    assert(RF.SettingsDB().emotes[key]==false)
end
local before=#sounds
for _,f in ipairs(frames) do
    if f.kind=='Button' and f.scripts.OnEnter then f.scripts.OnClick(f) end
end
assert(#sounds==before+22 and #sent==0)
RoarForeverDB=true
assert(RF.AddonEnabled() and RF.EmoteEnabled('joke'))
''')
print(f'PASS: {count} translated templates; 7 locales; UI/settings/previews; native group exclusions; group roar and faction cries; protected faction-slash isolation; battleground hard-disable; legacy packet timing/echo immunity; speaker exclusivity; bounded/idle cache cleanup; secret identity guards; detection regressions.')
