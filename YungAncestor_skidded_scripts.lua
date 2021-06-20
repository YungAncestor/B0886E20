require("natives-1614644776")

--
-- compability with 2t1 scripts
--

script = {}
function script.trigger_script_event(first_arg, receiver, args)
	table.insert(args, 1, first_arg)
	util.trigger_script_event(1 << receiver, args)
end

--
-- main functions
--

function clone(pid)
	local playerpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	PED.CLONE_PED(playerpedid, 1, 1, 1);
end

function block_passive(pid)
	-- {0: =-909357184}
	script.trigger_script_event(-909357184, pid, {1, 1})
end

function unblock_passive(pid)
	-- {0: =-909357184}
	script.trigger_script_event(-909357184, pid, {1, 0})
end

function ceo_kick(pid)
	-- CEO terminate, {0: =-1648921703, 3: =6}
	-- CEO dismiss, {0: =-1648921703, 3: =5}
	-- MC Club Kick,	{0: =-2105858993}
	script.trigger_script_event(-701823896, pid, {-1, 0})
	script.trigger_script_event(-1648921703, pid, {1, 1, 6})
	script.trigger_script_event(-1648921703, pid, {0, 1, 5})
end

function ceo_ban(pid)
	-- {0: =-738295409, 2: !0}
	script.trigger_script_event(-327286343, pid, {-1, 0})
	script.trigger_script_event(-738295409, pid, {0, 1, 5, 0})
end

function force_to_mission(pid)
	-- {0: =-545396442}, {0: =1115000764}
	script.trigger_script_event(-545396442, pid, {0, 0})
end

function kick_from_vehicle(pid)
	-- {0: =-1333236192}
	script.trigger_script_event(-1333236192, pid, {-1, 0})
	script.trigger_script_event(-1089379066, pid, {-1, 0})
end

function vehicle_emp(pid)
	-- {0: =-152440739}
	local playerpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local coords = ENTITY.GET_ENTITY_COORDS(playerpedid)
	script.trigger_script_event(-152440739, pid, {pid, math.ceil(coords.x), math.ceil(coords.y), math.ceil(coords.z), 0})
end

function blackscreen(pid)
	-- {0: =-171207973, 3: =-1, 4: =1, 5: =-1}
	script.trigger_script_event(-171207973, pid, {-1139568479, -1, 1, 100099, -1, 500000, 849451549, -1, -1, 0})
end

function insurance_fraud(pid)
	-- {0: =891272013}
	script.trigger_script_event(891272013, pid, {math.random(0, 2147483647)}) 
end

function invaild_apartment_invite(pid)
	-- {0: =-171207973, 5: <1 | >114}
	script.trigger_script_event(-171207973, pid, {-171207973})
	script.trigger_script_event(-171207973, pid, {0, 0, 46190868, 0, 2})
	script.trigger_script_event(-171207973, pid, {46190868, 0, 46190868, 46190868, 2})
	script.trigger_script_event(-171207973, pid, {1337, -1, 1, 1, 0, 0, 0})
	script.trigger_script_event(-171207973, pid, {pid, 1337, -1, 1, 1, 0, 0, 0})
end

function send_to_island(pid)
	-- {0: =1300962917}
	script.trigger_script_event(1300962917, pid, {-1, 0}) 
end

function transcation_failed(pid)
	-- {0: =1302185744}
	script.trigger_script_event(1302185744, pid, {pid, 1, 1, 1})
end

function attach_object_to_player(pid, hash, x, y, z, xrot, yrot, zrot, visiblity, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
	local playerpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local coords = ENTITY.GET_ENTITY_COORDS(playerpedid)
	local objid = 0
	local waitload = 0
	util.toast("COORDS: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
	util.toast(hash)
	STREAMING.REQUEST_MODEL(hash)
	while not STREAMING.HAS_MODEL_LOADED(hash) do
		if (waitload > 10) then
			util.toast("request model failed")
			break
		end
		util.yield(100)
		waitload = waitload + 1
	end
	if STREAMING.HAS_MODEL_LOADED(hash) then
		objid = OBJECT.CREATE_OBJECT(hash, coords.x, coords.y, coords.z, true, true, true)
		if (objid==0) then
			util.toast("create object failed")
		else
			util.toast(objid)
			if (visiblity==false) then
				ENTITY.SET_ENTITY_VISIBLE(objid, false, false)
			end
			ENTITY.ATTACH_ENTITY_TO_ENTITY(objid, playerpedid, 0, x, y, z, xrot, yrot, zrot, true, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
		end
	end
end

function attach_self_to(pid, x, y, z, rotx, roty, rotz)
	local playerpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local selfpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local coords = ENTITY.GET_ENTITY_COORDS(playerpedid)
	local pedid = 0
	local waitload = 0
	util.toast("COORDS: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
	if (playerpedid == selfpedid) then
		-- test on self - create ped
		pedid = PED.CLONE_PED(selfpedid, 1, 1, 1);
		ENTITY.SET_ENTITY_INVINCIBLE(pedid, true);
		ENTITY.ATTACH_ENTITY_TO_ENTITY(selfpedid, pedid, 0, x, y, z, rotx, roty, rotz, true, false, false, false, 0, true)
	else
		ENTITY.ATTACH_ENTITY_TO_ENTITY(selfpedid, playerpedid, 0, x, y, z, rotx, roty, rotz, true, false, false, false, 0, true)
	end
end

function clear_ped_task(pedid)
	TASK.CLEAR_PED_TASKS_IMMEDIATELY(pedid)
	TASK.CLEAR_PED_TASKS(pedid)
	TASK.CLEAR_PED_SECONDARY_TASK(pedid)
end

function detach_self()
	local playerpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local selfpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	if (ENTITY.IS_ENTITY_ATTACHED(selfpedid) == true) then
		pedid = ENTITY.GET_ENTITY_ATTACHED_TO(selfpedid)
		util.toast(pedid)
		ENTITY.DETACH_ENTITY(selfpedid, true, false)
		clear_ped_task(selfpedid)
	end
end

function cult_troll(pid, hash)
	local playerpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local coords = ENTITY.GET_ENTITY_COORDS(playerpedid)
	local pedid = 0
	local waitload = 0
	util.toast("COORDS: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
	util.toast(hash)
	STREAMING.REQUEST_MODEL(hash)
	while not STREAMING.HAS_MODEL_LOADED(hash) do
		if (waitload > 10) then
			util.toast("request model failed")
			break
		end
		util.yield(100)
		waitload = waitload + 1
	end
	if STREAMING.HAS_MODEL_LOADED(hash) then
		pedid = util.create_ped(26, hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if (pedid==0) then
			util.toast("create_ped failed")
		else
			util.toast(pedid)
			ENTITY.SET_ENTITY_INVINCIBLE(pedid, true);
			ENTITY.ATTACH_ENTITY_TO_ENTITY(pedid, playerpedid, 0, 0.4, 0, 0, 0, 0, 0, true, true, false, false, 0, true)
		end
		pedid = util.create_ped(26, hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if (pedid==0) then
			util.toast("create_ped failed")
		else
			util.toast(pedid)
			ENTITY.SET_ENTITY_INVINCIBLE(pedid, true);
			ENTITY.ATTACH_ENTITY_TO_ENTITY(pedid, playerpedid, 0, 0, 0.4, 0, 0, 0, 0, true, true, false, false, 0, true)
		end
		pedid = util.create_ped(26, hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if (pedid==0) then
			util.toast("create_ped failed")
		else
			util.toast(pedid)
			ENTITY.SET_ENTITY_INVINCIBLE(pedid, true);
			ENTITY.ATTACH_ENTITY_TO_ENTITY(pedid, playerpedid, 0, 0, -0.4, 0, 0, 0, 0, true, true, false, false, 0, true)
		end
		pedid = util.create_ped(26, hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if (pedid==0) then
			util.toast("create_ped failed")
		else
			util.toast(pedid)
			ENTITY.SET_ENTITY_INVINCIBLE(pedid, true);
			ENTITY.ATTACH_ENTITY_TO_ENTITY(pedid, playerpedid, 0, -0.4, 0, 0, 0, 0, 0, true, true, false, false, 0, true)
		end
	end
end

function harmless_shoot(pid, hash)
	local pedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local coords = ENTITY.GET_ENTITY_COORDS(pedid)
	util.toast("COORDS: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
	util.toast(pedid)
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x, coords.y, coords.z+0.2, coords.x, coords.y, coords.z, 0, false, hash, 0, false, false, 10000)
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x, coords.y+0.2, coords.z, coords.x, coords.y, coords.z, 0, false, hash, 0, false, false, 10000)
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x+0.2, coords.y, coords.z, coords.x, coords.y, coords.z, 0, false, hash, 0, false, false, 10000)
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x, coords.y-0.2, coords.z, coords.x, coords.y, coords.z, 0, false, hash, 0, false, false, 10000)
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x-0.2, coords.y, coords.z, coords.x, coords.y, coords.z, 0, false, hash, 0, false, false, 10000)
end


function ped_crash(pid)
	local pedhash = {
		762327283,
		2238511874,
		1057201338,
	}
	local playerpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local coords = ENTITY.GET_ENTITY_COORDS(playerpedid)
	local selfcoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
	local objid = 0
	local waitload = 0
	util.toast("TARGET COORDS: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
	-- to do: add distance check here
	for i, hash in pairs(pedhash) do
		util.toast(hash)
		STREAMING.REQUEST_MODEL(hash)
		waitload = 0
		while not STREAMING.HAS_MODEL_LOADED(hash) do
			if (waitload > 10) then
				util.toast("request model failed")
				break
			end
			util.yield(100)
			waitload = waitload + 1
		end
		if STREAMING.HAS_MODEL_LOADED(hash) then
			objid = util.create_ped(26, hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			if (objid==0) then
				util.toast("create ped failed")
			else
				util.toast(objid)
				ENTITY.ATTACH_ENTITY_TO_ENTITY(objid, playerpedid, 0, 0, -0.23, 0.50, 0, 0, 0, true, true, true, false, 0, true)
				util.yield(100)
				ENTITY.DELETE_ENTITY(objid)
			end
		end
	end
end

function se_crash(pid)
	local crash_script_events =
	{
		-977515445,
		767605081,
		-1730227041,
		-1975590661
	}
	if pid then
	
		for i = 0, 14 do
			script.trigger_script_event(-2122716210, pid, {pid, i})
		end
		for i = 1, 20 do
			local parameters = {pid}
			for I = 1, 120 do
				for j = 2, 26 do
					parameters[j] = math.random(-10000, 10000)
				end
				script.trigger_script_event(-1882923979, pid, parameters)
			end
		end
		
		for i = 1, 120 do
			local parameters = {pid, -1139568479, math.random(0, 4), math.random(0, 1)}
			for j = 5, 13 do
				parameters[j] = math.random(41, 2147483647)
			end
			parameters[10] = pid
			script.trigger_script_event(-1949011582, pid, parameters)
		end
		
		for i = 1, 5 do
			for I, k in pairs(crash_script_events) do
				local parameters = {}
				for L = 1, 10 do
					parameters[L] = math.random(1000000, 2147483647)
				end
				script.trigger_script_event(k, pid, parameters)
			end
		end
	end
end

function kick(pid)
	if (pid == players.user()) then
		util.toast("You can't kick yourself!")
		return
	end
	if (players.get_host() == players.user()) then
		-- is host
		NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
		return
	end

	script.trigger_script_event(1347850743, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-1212832151, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1428412924, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-435067392, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-799924696, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1428412924, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	util.yield(100)
	if not players.exists(pid) then return end

	script.trigger_script_event(-577286683, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-1911813629, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-1333236192, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-1648921703, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1347850743, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-435067392, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-2017629233, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1159655011, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(495824472, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1922258436, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-2042143896, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1317868303, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-345371965, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1070934291, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(-966559987, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1974064500, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(2017765964, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(620255745, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})				 
	script.trigger_script_event(-1054826273, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1977655521, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1998625272, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(767605081, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1061242798, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
	script.trigger_script_event(1841943281, pid, {-17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691}) 
	util.yield(100)
	if not players.exists(pid) then return end
	
	script.trigger_script_event(-1491386500, pid, {-1, 0})
	script.trigger_script_event(-1729804184, pid, {-1, 0})
	script.trigger_script_event(1428412924, pid, {-1, 0})
	script.trigger_script_event(823645419, pid, {-1, 0})
	script.trigger_script_event(1070934291, pid, {-1, 0})
	script.trigger_script_event(-1949011582, pid, {-1, 0})
	script.trigger_script_event(-171207973, pid, {-1, 0})
	script.trigger_script_event(-1212832151, pid, {-1, 0})
	script.trigger_script_event(-1559754940, pid, {-1, 0})
	script.trigger_script_event(-1054826273, pid, {-1, 0})
	script.trigger_script_event(1620254541, pid, {-1, 0})
	script.trigger_script_event(1401831542, pid, {-1, 0})
	script.trigger_script_event(12450245, pid, {-1, 0})
	script.trigger_script_event(767605081, pid, {-1, 0})
	script.trigger_script_event(-1949011582, pid, {-1, 0})
	script.trigger_script_event(-1975590661, pid, {-1, 0})
	script.trigger_script_event(-922075519, pid, {-1, 0})
	script.trigger_script_event(-1491386500, pid, {-1, 0})
	script.trigger_script_event(-212271621, pid, {-1, 0})
	script.trigger_script_event(-1491386500, pid, {-1, 0})
	script.trigger_script_event(-1729804184, pid, {-1, 0})
	script.trigger_script_event(1428412924, pid, {-1, 0})
	script.trigger_script_event(823645419, pid, {-1, 0})
	script.trigger_script_event(1070934291, pid, {-1, 0})
	script.trigger_script_event(-1949011582, pid, {-1, 0})
	script.trigger_script_event(-171207973, pid, {-1, 0})
	script.trigger_script_event(-1212832151, pid, {-1, 0})
	script.trigger_script_event(-1559754940, pid, {-1, 0})
	script.trigger_script_event(-1054826273, pid, {-1, 0})
	script.trigger_script_event(1620254541, pid, {-1, 0})
  script.trigger_script_event(1401831542, pid, {-1, 0})
	script.trigger_script_event(12450245, pid, {pid, -10000000, -10000000, -1000000, -10000000000, -100000, -1000000000, -10000, -10, -100, -1, -10000000000000, -10000000, -10000000, -1000000, -1000000, -100000, -1000000, -10, -10, pid, -10, pid})
	script.trigger_script_event(767605081, pid, {pid, -10000000, -10000000, -1000000, -10000000000, -100000, -1000000000, -10000, -10, -100, -1, -10000000000000, -10000000, -10000000, -1000000, -1000000, -100000, -1000000, -10, -10, pid, -10, pid})
	script.trigger_script_event(-1949011582, pid, {pid, -10000000, -10000000, -1000000, -10000000000, -100000, -1000000000, -10000, -10, -100, -1, -10000000000000, -10000000, -10000000, -1000000, -1000000, -100000, -1000000, -10, -10, pid, -10, pid})
	script.trigger_script_event(-1975590661, pid, {pid, -10000000, -10000000, -1000000, -10000000000, -100000, -1000000000, -10000, -10, -100, -1, -10000000000000, -10000000, -10000000, -1000000, -1000000, -100000, -1000000, -10, -10, pid, -10, pid})
	script.trigger_script_event(-922075519, pid, {pid, -10000000, -10000000, -1000000, -10000000000, -100000, -1000000000, -10000, -10, -100, -1, -10000000000000, -10000000, -10000000, -1000000, -1000000, -100000, -1000000, -10, -10, pid, -10, pid})
	script.trigger_script_event(-1491386500, pid, {pid, -10000000, -10000000, -1000000, -10000000000, -100000, -1000000000, -10000, -10, -100, -1, -10000000000000, -10000000, -10000000, -1000000, -1000000, -100000, -1000000, -10, -10, pid, -10, pid})
	script.trigger_script_event(-212271621, pid,{pid, -10000000, -10000000, -1000000, -10000000000, -100000, -1000000000, -10000, -10, -100, -1, -10000000000000, -10000000, -10000000, -1000000, -1000000, -100000, -1000000, -10, -10, pid, -10, pid})
end

function self_play_anim(dict, animname)
	-- can only use on yourself
	-- clear ped task to stop
	local selfpedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local waitload = 0
	if (STREAMING.DOES_ANIM_DICT_EXIST(dict)) then
		STREAMING.REQUEST_ANIM_DICT(dict);
		while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do
			if (waitload > 10) then
				util.toast("request anim dict failed")
				break
			end
			util.yield(100)
			waitload = waitload + 1
		end
		if STREAMING.HAS_ANIM_DICT_LOADED(dict) then
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(selfpedid)
			TASK.TASK_PLAY_ANIM(selfpedid, dict, animname, 1.0, -1.0, -1, 1, 0, false, false, false)
		end
	end
end

--
-- Define menu options 
--

GenerateFeatures = function(pid) -- Here is where you will generate all your features 
	util.toast("Found player in slot " .. pid)
	
	--menu.divider(menu.player_root(pid), "Friendly")
	--menu.action(menu.player_root(pid), "Remove Wanted Level", {}, "", function(on_click)
	--	util.toast("Attempting to remove wanted level for player in slot " .. pid)
		-- {0: =393068387}
	--	util.toast("Done remove wanted level")
	--end)  

	--menu.action(menu.player_root(pid), "Give Off The Radar", {}, "", function(on_click)
	--	util.toast("Attempting to give OTR to player in slot " .. pid)
		-- {0: =575518757}
	--	script.trigger_script_event(575518757, pid, {}) 
	--	util.toast("Done give otr")
	--end)  
	
	menu.divider(menu.player_root(pid), "Griefing")
	
	menu.action(menu.player_root(pid), "Clone", {}, "", function(on_click)
		clone(pid)
	end)
	
	menu.action(menu.player_root(pid), "Block Passive", {}, "", function(on_click)
		util.toast("Sending Block Passive Mode to player in slot " .. pid .. "")	
		block_passive(pid)
		util.toast("Done Block Passive")
	end)  
	
	menu.action(menu.player_root(pid), "CEO Kick", {}, "", function(on_click)
		util.toast("Sending CEO Kick to player in slot " .. pid .. "")
		ceo_kick(pid)
		util.toast("Done ceo kick")
	end)  
	
	menu.action(menu.player_root(pid), "CEO Ban", {}, "", function(on_click)
		util.toast("Sending CEO Ban to player in slot " .. pid .. "")
		ceo_ban(pid)
		util.toast("Done ceo ban")
	end)  
	
	menu.action(menu.player_root(pid), "Force To Mission", {}, "", function(on_click)
		util.toast("Sending Force To Mission to player in slot " .. pid .. "")
		force_to_mission(pid)
		util.toast("Done Force To Mission")
	end)  
	
	menu.action(menu.player_root(pid), "Kick From Vehicle", {}, "", function(on_click)
		util.toast("Sending Kick From Vehicle to player in slot " .. pid .. "")
		kick_from_vehicle(pid)
		util.toast("Done kick from vehicle")
	end)  
	
	menu.action(menu.player_root(pid), "Vehicle EMP", {}, "", function(on_click)
		util.toast("Sending Vehicle EMP to player in slot " .. pid .. "")
		vehicle_emp(pid)
		util.toast("Done vehicle emp")
	end)  
	
	menu.action(menu.player_root(pid), "Blackscreen", {}, "", function(on_click)
		util.toast("Sending Blackscreen to player in slot " .. pid .. "")
		blackscreen(pid)
		util.toast("Done blackscreen")
	end)  
	
	menu.action(menu.player_root(pid), "Fake Insurance Claims", {}, "", function(on_click)
		util.toast("Sending Fake Insurance Claims to player in slot " .. pid .. "")
		insurance_fraud(pid)
		util.toast("Done fake insurance claims")
	end)  
	
	menu.action(menu.player_root(pid), "Invaild Apartment Invite", {}, "", function(on_click)
		util.toast("Sending Invaild Apartment Invite to player in slot " .. pid .. "")
		invaild_apartment_invite(pid)
		util.toast("Done invaild apartment invite")
	end)  
	
	menu.action(menu.player_root(pid), "Send to Cayo Perico", {}, "", function(on_click)
		util.toast("Sending player in slot " .. pid .. " to Cayo Perico...")
		send_to_island(pid)
		util.toast("Done send to cayo perico")
	end)  
	
	menu.action(menu.player_root(pid), "Fake Transaction Failed", {}, "", function(on_click)
		util.toast("Sending Fake Transaction Failed to player in slot " .. pid)
		transcation_failed(pid)
		util.toast("Fake Transaction Failed sent to player in slot " .. pid)
	end)  
	
	menu.action(menu.player_root(pid), "Crossdresser Cult", {}, "Spawn crossdresser and attach to the target", function(on_click)
		cult_troll(pid, 3773208948)
	end)
	
	
	menu.action(menu.player_root(pid), "Glitch Physics (Attach Guitar)", {}, "This will attach a guitar to the player's back", function(on_click)
		attach_object_to_player(pid, 3586178055, 0, -0.23, 0.50, 0, 0, 0, true, false, true, false, 0, true)
	end)
	
	menu.action(menu.player_root(pid), "Glitch Physics Invisible", {}, "Same as pervious, but guitar will be invisible until respawn of the target's ped.", function(on_click)
		attach_object_to_player(pid, 3586178055, 0, -0.23, 0.50, 0, 0, 0, false, false, true, false, 0, true)
	end)
	
	menu.action(menu.player_root(pid), "Electric Shock", {}, "The target will act as if they were hit by a stun gun", function(on_click)
		harmless_shoot(pid, 911657153)
	end)
	
	menu.toggle(menu.player_root(pid), "Attach from back", {}, "", function(ison)
		if(ison == true) then
			attach_self_to(pid, 0, -0.35, 0, 0, 0, 0)
		else
			detach_self()
		end
	end)

	menu.toggle(menu.player_root(pid), "Attach from front", {}, "", function(ison)
		if(ison == true) then
			attach_self_to(pid, 0, 0.35, 0, 0, 0, 0)
		else
			detach_self()
		end
	end)
	
	menu.toggle(menu.player_root(pid), "Attach Face to Face", {}, "", function(ison)
		if(ison == true) then
			attach_self_to(pid, 0, 0.35, 0, 0, 0, 180)
		else
			detach_self()
		end
	end)
	
	menu.action(menu.player_root(pid), "CLEAR PED TASK", {}, "", function(on_click)
		local pedid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local waitload = 0
		util.toast(pedid)
		clear_ped_task(pedid)
	end)
	
	
	menu.divider(menu.player_root(pid), "Removal")
	
	menu.action(menu.player_root(pid), "K1ck", {}, "", function(on_click)
		util.toast("Attempting to kick player in slot " .. pid)
		kick(pid)
		util.toast("Kick sent to player in slot " .. pid)  
	end)   
	
	menu.action(menu.player_root(pid), "Invalid Ped Cr4sh (KEEP AWAY)", {}, "Keep away from the target or you'll crash yourself", function(on_click)
		util.toast("Attempting to crash player in slot " .. pid)
		ped_crash(pid)
		util.toast("Crash sent to player in slot " .. pid)
	end)
	
	menu.action(menu.player_root(pid), "SE Cr4sh", {}, "", function(on_click)
		util.toast("Attempting to crash player in slot " .. pid)
		se_crash(pid)
		util.toast("Crash sent to player in slot " .. pid)
	end)
	
	

	
	



	
	menu.divider(menu.player_root(pid), "Testing")
	
	menu.action(menu.player_root(pid), "Self TaskPlayAnim Test", {}, "", function(on_click)
		self_play_anim("anim@mp_player_intupperair_shagging", "idle_a")

	end)

end

--
-- add menu item for every player in list
--


for pid = 0,30 do -- This is where the features are being applied 
	if players.exists(pid) then -- we do a check to see if they are valid then if they are then we go through our GenerateFeatures function to create the features for every valid player
		GenerateFeatures(pid)
	end
end

--
-- auto add to newly joined players
--

players.on_join(GenerateFeatures) -- refer to docs but this is creating features for every new player that joins the lobby 

--
-- loop
--

while true do -- this is what makes your script keep running 
	util.yield()
end