LuaScript
=========

A sort of library thing I made loosely based off jQuery

Step 1) Starting LuaScript in your script
=========

######If LuaScript is a Script or LocalScript:
_G.lScript() --Which will set lScript_name in your script to the LuaScript base

######If LuaScript is a ModuleScript
your_variable=require(location.of.LuaScript.ModuleScript)

The complete documentation of LuaScript!
=========

* [function] LuaScript base
  * When called with (game)
    * [function] on([string] event,[function] fire)
      * When event = 'joining' or event='entering'
        * Calls function fire with the first argument being a player when a player enters the game
      * When event = 'leaving'
        * Calls function fire with the first argument being a player when a player is leaving the game
    * [player] lp
      * When a LocalScript, returns the LocalPlayer in an lScript Player, otherwise returns nil
  *
  * When called with a player
    * [string] name
      * The players name
    * [number] id
      * The players userId
    * [boolean] banned
      * True if the player has been banned using player.ban, otherwise false
    * [function] unban()
      * Unbans the player
    * [function] ban()
      * Bans the player
    * [function] disconnect()
      * Disconnects the player
    * [function] kick()
      * Same as disconnect, in that it disconnects and removes the player
    * [function] respawn()
      * Respawns the player
    * [number] appearance
      * Returns the players ID for CharacterAppearance, when changed immedietally updates CharacterAppearance to reflect this
    * [instance] team
      * Returns the team the player is on, or nil if not on a team, when changed, updates TeamColor to reflect this
    * [boolean] neutral
      * Returns if the player is neutral
    * [function] place (Place ID, Instance ID or Spawn Name)
      * If just a Place ID is specified, teleports the player to a server in Place ID
      * If an Instance ID is specified, teleports the player to the server with the same Instance ID in Place ID
      * If a Spawn Name is specified, teleports the player to the spawn name in a random server in Place ID (If the spawn is neutral)
      * THE FOLLOWING FUNCTIONS ARE ONLY USEABLE IN A LOCALSCRIPT, IN OTHER SCRIPTS THEY ARE NIL
      * [boolean] lp
        * Returns true if the player is the LocalPlayer, otherwise false
      * [function] logout()
        * Disconnects the player from the game, and attempts to log the user out of ROBLOX.com using a haxy method (See source code)
      * [string] OS and [string] os
        * Returns either Windows, Mac or iOS
      * [event] pause_menu_opened
        * Fires when the ROBLOX Pause menu is opened by the user
      * [event] pause_menu_closed
        * Fires when the ROBLOX pause menu is closed by the user
      * [boolean] paused
        * If the user is in the ROBLOX Pause menu, returns true, otherwise returns false
      * THE FOLLOWING FUNCTIONS ARE NOT USEABLE IN A LOCALSCRIPT, AND RETURN NIL IN LOCALSCRIPTS
      * [instance] replicator
        * Returns the ServerReplicator of the user
      * [function] load(index,type)
        * Loads index from Data Persistance using the type to specify the method
      * [function] save(index,value)
        * Saves value to index in the correct method of Data Persistance
  *
  * When called with HttpService
    * [function] get(address)
      * Reflection of GetAsync
    * [function] post(address,content)
      * Reflection of PostAsync
    * [function] guid()
      * Reflection of GenerateGUID
  *
  * When called with DataStoreService
    * [function] ds(name)
      * Gets GlobalDataStore with name name
  *
  * When called with GlobalDataStore
    * [function] load(key)
      * Returns key of GlobalDataStore
    * [function] save(key,value)
      * Sets key of GlobalDataStore to value
  *
  * When called with a ServerReplicator
    * [instance] player
      * Returns the player the ServerReplicator is associated with
    * [function] kick
      * Kicks the player associated with the ServerReplicator and disconnects the ServerReplicator
  *
  * When called with nil
    * [function] plugin(plugin_name)
      * Returns information on the plugin associated witb plugin_name
    * [function] setprint(start text)
      * Makes all new prints start with start_text, for example if start text was hello then doing print(' world') would return hello world
    * THE FOLLOWING FUNCTIONS ARE NOT USEABLE IN A LOCALSCRIPT, AND RETURN NIL IN LOCALSCRIPTS
    * [function] enable_replicationfilter(value)
      * Sets Workspace.FilteringEnabled to value
    * [function] edit_instancenew(edit)
      * If edit is true, adds luaScript instances to Instance.new, otherwise removes them if they exist
    * [function] edit_math(edit)
      * If edit is true, adds the following
        * math.lcm(a,b)
          * Returns the lowest common multiple of A and B
        * math.gcd(a,b)
          * Returns the greatest common divisor of A and B
        * math.fermat(n,t)
          * Performs a fermat primality to test to check if a number is a likely prime T times, (Higher T = More accurate) returns true or false
        * math.totient(n)
          * Returns the totatives of N using Euler's Totient function
      * Otherwise removes them if they exist
  *
  * When called with [string] try
    * If the 2nd argument runs successfully, returns a call of the 3rd argument, otherwise returns a call of the 4th argument
  *
  * When called with [string] http
    * Same as calling with HttpService
  *
  * When called with [string] ds or [string] datastore or [string] datastoreservice and in a script
    * Same as calling with DataStoreService
  *
  * When called with [string] new
    * Creates LuaScript Instance with name argument 2, and passes argument 3 onwards in creation, then returns the instance
