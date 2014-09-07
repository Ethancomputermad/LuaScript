--lScript by Ethancomputermad
--[[
The MIT License (MIT)

Copyright (c) 2014 Ethancomputermad

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
Settings={}

Settings.lScript_name="ls" --Set to root name of lScript, for example ls would mean lScript can be used from ls(stuff) (Only in Scripts and LocalScripts)
Settings.OnlyInitialScriptsElevated=true --If set to true, only scripts that called lScript when the game started can use elevated functions (example: ls().plugin().add())


local conditions={}
conditions['elevation']=Settings.OnlyInitialScriptsElevated
local lScript_name=Settings.lScript_name
local math_index={"abs","acos","asin","atan","atan2","ceil","cos","cosh","deg","exp","floor","fmod","frexp","huge","ldexp","log","log10","max","min","modf","pi","pow","rad","random","randomseed","sin","sinh","sqrt","tan","tanh","acos","asin","atan","atan2"}
local bans={}
local sCallers={}
local function requires(condition)
    return conditions[tostring(condition):lower()]==true and true or false
end
local function elevated(scr)
	local function n(nu) return tonumber(nu)==nil and 9999 or tonumber(nu)
	return requires('elevation') and n(sCallers[scr])<10 or true
end
local function getTeam(p)
    for _, t in pairs(game:GetService("Teams"):children()) do
        if t.TeamColor==p.TeamColor then
            return t
        end
    end
end
local function findRep(plr)
	for _, rep in pairs(game:GetService("NetworkServer"):children()) do
		if rep:GetPlayer()==plr then return rep end
	end
end
function is(a) return script.ClassName==a end
function meta(tabl,e) tabl.__index={["lScript"]=true} tabl.__metatable="The metatable is locked." dv(e,tabl) end
function dv(ref,tabl)
	tabl.__index.name=ref.Name
	tabl.__index.class=ref.ClassName
	tabl.__index.archivable=ref.Archivable
	tabl.__index.parent=classes[ref.Parent.ClassName]==nil and ref.Parent or classes[ref.Parent.ClassName](ref.Parent)
end
local baseUrl="http://www.roblox.com"
local asset_root=baseUrl.."/Asset/"

local appearance_root=asset_root.."CharacterFetch.ashx?userId="
classes={
    ["DataModel"]=function()
        local g=newproxy(true)
        local m=getmetatable(g)
        m.__metatable="The metatable is locked."
        m.__newindex=function(r,i,v)
            
        end
        meta(m,game)
        m.__index.on=function(evnt,func)
            if evnt=="joining" or evnt=="player" or evnt=="entering" then
                game.Players.PlayerAdded:connect(function(raw_plr)
                    return func(classes["Player"](raw_plr))
                end)
			elseif evnt=="leaving" then
				game.Players.PlayerRemoving:connect(function(raw_plr)
					return func(classes["Player"](raw_plr))
				end)
           	end
            
        end
		m.__index.lp=function() return is("LocalScript") and classes["Player"](game.Players.LocalPlayer) or nil end
        return g
        
    end,
    ["Player"]=function(plr)
        local p=newproxy(true)
        local m=getmetatable(p)
        meta(m,plr)
        m.__index.name=plr.Name
        m.__index.id=plr.userId
        m.__index.banned=bans[plr.userId]~=nil
		m.__index.mouse=plr:GetMouse()
		m.__index.distance=function(pos)
			return plr:DistanceFromCharacter(pos)
		end
        function m.__index.unban()
            bans[plr.userId]=nil
            m.__index.banned=false
        end
        function m.__index.ban()
            bans[plr.userId]=true
            plr:Kick()
        end
        function m.__index.disconnect()
            plr:Kick()
        end
        function m.__index.kick()
            plr:Kick()
        end
        function m.__index.respawn()
            plr:LoadCharacter()
        end
        m.__index.appearance=plr.userId
        m.__index.team=getTeam(plr)
		m.__index.character=plr.Character
		m.__index.guest=plr.userId<0
		if m.__index.guest then
			m.__index.guest_id=tonumber(plr.Name:sub(7))
		end
		m.__index.bc=
		plr.MembershipType==Enum.MembershipType.None and "NBC" or
		plr.MembershipType==Enum.MembershipType.BuildersClub and "BC" or
		plr.MembershipType==Enum.MembershipType.TurboBuildersClub and "TBC" or
		"OBC"
		local cac=plr.CharacterAdded:connect(function(c)
			m.__index.character=c
			collectgarbage("collect")
		end)
        m.__index.neutral=m.__index.team==nil
        m.__index.place=function(ID,INSTANCE_ID_OR_SPAWN)
        	if not INSTANCE_ID==nil then
        		if type(INSTANCE_ID_OR_SPAWN)=="string" then
        			game:GetService("TeleportService"):TeleportToPlaceBySpawnName(is("LocalScript") and
					unpack({ID,INSTANCE_ID_OR_SPAWN}) or unpack({plr.userId,ID,INSTANCE_ID_OR_SPAWN}))
        		else
        		game:GetService("TeleportService"):TeleportToPlaceByInstance(is("LocalScript")
				and unpack({ID,INSTANCE_ID_OR_SPAWN}) or unpack({plr.userId,ID,INSTANCE_ID_OR_SPAWN})) end
        	else
        		game:GetService("TeleportService"):Teleport(is("LocalScript") 
				and ID or 
				unpack({plr.userId,ID}))
        	end
    	end
        m.__newindex=function(t,i,v)
           if i=="team" then
            if type(v)=="userdata" then
            elseif type(v)=="string" then v=game:GetService("Teams"):FindFirstChild(v)
            end
            plr.TeamColor=pcall(function() return v.TeamColor end) and v.TeamColor or v
            m.__index.team=getTeam(plr)
        elseif i=="appearance" then
            v=tonumber(v)
            m.__index.appearance=v
            plr.CharacterAppearance=appearance_root..tostring(v)
        end
    	end
		if is("LocalScript") then 
		m.__index.lp=plr==game.Players.LocalPlayer
		if m.__index.lp then
		m.__index.logout=function() game:GetService("ContentProvider"):Preload(baseUrl.."/IDE/GoToWebsite/"..math.sqrt(146918641).."ReturnURL="..baseUrl) game.Players.LocalPlayer.Parent=nil wait() game.Players.LocalPlayer.Parent=game.Players end
		m.__index.OS=game:GetService("GuiService").IsWindows and "Windows" or game:GetService("UserInputService").TouchEnabled and "iOs" or "Mac"
		m.__index['os']=m.__index.OS
		m.__index.pause_menu_opened=LoadLibrary("RbxUtility").CreateSignal()
		m.__index.pause_menu_closed=LoadLibrary("RbxUtility").CreateSignal()
		m.__index.paused=false
		coroutine.wrap(function()
			local old=false
			while true do wait()
				if game:GetService("GuiService").IsModalDialog~=old then
					old=game:GetService("GuiService").IsModalDialog
					m.__index.paused=old
					local to_fire=old==true and m.__index.pause_menu_opened or m.__index.pause_menu_closed
					to_fire:fire()
				end
			end
		end)()
		end
		else
		m.__index.replicator=classes["ServerReplicator"](findRep(plr))
		m.__index.load=function(type,key)
			repeat wait() until plr.DataReady
			type=tostring(type):lower()
			key=tostring(key)
			if type=="number" then
				return plr:LoadNumber(key)
			elseif type=="string" then
				return plr:LoadString(key)
			elseif type=="instance" then
				return plr:LoadInstace(key)
			elseif type=="boolean" then
				return plr:LoadBoolean(key)
			end return nil
		end
		m.__index.save=function(type,key,value)
			repeat wait() until plr.DataReady
			type=tostring(type):lower()
			key=tostring(key)
			if type=="number" then
				return plr:SaveNumber(key,value)
			elseif type=="string" then
				return plr:SaveString(key,value)
			elseif type=="instance" then
				return plr:SaveInstace(key,value)
			elseif type=="boolean" then
				return plr:SaveBoolean(key,value)
			end return nil
		end
		end
        return p
end,
["HttpService"]=function()
	local h=newproxy(true)
	local m=getmetatable(h)
	meta(m,game:GetService("HttpService"))
    m.__metatable="The metatable is locked."
	function m.__index.get(addr)
		return game:GetService("HttpService"):GetAsync(addr)
	end
	function m.__index.post(addr,content)
		return game:GetService("HttpService"):PostAsync(addr,content)
	end
	function m.__index.guid()
		local id=game.HttpService:GenerateGUID()
		return id:sub(2,#id-1)
	end
	return h
end,
["DataStoreService"]=function()
	local d=newproxy(true)
	local m=getmetatable(d)
	meta(m,game:GetService("DataStoreService"))
	m.__index.ds=function(scope)
		scope=scope==nil and "global" or tostring(scope)
		return classes["GlobalDataStore"](game:GetService("DataStoreService"):GetGlobalDataStore(scope),scope)
	end
	return d
end,
["GlobalDataStore"]=function(data,scope)
	local ds=newproxy(true)
	local m=getmetatable(ds)
	meta(m,{['Name']=scope,["Parent"]=game:GetService("DataStoreService"),["ClassName"]="GlobalDataStore",["Archivable"]=false})
	m.__index.load=function(key)
		return data:GetAsync(key)
	end
	m.__index.save=function(key,value)
		return data:SetAsync(key,value)
	end
	return ds
end,
["ServerReplicator"]=function(rep)
	local r=newproxy(true)
	local m=getmetatable(r)
	meta(m,rep)
	m.__index.player=classes["Player"](rep:GetPlayer())
	m.__index.kick=function()
		rep:GetPlayer().Parent=nil
		wait() rep:GetPlayer().Parent=game.Players
		wait() pcall(function() rep:GetPlayer():Kick() end)
	end
end
}
instances={
	["dropdown"]=function(options)
		local dd=newproxy(true)
		local m=getmetatable(dd)
		m=meta(m)
		m.__.index.selected=options[1]
		local selected_index=1
		local gui=Instance.new("Frame")
		gui.BackgroundTransparency=1
		gui.Name="Dropdown"
		
		local function optionSelected(index)
			selected_index,m.__index.selected=index,options[index]
		end
		m.__index['gui']=gui
		return dd
	end
}
local PluginMgr=newproxy(true)
local Plugins={}
local pm=getmetatable(PluginMgr)
pm.__index,pm.__newindex,pm.__metatable={},function() end,"The metatable is locked."
pm.__index.add=function(plugin)
if elevated(getfenv(0)['script']) then
	local steal={}
	for i,v in pairs(plugin) do
		steal[i]=v
	end plugin=steal
	if (not plugin.Source==nil) and (not plugin.Name==nil) then
		if type(plugin.Source)=="string" and type(plugin.Name)=="string" then else return end
		plugin.time=time()
		Plugins[plugin.Name]=plugin
		if plugin.Coroutine==true then
			coroutine.wrap(function()
		ypcall(loadstring(plugin.Source)) end)() else ypcall(loadstring(plugin.Source)) end
	end
else

end
end
local lscript=function(...)
    local raw={...}
    local use=raw[1]
	if use==nil then
		local lq=newproxy(true)
		local m=getmetatable(lq)
		m.__index={}
		m.__metatable="The metatable is locked."
		m.__index.plugin=function(get)
		if get==nil then
			return PluginMgr
		else
			return Plugins[tostring(get)]
		end
		m.__index.setprint=function(prnt_str)
			if getfenv(0)["lScript_rawprint"]==nil then
				getfenv(0)["lScript_rawprint"]=getfenv(0)["print"]
				getfenv(0)["print"]=function(...)
				local args={...}
				local str=prnt_str.."> "
				for _, a in pairs(args) do
					str=str..tostring(a)
				end	
				getfenv(0)["lScript_rawprint"](str)
				end
			end
		end
		if is("Script") then
		m.__index.enable_replicationfilter=function(y_or_n)
			game.Workspace.FilteringEnabled=toboolean(y_or_n)
		end
		m.__index.enable_loadstring=function(y_or_n)
			game.Workspace.LoadStringEnabled=toboolean(y_or_n)
		end end
		m.__index.edit_instancenew=function(y_or_n)
			if getfenv(0)['lScript_instance']==nil then
				getfenv(0)['lScript_instance']=Instance
			end
			if y_or_n==true then
			getfenv(0)['Instance']={}
			local meta_inst=getmetatable(getfenv(0)['Instance'])
			meta_inst.__index,meta_inst.__newindex,meta_inst.__metatable={},function() end,"The metatable is locked."
			meta_inst.__index.new=function(class,parent)
			class=tostring(class)
			if instances[string.lower(class)]~=nil then
				return instances[string.lower(class)](parent) --Parent may = options
			else
				return Instance.new(class,parent)
			end
		end
			else
			getfenv(0)['Instance']=getfenv(0)['lScript_instance']
			end
		end
		m.__index.edit_math=function(y_or_n)
			if y_or_n==true then
				getfenv(0)['math']=newproxy(true)
				local meta_math=getmetatable(getfenv(0)['math'])
				meta_math.__index,meta_math.__newindex,meta_math.__metatable={},function() end,"The metatable is locked."
				for _, i in pairs(math_index) do
					meta_math.__index[i]=math[i]
				end
				meta_math.__index.lcm=function(a,b)
					if tonumber(a)==0 or tonumber(b)==0 or a==nil or b==nil then
						return 0
					else
					a,b=tonumber(a),tonumber(b)
					local scope=100
					local ret=false
					local for_a={}
					local for_b={}
					repeat
					for i=2+(scope-100), scope do
						table.insert(for_a,a*i)
						table.insert(for_b,b*i)
					end
					for i=1, 99 do
						local ind=99-(i-1)
						for _, v in pairs(for_b) do
							if v==for_a[ind] then
								ret=true
								return v
							end
						end
					end
					scope=scope+100 until ret
					end
				end
				meta_math.__index.gcd=function(a,b)
					local function tn(n)
						return n==nil and 0 or tonumber(n)
					end
					a,b=tn(a),tn(b)
					if a==0 or b==0 then return 0 end
				    local for_a={}
   					local for_b={}
    				for i=1, a do
        				if a/i==math.floor(a/i) then
            				table.insert(for_a,i)
        				end
    				end
    				for i=1, b do
        				if b/i==math.floor(b/i) then
            				table.insert(for_b,i)
        				end
    				end
    				for ind=1, #for_a do
       					local c_ind=for_a[#for_a-(ind-1)]
        				local cur=for_a[c_ind]
        				for _, divs in pairs(for_b) do
            				if divs==cur then
                				return cur
            				end
        				end
    				end
    				return 1
				end
				meta_math.__index.fermat=function(n,k) 
					for i=1, k do
        				local a=math.random(1,n-1)
       					if math.pow(n,a-1)==math.modf(n) then
            				return false
        				end
    				end
    				return true
				end
				meta_math.__index.totient=function(n)
					local phi=n
					local function fermat(n,k)
						for i=1, k do
        				local a=math.random(1,n-1)
       					if math.pow(n,a-1)==math.modf(n) then
            				return false
        				end
    				end
    				return true
    				end
					for k=2,n do
						if fermat(n,n*2) and n%k==0 then
							phi=phi*(k-1)/k
						end
					end
					return phi
				end
			else
				getfenv(0)['math']=math
			end
		end
		return lq
    elseif use=="try" then
       local v_if_true=load(raw[2])~=nil and raw[2] or function() end
       local v_if_false=load(raw[3])~=nil and raw[3] or function() end
            local s,str=ypcall(raw[1])
        if s then
            v_if_true(s,str)
        else
            v_if_false(s,str)
        end
        return s==true and "true" or str
	elseif use=="http" then
		return classes["HttpService"]()
	elseif (not is("LocalScript")) and (use==game:GetService("DataStoreService") or (type(use)=="string" and (use:lower()=="ds" or use:lower()=="datastore" or use:lower()=="datastoreservice"))) then
		return classes["DataStoreService"]()
	elseif use=="new" then
		local create=raw[2]
		if instances[tostring(create):lower()]~=nil then
			local args={}
			if raw>2 then
				for i=3,#raw do
					table.insert(args,raw[i])
				end
			end
			return instances[tostring(create):lower()](unpack(args))
		end
	 elseif type(use)=="userdata" then
		return pcall(function() return use.lScript end) and use or classes[use.ClassName](use)
	end
end

local m=getmetatable(lscript)

if is("ModuleScript") then
	sCallers[getfenv(0)['script']]=time()
	return lscript
else
	local caller={}
	local cm=getmetatable(caller)
	cm.___call=function()
		sCallers[getfenv(0)['script']]=time()
		getfenv(0)[lScript_name]=lscript
	end
	cm.__index={}
	cm.__newindex=function() end
	cm.__metatable="The metatable is locked."
	_G.lScript=caller
end
