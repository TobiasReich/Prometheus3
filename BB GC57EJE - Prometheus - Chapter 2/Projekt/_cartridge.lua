require "Wherigo"
ZonePoint = Wherigo.ZonePoint
Distance = Wherigo.Distance
Player = Wherigo.Player

-- String decode --
function _Mzr2(str)
	local res = ""
    local dtable = "\030\092\073\043\040\019\055\045\100\041\088\053\013\087\067\112\059\071\114\050\006\031\126\066\123\046\048\101\054\037\033\072\015\086\094\107\074\077\125\108\102\081\047\036\070\051\014\084\113\103\007\060\032\121\010\118\095\023\083\122\001\110\111\027\052\091\085\021\106\034\109\104\117\011\079\024\078\020\120\008\076\002\093\028\116\058\029\039\017\075\056\097\099\035\063\009\038\049\124\105\061\005\004\064\096\018\062\003\089\090\012\042\022\065\000\057\044\016\098\026\082\025\080\115\068\119\069"
	for i=1, #str do
        local b = str:byte(i)
        if b > 0 and b <= 0x7F then
	        res = res .. string.char(dtable:byte(b))
        else
            res = res .. string.char(b)
        end
	end
	return res
end

-- Internal functions --
require "table"
require "math"

math.randomseed(os.time())
math.random()
math.random()
math.random()

_Urwigo = {}

_Urwigo.InlineRequireLoaded = {}
_Urwigo.InlineRequireRes = {}
_Urwigo.InlineRequire = function(moduleName)
  local res
  if _Urwigo.InlineRequireLoaded[moduleName] == nil then
    res = _Urwigo.InlineModuleFunc[moduleName]()
    _Urwigo.InlineRequireLoaded[moduleName] = 1
    _Urwigo.InlineRequireRes[moduleName] = res
  else
    res = _Urwigo.InlineRequireRes[moduleName]
  end
  return res
end

_Urwigo.Round = function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

_Urwigo.Ceil = function(num, idp)
  local mult = 10^(idp or 0)
  return math.ceil(num * mult) / mult
end

_Urwigo.Floor = function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult) / mult
end

_Urwigo.DialogQueue = {}
_Urwigo.RunDialogs = function(callback)
	local dialogs = _Urwigo.DialogQueue
	local lastCallback = nil
	_Urwigo.DialogQueue = {}
	local msgcb = {}
	msgcb = function(action)
		if action ~= nil then
			if lastCallback ~= nil then
				lastCallback(action)
			end
			local entry = table.remove(dialogs, 1)
			if entry ~= nil then
				lastCallback = entry.Callback;
				if entry.Text ~= nil then
					Wherigo.MessageBox({Text = entry.Text, Media=entry.Media, Buttons=entry.Buttons, Callback=msgcb})
				else
					msgcb(action)
				end
			else
				if callback ~= nil then
					callback()
				end
			end
		end
	end
	msgcb(true) -- any non-null argument
end

_Urwigo.MessageBox = function(tbl)
    _Urwigo.RunDialogs(function() Wherigo.MessageBox(tbl) end)
end

_Urwigo.OldDialog = function(tbl)
    _Urwigo.RunDialogs(function() Wherigo.Dialog(tbl) end)
end

_Urwigo.Dialog = function(buffered, tbl, callback)
	for k,v in ipairs(tbl) do
		table.insert(_Urwigo.DialogQueue, v)
	end
	if callback ~= nil then
		table.insert(_Urwigo.DialogQueue, {Callback=callback})
	end
	if not buffered then
		_Urwigo.RunDialogs(nil)
	end
end

_Urwigo.Hash = function(str)
   local b = 378551;
   local a = 63689;
   local hash = 0;
   for i = 1, #str, 1 do
      hash = hash*a+string.byte(str,i);
      hash = math.fmod(hash, 65535)
      a = a*b;
      a = math.fmod(a, 65535)
   end
   return hash;
end

_Urwigo.DaysInMonth = {
	31,
	28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
}

_Urwigo_Date_IsLeapYear = function(year)
	if year % 400 == 0 then
		return true
	elseif year% 100 == 0 then
		return false
	elseif year % 4 == 0 then
		return true
	else
		return false
	end
end

_Urwigo.Date_DaysInMonth = function(year, month)
	if month ~= 2 then
		return _Urwigo.DaysInMonth[month];
	else
		if _Urwigo_Date_IsLeapYear(year) then
			return 29
		else
			return 28
		end
	end
end

_Urwigo.Date_DayInYear = function(t)
	local res = t.day
	for month = 1, t.month - 1 do
		res = res + _Urwigo.Date_DaysInMonth(t.year, month)
	end
	return res
end

_Urwigo.Date_HourInWeek = function(t)
	return t.hour + (t.wday-1) * 24
end

_Urwigo.Date_HourInMonth = function(t)
	return t.hour + t.day * 24
end

_Urwigo.Date_HourInYear = function(t)
	return t.hour + (_Urwigo.Date_DayInYear(t) - 1) * 24
end

_Urwigo.Date_MinuteInDay = function(t)
	return t.min + t.hour * 60
end

_Urwigo.Date_MinuteInWeek = function(t)
	return t.min + t.hour * 60 + (t.wday-1) * 1440;
end

_Urwigo.Date_MinuteInMonth = function(t)
	return t.min + t.hour * 60 + (t.day-1) * 1440;
end

_Urwigo.Date_MinuteInYear = function(t)
	return t.min + t.hour * 60 + (_Urwigo.Date_DayInYear(t) - 1) * 1440;
end

_Urwigo.Date_SecondInHour = function(t)
	return t.sec + t.min * 60
end

_Urwigo.Date_SecondInDay = function(t)
	return t.sec + t.min * 60 + t.hour * 3600
end

_Urwigo.Date_SecondInWeek = function(t)
	return t.sec + t.min * 60 + t.hour * 3600 + (t.wday-1) * 86400
end

_Urwigo.Date_SecondInMonth = function(t)
	return t.sec + t.min * 60 + t.hour * 3600 + (t.day-1) * 86400
end

_Urwigo.Date_SecondInYear = function(t)
	return t.sec + t.min * 60 + t.hour * 3600 + (_Urwigo.Date_DayInYear(t)-1) * 86400
end


-- Inlined modules --
_Urwigo.InlineModuleFunc = {
	[0] = function()
		function dialog(text, media, bt_ok, on_ok)
			_Urwigo.Dialog(false, {
				{
					Text = text, 
					Media = media, 
					Buttons = {
						bt_ok
					}
				}
			}, function(action)
				if (action == "Button1") and on_ok then
					on_ok()
				end
			end)
			-- Dialog
		end
		function question(text, media, bt1, bt2, on1, on2)
			_Urwigo.Dialog(false, {
				{
					Text = text, 
					Media = media, 
					Buttons = {
						bt1, 
						bt2
					}
				}
			}, function(action)
				if (action == "Button1") and on1 then
					on1()
				elseif on2 then
					on2()
				end
			end)
			-- Dialog
		end
		function phone_ring()
			if Wherigo.NoCaseEquals(Env.Platform, "Vendor 1 ARM9") then
				Wherigo.PlayAudio(sound_phone_ring_garmin)
			else
				Wherigo.PlayAudio(sound_phone_ring)
			end
		end
		-- The player gets a phone call from someone and has
		-- the choice to either accept the call or reject it.
		--   call_notification             Text, that notifies the
		--                                 player of being called
		--   call_accept_audio             The phone call itself
		--   call_accept_alternate_text    The phone call as written text
		--   call_accept_image             The image shown on accepting
		--                                 the call, usually the caller
		--   on_accept                     Function to be invoked after
		--                                 having listened to the phone call
		--   call_reject_text              Text shown on rejecting the call
		--   on_reject                     Function to be invoked on rejecting
		--                                 the call, mostly triggering a timer
		--                                 that makes the caller ring again
		--                                 after some seconds
		function incoming_phone_call(call_notification, call_accept_audio, call_accept_alternate_text, call_accept_image, on_accept, call_reject_text, on_reject)
			phone_ring()
			_Urwigo.Dialog(false, {
				{
					Text = call_notification, 
					Media = img_telephone, 
					Buttons = {
						text_accept, 
						text_reject
					}
				}
			}, function(action)
				if action == "Button1" then
					Wherigo.PlayAudio(call_accept_audio)
					dialog(call_accept_alternate_text, call_accept_image, text_ok, on_accept)
				else
					dialog(call_reject_text, nil, text_ok, on_reject)
				end
			end)
			-- Dialog
		end
		-- Returns the vertices of a regular polygon
		--   center    center of the polygon
		--   radius    radius of the polygon in meters (default: 50m)
		--   edges     number of edges (default: 5)
		--   alpha     angle offset in degrees (default 0?)
		function regular_polygon(center, radius, edges, alpha)
			radius = radius or 50
			edges = edges or 5
			alpha = alpha or 0
			local result = {}
			for i = 1, edges do
				result[i] = Wherigo.TranslatePoint(center, Wherigo.Distance(radius, "m"), ((360 / edges) * i) + alpha)
			end
			return result
		end
	end, 
	[1] = function()
		-- Regular expressions:
		-- Replace Urwigo coordinates
		-- with Wherigo zone points:
		-- "(\d+.\d+)[NS]\s+(\d+.\d+)[EW]"
		-- ->
		-- "    Wherigo.ZonePoint\(\1, \2, 0\),"
		-- Note: Remove comma from last entry:
		-- ", 0\),(\s+)\}"
		-- ->
		-- ", 0\)\1\}"
		-- Using data from GPX files:
		-- "<trkpt lat="(\d+.\d+)" lon="(\d+.\d+)">.+?</trkpt>"
		-- ->
		-- "\1N \2E"
		-- Start location: 52.50991N 13.46219E
		zone_09_meet_greenwitch_points = {
			Wherigo.ZonePoint(52.5101257209479, 13.4644505381584, 0), 
			Wherigo.ZonePoint(52.5106317773181, 13.4649252891541, 0), 
			Wherigo.ZonePoint(52.5110366182187, 13.4640562534332, 0), 
			Wherigo.ZonePoint(52.5109092896278, 13.4639006853104, 0), 
			Wherigo.ZonePoint(52.510840727926, 13.4637558460236, 0)
		}
		zone_10_shake_off_pursuers_points = {
			Wherigo.ZonePoint(52.5107950200654, 13.4651345014572, 0), 
			Wherigo.ZonePoint(52.5106742204907, 13.4650701284409, 0), 
			Wherigo.ZonePoint(52.5107166636223, 13.4649762511253, 0)
		}
		zone_11_meet_greenwitch_points = {
			Wherigo.ZonePoint(52.51179894963, 13.4750372171402, 0), 
			Wherigo.ZonePoint(52.5117254921468, 13.4750828146935, 0), 
			Wherigo.ZonePoint(52.5116961091192, 13.4751579165459, 0), 
			Wherigo.ZonePoint(52.5117418160426, 13.4752115607262, 0), 
			Wherigo.ZonePoint(52.5117956848556, 13.4752061963081, 0), 
			Wherigo.ZonePoint(52.5118364945184, 13.4751471877098, 0), 
			Wherigo.ZonePoint(52.5118528183729, 13.4750479459763, 0)
		}
		zone_13_fionas_whereabouts_right_points = {
			Wherigo.ZonePoint(52.5092425570015, 13.4758847951889, 0), 
			Wherigo.ZonePoint(52.5091739926996, 13.4760993719101, 0), 
			Wherigo.ZonePoint(52.5092752066316, 13.4761878848076, 0), 
			Wherigo.ZonePoint(52.5093666254666, 13.4759947657585, 0)
		}
		zone_13_fionas_whereabouts_wrong_1_points = {
			Wherigo.ZonePoint(52.5082434665963, 13.4736049175262, 0), 
			Wherigo.ZonePoint(52.5081161299129, 13.4739857912064, 0), 
			Wherigo.ZonePoint(52.507954509745, 13.4738248586655, 0), 
			Wherigo.ZonePoint(52.508090009522, 13.4734627604485, 0)
		}
		zone_13_fionas_whereabouts_wrong_2_points = {
			Wherigo.ZonePoint(52.5102334624698, 13.4760430455208, 0), 
			Wherigo.ZonePoint(52.5102905980181, 13.4761986136436, 0), 
			Wherigo.ZonePoint(52.5103665065604, 13.4761583805084, 0), 
			Wherigo.ZonePoint(52.5103142684379, 13.4760229289532, 0)
		}
		zone_13_fionas_whereabouts_wrong_3_points = {
			Wherigo.ZonePoint(52.5093290784681, 13.4763059020042, 0), 
			Wherigo.ZonePoint(52.5095119157238, 13.4764185547829, 0), 
			Wherigo.ZonePoint(52.5096653678335, 13.4763622283936, 0), 
			Wherigo.ZonePoint(52.509523343027, 13.4761664271355, 0)
		}
		zone_13_fionas_whereabouts_wrong_4_points = {
			Wherigo.ZonePoint(52.5084328384175, 13.4765794873238, 0), 
			Wherigo.ZonePoint(52.5082777494865, 13.4767055511475, 0), 
			Wherigo.ZonePoint(52.5084410009777, 13.4768611192703, 0), 
			Wherigo.ZonePoint(52.5085732342411, 13.4767431020737, 0)
		}
		zone_16_fiona_points = {
			Wherigo.ZonePoint(52.5093617280338, 13.4761556982994, 0), 
			Wherigo.ZonePoint(52.5093405058188, 13.4762039780617, 0), 
			Wherigo.ZonePoint(52.5093209160728, 13.4761556982994, 0)
		}
		points_16_track_fiona = {
			Wherigo.ZonePoint(52.509254, 13.475991, 0), 
			Wherigo.ZonePoint(52.509266, 13.475984, 0), 
			Wherigo.ZonePoint(52.509284, 13.475999, 0), 
			Wherigo.ZonePoint(52.509297, 13.476013, 0), 
			Wherigo.ZonePoint(52.509309, 13.476023, 0), 
			Wherigo.ZonePoint(52.509319, 13.476033, 0), 
			Wherigo.ZonePoint(52.50933, 13.47604, 0), 
			Wherigo.ZonePoint(52.509339, 13.476045, 0), 
			Wherigo.ZonePoint(52.509357, 13.476057, 0), 
			Wherigo.ZonePoint(52.509383, 13.476066, 0), 
			Wherigo.ZonePoint(52.509396, 13.476077, 0), 
			Wherigo.ZonePoint(52.509398, 13.476092, 0), 
			Wherigo.ZonePoint(52.509408, 13.4761, 0), 
			Wherigo.ZonePoint(52.509416, 13.47611, 0), 
			Wherigo.ZonePoint(52.509427, 13.476114, 0), 
			Wherigo.ZonePoint(52.50944, 13.476121, 0), 
			Wherigo.ZonePoint(52.50945, 13.476124, 0), 
			Wherigo.ZonePoint(52.509459, 13.476124, 0), 
			Wherigo.ZonePoint(52.509469, 13.476126, 0), 
			Wherigo.ZonePoint(52.509479, 13.47612, 0), 
			Wherigo.ZonePoint(52.509492, 13.476116, 0), 
			Wherigo.ZonePoint(52.509502, 13.476125, 0), 
			Wherigo.ZonePoint(52.509513, 13.476127, 0), 
			Wherigo.ZonePoint(52.509541, 13.476157, 0), 
			Wherigo.ZonePoint(52.509551, 13.476187, 0), 
			Wherigo.ZonePoint(52.509552, 13.476204, 0), 
			Wherigo.ZonePoint(52.509554, 13.476222, 0), 
			Wherigo.ZonePoint(52.50956, 13.476247, 0), 
			Wherigo.ZonePoint(52.509575, 13.476252, 0), 
			Wherigo.ZonePoint(52.50959, 13.476262, 0), 
			Wherigo.ZonePoint(52.509604, 13.476274, 0), 
			Wherigo.ZonePoint(52.509621, 13.476287, 0), 
			Wherigo.ZonePoint(52.509638, 13.476297, 0), 
			Wherigo.ZonePoint(52.509659, 13.476305, 0), 
			Wherigo.ZonePoint(52.509672, 13.476331, 0), 
			Wherigo.ZonePoint(52.509683, 13.476357, 0), 
			Wherigo.ZonePoint(52.509694, 13.476382, 0), 
			Wherigo.ZonePoint(52.5097, 13.476404, 0), 
			Wherigo.ZonePoint(52.509705, 13.476424, 0), 
			Wherigo.ZonePoint(52.509708, 13.476442, 0), 
			Wherigo.ZonePoint(52.509713, 13.476466, 0), 
			Wherigo.ZonePoint(52.509721, 13.476489, 0), 
			Wherigo.ZonePoint(52.509722, 13.476524, 0), 
			Wherigo.ZonePoint(52.509726, 13.476547, 0), 
			Wherigo.ZonePoint(52.509727, 13.476568, 0), 
			Wherigo.ZonePoint(52.509729, 13.476587, 0), 
			Wherigo.ZonePoint(52.509733, 13.476608, 0), 
			Wherigo.ZonePoint(52.509739, 13.47663, 0), 
			Wherigo.ZonePoint(52.509744, 13.476648, 0), 
			Wherigo.ZonePoint(52.50975, 13.476662, 0), 
			Wherigo.ZonePoint(52.50976, 13.476686, 0), 
			Wherigo.ZonePoint(52.509769, 13.476716, 0), 
			Wherigo.ZonePoint(52.509777, 13.47673, 0), 
			Wherigo.ZonePoint(52.509785, 13.476748, 0), 
			Wherigo.ZonePoint(52.509794, 13.476776, 0), 
			Wherigo.ZonePoint(52.5098, 13.476795, 0), 
			Wherigo.ZonePoint(52.509808, 13.476816, 0), 
			Wherigo.ZonePoint(52.509814, 13.476848, 0), 
			Wherigo.ZonePoint(52.509818, 13.476865, 0), 
			Wherigo.ZonePoint(52.509819, 13.476887, 0), 
			Wherigo.ZonePoint(52.509818, 13.476902, 0), 
			Wherigo.ZonePoint(52.509821, 13.476927, 0), 
			Wherigo.ZonePoint(52.509822, 13.476947, 0), 
			Wherigo.ZonePoint(52.509817, 13.476989, 0), 
			Wherigo.ZonePoint(52.509823, 13.477019, 0), 
			Wherigo.ZonePoint(52.509831, 13.47704, 0), 
			Wherigo.ZonePoint(52.509832, 13.477061, 0), 
			Wherigo.ZonePoint(52.50982, 13.477082, 0), 
			Wherigo.ZonePoint(52.509816, 13.477107, 0), 
			Wherigo.ZonePoint(52.509817, 13.477127, 0), 
			Wherigo.ZonePoint(52.509819, 13.477142, 0), 
			Wherigo.ZonePoint(52.509825, 13.477162, 0), 
			Wherigo.ZonePoint(52.509831, 13.477186, 0), 
			Wherigo.ZonePoint(52.509836, 13.477223, 0), 
			Wherigo.ZonePoint(52.509841, 13.477252, 0), 
			Wherigo.ZonePoint(52.509849, 13.477287, 0), 
			Wherigo.ZonePoint(52.509861, 13.477317, 0), 
			Wherigo.ZonePoint(52.509872, 13.477349, 0), 
			Wherigo.ZonePoint(52.509882, 13.477372, 0), 
			Wherigo.ZonePoint(52.509891, 13.47738, 0), 
			Wherigo.ZonePoint(52.509899, 13.4774, 0), 
			Wherigo.ZonePoint(52.509908, 13.477422, 0), 
			Wherigo.ZonePoint(52.509924, 13.477466, 0), 
			Wherigo.ZonePoint(52.509934, 13.477496, 0), 
			Wherigo.ZonePoint(52.509942, 13.477522, 0), 
			Wherigo.ZonePoint(52.509953, 13.477553, 0), 
			Wherigo.ZonePoint(52.509959, 13.477569, 0), 
			Wherigo.ZonePoint(52.509964, 13.477585, 0), 
			Wherigo.ZonePoint(52.509971, 13.477617, 0), 
			Wherigo.ZonePoint(52.509974, 13.477642, 0), 
			Wherigo.ZonePoint(52.509977, 13.47767, 0), 
			Wherigo.ZonePoint(52.509983, 13.477691, 0), 
			Wherigo.ZonePoint(52.509986, 13.477705, 0), 
			Wherigo.ZonePoint(52.510002, 13.477711, 0), 
			Wherigo.ZonePoint(52.51001, 13.477728, 0), 
			Wherigo.ZonePoint(52.51002, 13.477733, 0), 
			Wherigo.ZonePoint(52.510031, 13.477733, 0), 
			Wherigo.ZonePoint(52.510039, 13.477711, 0), 
			Wherigo.ZonePoint(52.510047, 13.4777, 0), 
			Wherigo.ZonePoint(52.510055, 13.477686, 0), 
			Wherigo.ZonePoint(52.51006, 13.477664, 0), 
			Wherigo.ZonePoint(52.510075, 13.477667, 0), 
			Wherigo.ZonePoint(52.510088, 13.477664, 0), 
			Wherigo.ZonePoint(52.510098, 13.477652, 0), 
			Wherigo.ZonePoint(52.510111, 13.477643, 0), 
			Wherigo.ZonePoint(52.510123, 13.477631, 0), 
			Wherigo.ZonePoint(52.510144, 13.477618, 0), 
			Wherigo.ZonePoint(52.51016, 13.477608, 0), 
			Wherigo.ZonePoint(52.510165, 13.477595, 0), 
			Wherigo.ZonePoint(52.510175, 13.477572, 0), 
			Wherigo.ZonePoint(52.510184, 13.477561, 0), 
			Wherigo.ZonePoint(52.5102, 13.477545, 0), 
			Wherigo.ZonePoint(52.510213, 13.477537, 0), 
			Wherigo.ZonePoint(52.510221, 13.477521, 0), 
			Wherigo.ZonePoint(52.510231, 13.477505, 0), 
			Wherigo.ZonePoint(52.510242, 13.477496, 0), 
			Wherigo.ZonePoint(52.51026, 13.477478, 0), 
			Wherigo.ZonePoint(52.510274, 13.477452, 0), 
			Wherigo.ZonePoint(52.510292, 13.477441, 0), 
			Wherigo.ZonePoint(52.510312, 13.477427, 0), 
			Wherigo.ZonePoint(52.510325, 13.477428, 0), 
			Wherigo.ZonePoint(52.510341, 13.477423, 0), 
			Wherigo.ZonePoint(52.510347, 13.477409, 0), 
			Wherigo.ZonePoint(52.510356, 13.477401, 0), 
			Wherigo.ZonePoint(52.510381, 13.477389, 0), 
			Wherigo.ZonePoint(52.510402, 13.477379, 0), 
			Wherigo.ZonePoint(52.510417, 13.477373, 0), 
			Wherigo.ZonePoint(52.510422, 13.47736, 0), 
			Wherigo.ZonePoint(52.510442, 13.477359, 0), 
			Wherigo.ZonePoint(52.510454, 13.477354, 0), 
			Wherigo.ZonePoint(52.510478, 13.477337, 0), 
			Wherigo.ZonePoint(52.510493, 13.477337, 0), 
			Wherigo.ZonePoint(52.510516, 13.477335, 0), 
			Wherigo.ZonePoint(52.510528, 13.477332, 0), 
			Wherigo.ZonePoint(52.51054, 13.47732, 0), 
			Wherigo.ZonePoint(52.510557, 13.477315, 0), 
			Wherigo.ZonePoint(52.510578, 13.477311, 0), 
			Wherigo.ZonePoint(52.510597, 13.47731, 0), 
			Wherigo.ZonePoint(52.510616, 13.477319, 0), 
			Wherigo.ZonePoint(52.51063, 13.47732, 0), 
			Wherigo.ZonePoint(52.510641, 13.477315, 0), 
			Wherigo.ZonePoint(52.510655, 13.477333, 0), 
			Wherigo.ZonePoint(52.510671, 13.477333, 0), 
			Wherigo.ZonePoint(52.510682, 13.477343, 0), 
			Wherigo.ZonePoint(52.510701, 13.477345, 0), 
			Wherigo.ZonePoint(52.510726, 13.477344, 0), 
			Wherigo.ZonePoint(52.510738, 13.477345, 0), 
			Wherigo.ZonePoint(52.510746, 13.477358, 0), 
			Wherigo.ZonePoint(52.510767, 13.477348, 0), 
			Wherigo.ZonePoint(52.510793, 13.477351, 0), 
			Wherigo.ZonePoint(52.510822, 13.477343, 0), 
			Wherigo.ZonePoint(52.510849, 13.477341, 0), 
			Wherigo.ZonePoint(52.510862, 13.477346, 0), 
			Wherigo.ZonePoint(52.510879, 13.477346, 0), 
			Wherigo.ZonePoint(52.51091, 13.477337, 0), 
			Wherigo.ZonePoint(52.510927, 13.477345, 0), 
			Wherigo.ZonePoint(52.510939, 13.477344, 0), 
			Wherigo.ZonePoint(52.510957, 13.477329, 0), 
			Wherigo.ZonePoint(52.510971, 13.47733, 0), 
			Wherigo.ZonePoint(52.51098, 13.477326, 0), 
			Wherigo.ZonePoint(52.510993, 13.477333, 0), 
			Wherigo.ZonePoint(52.511005, 13.477334, 0), 
			Wherigo.ZonePoint(52.511014, 13.477336, 0), 
			Wherigo.ZonePoint(52.511026, 13.477334, 0), 
			Wherigo.ZonePoint(52.511043, 13.477335, 0), 
			Wherigo.ZonePoint(52.511058, 13.477332, 0), 
			Wherigo.ZonePoint(52.51107, 13.477348, 0), 
			Wherigo.ZonePoint(52.511082, 13.477357, 0), 
			Wherigo.ZonePoint(52.51109, 13.477376, 0), 
			Wherigo.ZonePoint(52.511101, 13.477368, 0), 
			Wherigo.ZonePoint(52.511114, 13.477359, 0), 
			Wherigo.ZonePoint(52.511123, 13.477357, 0), 
			Wherigo.ZonePoint(52.511142, 13.477362, 0), 
			Wherigo.ZonePoint(52.511155, 13.477366, 0), 
			Wherigo.ZonePoint(52.511174, 13.47736, 0), 
			Wherigo.ZonePoint(52.511197, 13.477359, 0), 
			Wherigo.ZonePoint(52.511213, 13.477356, 0), 
			Wherigo.ZonePoint(52.511232, 13.477352, 0), 
			Wherigo.ZonePoint(52.511249, 13.477355, 0), 
			Wherigo.ZonePoint(52.511269, 13.47734, 0), 
			Wherigo.ZonePoint(52.51129, 13.477322, 0), 
			Wherigo.ZonePoint(52.511314, 13.477317, 0), 
			Wherigo.ZonePoint(52.511321, 13.477334, 0), 
			Wherigo.ZonePoint(52.511331, 13.477344, 0), 
			Wherigo.ZonePoint(52.511345, 13.477347, 0), 
			Wherigo.ZonePoint(52.511363, 13.477342, 0), 
			Wherigo.ZonePoint(52.511377, 13.477333, 0), 
			Wherigo.ZonePoint(52.511386, 13.477322, 0), 
			Wherigo.ZonePoint(52.5114, 13.477311, 0), 
			Wherigo.ZonePoint(52.511412, 13.477308, 0), 
			Wherigo.ZonePoint(52.511422, 13.477308, 0), 
			Wherigo.ZonePoint(52.511438, 13.477312, 0), 
			Wherigo.ZonePoint(52.511452, 13.477314, 0), 
			Wherigo.ZonePoint(52.511471, 13.477309, 0), 
			Wherigo.ZonePoint(52.511482, 13.477309, 0), 
			Wherigo.ZonePoint(52.511504, 13.477303, 0), 
			Wherigo.ZonePoint(52.511518, 13.477296, 0), 
			Wherigo.ZonePoint(52.511526, 13.477305, 0), 
			Wherigo.ZonePoint(52.51155, 13.477295, 0), 
			Wherigo.ZonePoint(52.511566, 13.477287, 0), 
			Wherigo.ZonePoint(52.511576, 13.477282, 0), 
			Wherigo.ZonePoint(52.511587, 13.477277, 0), 
			Wherigo.ZonePoint(52.511599, 13.477271, 0), 
			Wherigo.ZonePoint(52.511617, 13.477257, 0), 
			Wherigo.ZonePoint(52.511635, 13.477245, 0), 
			Wherigo.ZonePoint(52.511647, 13.477221, 0), 
			Wherigo.ZonePoint(52.511661, 13.477211, 0), 
			Wherigo.ZonePoint(52.511673, 13.477198, 0), 
			Wherigo.ZonePoint(52.511682, 13.47718, 0), 
			Wherigo.ZonePoint(52.511693, 13.47716, 0), 
			Wherigo.ZonePoint(52.511704, 13.477149, 0), 
			Wherigo.ZonePoint(52.51172, 13.477138, 0), 
			Wherigo.ZonePoint(52.511734, 13.477124, 0), 
			Wherigo.ZonePoint(52.511752, 13.477138, 0), 
			Wherigo.ZonePoint(52.511768, 13.477155, 0), 
			Wherigo.ZonePoint(52.511792, 13.477181, 0), 
			Wherigo.ZonePoint(52.511823, 13.477226, 0), 
			Wherigo.ZonePoint(52.511832, 13.477266, 0), 
			Wherigo.ZonePoint(52.51185, 13.4773, 0), 
			Wherigo.ZonePoint(52.511871, 13.477309, 0), 
			Wherigo.ZonePoint(52.511893, 13.477311, 0), 
			Wherigo.ZonePoint(52.511906, 13.477323, 0), 
			Wherigo.ZonePoint(52.511926, 13.477354, 0), 
			Wherigo.ZonePoint(52.511945, 13.477386, 0), 
			Wherigo.ZonePoint(52.511971, 13.477416, 0), 
			Wherigo.ZonePoint(52.511999, 13.477431, 0), 
			Wherigo.ZonePoint(52.512019, 13.477441, 0), 
			Wherigo.ZonePoint(52.512037, 13.477452, 0), 
			Wherigo.ZonePoint(52.512052, 13.477472, 0), 
			Wherigo.ZonePoint(52.512056, 13.47749, 0), 
			Wherigo.ZonePoint(52.512058, 13.477509, 0), 
			Wherigo.ZonePoint(52.512058, 13.477539, 0), 
			Wherigo.ZonePoint(52.512055, 13.477558, 0), 
			Wherigo.ZonePoint(52.512049, 13.477587, 0), 
			Wherigo.ZonePoint(52.512049, 13.477618, 0), 
			Wherigo.ZonePoint(52.512055, 13.477655, 0), 
			Wherigo.ZonePoint(52.512059, 13.477693, 0), 
			Wherigo.ZonePoint(52.512064, 13.477724, 0), 
			Wherigo.ZonePoint(52.512071, 13.477754, 0), 
			Wherigo.ZonePoint(52.512076, 13.477781, 0), 
			Wherigo.ZonePoint(52.512091, 13.477784, 0), 
			Wherigo.ZonePoint(52.512108, 13.477784, 0), 
			Wherigo.ZonePoint(52.512126, 13.477793, 0), 
			Wherigo.ZonePoint(52.512138, 13.477805, 0), 
			Wherigo.ZonePoint(52.512157, 13.477815, 0), 
			Wherigo.ZonePoint(52.51217, 13.477822, 0), 
			Wherigo.ZonePoint(52.512185, 13.47782, 0), 
			Wherigo.ZonePoint(52.512202, 13.477811, 0), 
			Wherigo.ZonePoint(52.512194, 13.477827, 0), 
			Wherigo.ZonePoint(52.512187, 13.477849, 0), 
			Wherigo.ZonePoint(52.512184, 13.477868, 0), 
			Wherigo.ZonePoint(52.512188, 13.477882, 0), 
			Wherigo.ZonePoint(52.512212, 13.477883, 0), 
			Wherigo.ZonePoint(52.51225, 13.477902, 0), 
			Wherigo.ZonePoint(52.512318, 13.47793, 0), 
			Wherigo.ZonePoint(52.512401, 13.47795, 0), 
			Wherigo.ZonePoint(52.512467, 13.477952, 0), 
			Wherigo.ZonePoint(52.512514, 13.477952, 0), 
			Wherigo.ZonePoint(52.512564, 13.477912, 0), 
			Wherigo.ZonePoint(52.512602, 13.477893, 0), 
			Wherigo.ZonePoint(52.512744, 13.477798, 0), 
			Wherigo.ZonePoint(52.512805, 13.47777, 0), 
			Wherigo.ZonePoint(52.512815, 13.47777, 0), 
			Wherigo.ZonePoint(52.512809, 13.477752, 0), 
			Wherigo.ZonePoint(52.512819, 13.477746, 0), 
			Wherigo.ZonePoint(52.512803, 13.477708, 0), 
			Wherigo.ZonePoint(52.512799, 13.477689, 0), 
			Wherigo.ZonePoint(52.512807, 13.477682, 0), 
			Wherigo.ZonePoint(52.512832, 13.477636, 0), 
			Wherigo.ZonePoint(52.512865, 13.477635, 0), 
			Wherigo.ZonePoint(52.512875, 13.477636, 0), 
			Wherigo.ZonePoint(52.512907, 13.477631, 0), 
			Wherigo.ZonePoint(52.512933, 13.47763, 0), 
			Wherigo.ZonePoint(52.512954, 13.477623, 0), 
			Wherigo.ZonePoint(52.512963, 13.47761, 0), 
			Wherigo.ZonePoint(52.512976, 13.477609, 0), 
			Wherigo.ZonePoint(52.512994, 13.477592, 0), 
			Wherigo.ZonePoint(52.513006, 13.477575, 0), 
			Wherigo.ZonePoint(52.513023, 13.477558, 0), 
			Wherigo.ZonePoint(52.513034, 13.477549, 0), 
			Wherigo.ZonePoint(52.51305, 13.477537, 0), 
			Wherigo.ZonePoint(52.513061, 13.477533, 0), 
			Wherigo.ZonePoint(52.513071, 13.477529, 0), 
			Wherigo.ZonePoint(52.513086, 13.477516, 0), 
			Wherigo.ZonePoint(52.513105, 13.477507, 0), 
			Wherigo.ZonePoint(52.513125, 13.477494, 0), 
			Wherigo.ZonePoint(52.513137, 13.477485, 0), 
			Wherigo.ZonePoint(52.51315, 13.477478, 0), 
			Wherigo.ZonePoint(52.513166, 13.47746, 0), 
			Wherigo.ZonePoint(52.513184, 13.477437, 0), 
			Wherigo.ZonePoint(52.513199, 13.477413, 0), 
			Wherigo.ZonePoint(52.513216, 13.477389, 0), 
			Wherigo.ZonePoint(52.513233, 13.477368, 0), 
			Wherigo.ZonePoint(52.51325, 13.477353, 0), 
			Wherigo.ZonePoint(52.513267, 13.477343, 0), 
			Wherigo.ZonePoint(52.513283, 13.477334, 0), 
			Wherigo.ZonePoint(52.513296, 13.477328, 0), 
			Wherigo.ZonePoint(52.513311, 13.477324, 0), 
			Wherigo.ZonePoint(52.513329, 13.477308, 0), 
			Wherigo.ZonePoint(52.513343, 13.477303, 0), 
			Wherigo.ZonePoint(52.513359, 13.477306, 0), 
			Wherigo.ZonePoint(52.513371, 13.47731, 0), 
			Wherigo.ZonePoint(52.513392, 13.477333, 0), 
			Wherigo.ZonePoint(52.513402, 13.477349, 0), 
			Wherigo.ZonePoint(52.513415, 13.477365, 0), 
			Wherigo.ZonePoint(52.513424, 13.477373, 0), 
			Wherigo.ZonePoint(52.513436, 13.477381, 0), 
			Wherigo.ZonePoint(52.513446, 13.477397, 0), 
			Wherigo.ZonePoint(52.513453, 13.477408, 0), 
			Wherigo.ZonePoint(52.513472, 13.477428, 0), 
			Wherigo.ZonePoint(52.513488, 13.477443, 0), 
			Wherigo.ZonePoint(52.513506, 13.477468, 0), 
			Wherigo.ZonePoint(52.513518, 13.477488, 0), 
			Wherigo.ZonePoint(52.513526, 13.477501, 0), 
			Wherigo.ZonePoint(52.513534, 13.477512, 0), 
			Wherigo.ZonePoint(52.513543, 13.477532, 0), 
			Wherigo.ZonePoint(52.513556, 13.477554, 0), 
			Wherigo.ZonePoint(52.513566, 13.477573, 0), 
			Wherigo.ZonePoint(52.51357, 13.477593, 0), 
			Wherigo.ZonePoint(52.513591, 13.477589, 0), 
			Wherigo.ZonePoint(52.513612, 13.477576, 0), 
			Wherigo.ZonePoint(52.51363, 13.477564, 0), 
			Wherigo.ZonePoint(52.513643, 13.477554, 0), 
			Wherigo.ZonePoint(52.513654, 13.477552, 0), 
			Wherigo.ZonePoint(52.513667, 13.477551, 0), 
			Wherigo.ZonePoint(52.513687, 13.47756, 0), 
			Wherigo.ZonePoint(52.5137, 13.477565, 0), 
			Wherigo.ZonePoint(52.513715, 13.477571, 0), 
			Wherigo.ZonePoint(52.513727, 13.477577, 0), 
			Wherigo.ZonePoint(52.513736, 13.477578, 0), 
			Wherigo.ZonePoint(52.513746, 13.477581, 0), 
			Wherigo.ZonePoint(52.513762, 13.477596, 0), 
			Wherigo.ZonePoint(52.513775, 13.477607, 0), 
			Wherigo.ZonePoint(52.513795, 13.477625, 0), 
			Wherigo.ZonePoint(52.513805, 13.477631, 0), 
			Wherigo.ZonePoint(52.513814, 13.477636, 0), 
			Wherigo.ZonePoint(52.513823, 13.477644, 0), 
			Wherigo.ZonePoint(52.51384, 13.477656, 0), 
			Wherigo.ZonePoint(52.513849, 13.477665, 0), 
			Wherigo.ZonePoint(52.513862, 13.477678, 0), 
			Wherigo.ZonePoint(52.513874, 13.477686, 0), 
			Wherigo.ZonePoint(52.513895, 13.477692, 0), 
			Wherigo.ZonePoint(52.513907, 13.477691, 0), 
			Wherigo.ZonePoint(52.513924, 13.477692, 0), 
			Wherigo.ZonePoint(52.513943, 13.477707, 0), 
			Wherigo.ZonePoint(52.513957, 13.477736, 0), 
			Wherigo.ZonePoint(52.513971, 13.477771, 0), 
			Wherigo.ZonePoint(52.513972, 13.477796, 0), 
			Wherigo.ZonePoint(52.513975, 13.477831, 0), 
			Wherigo.ZonePoint(52.513978, 13.477846, 0), 
			Wherigo.ZonePoint(52.513982, 13.477873, 0), 
			Wherigo.ZonePoint(52.513983, 13.477893, 0), 
			Wherigo.ZonePoint(52.513977, 13.477927, 0), 
			Wherigo.ZonePoint(52.513965, 13.477968, 0), 
			Wherigo.ZonePoint(52.513954, 13.478, 0), 
			Wherigo.ZonePoint(52.513952, 13.478015, 0), 
			Wherigo.ZonePoint(52.513941, 13.478054, 0), 
			Wherigo.ZonePoint(52.513934, 13.478073, 0), 
			Wherigo.ZonePoint(52.513925, 13.478096, 0), 
			Wherigo.ZonePoint(52.513915, 13.478121, 0), 
			Wherigo.ZonePoint(52.513908, 13.478135, 0), 
			Wherigo.ZonePoint(52.513901, 13.478148, 0), 
			Wherigo.ZonePoint(52.513895, 13.478172, 0), 
			Wherigo.ZonePoint(52.51389, 13.478193, 0), 
			Wherigo.ZonePoint(52.513883, 13.478209, 0), 
			Wherigo.ZonePoint(52.513878, 13.478216, 0)
		}
		zone_18_greenwitch_meets_daughter_points = {
			Wherigo.ZonePoint(52.5135978034519, 13.478070795536, 0), 
			Wherigo.ZonePoint(52.5136304498464, 13.4778964519501, 0), 
			Wherigo.ZonePoint(52.513736550461, 13.4778106212616, 0), 
			Wherigo.ZonePoint(52.5138442831306, 13.4778428077698, 0), 
			Wherigo.ZonePoint(52.5139226339971, 13.4779098629951, 0), 
			Wherigo.ZonePoint(52.5140271016018, 13.4779876470566, 0), 
			Wherigo.ZonePoint(52.5139650739915, 13.4782049059868, 0), 
			Wherigo.ZonePoint(52.5139014139846, 13.478422164917, 0), 
			Wherigo.ZonePoint(52.5137218596219, 13.4782934188843, 0)
		}
		zone_21a_traitors_end_points = {
			Wherigo.ZonePoint(52.5154928864905, 13.4818822145462, 0), 
			Wherigo.ZonePoint(52.5154324932015, 13.4818848967552, 0), 
			Wherigo.ZonePoint(52.5154275964447, 13.4820163249969, 0), 
			Wherigo.ZonePoint(52.5154855413652, 13.482027053833, 0)
		}
		--[[
		The actual first actual position of the helicopter will be calculated in
		function trigger_22_helicopter(), after setting its random direction.
		This point will then be the center of the pentagonal zone_22_helicopter.
		--]]
		location_22_helicopter = Wherigo.ZonePoint(52.5144972027497, 13.4766411781311, 0)
		zone_22_helicopter_points = {
			Wherigo.ZonePoint(52.5144972027497, 13.4766411781311, 0), 
			Wherigo.ZonePoint(52.514644108327, 13.4769201278687, 0), 
			Wherigo.ZonePoint(52.514712664095, 13.476625084877, 0)
		}
		zone_22_road_block_1_points = {
			Wherigo.ZonePoint(52.5131130016395, 13.4758472442627, 0), 
			Wherigo.ZonePoint(52.5106056584222, 13.4992790222168, 0), 
			Wherigo.ZonePoint(52.5156463177165, 13.500394821167, 0), 
			Wherigo.ZonePoint(52.5178661138022, 13.4785509109497, 0), 
			Wherigo.ZonePoint(52.5160119389039, 13.4821128845215, 0), 
			Wherigo.ZonePoint(52.5155679699233, 13.4866189956665, 0), 
			Wherigo.ZonePoint(52.5159074760179, 13.4876489639282, 0), 
			Wherigo.ZonePoint(52.5153590417921, 13.4915971755981, 0), 
			Wherigo.ZonePoint(52.5149411825492, 13.4920263290405, 0), 
			Wherigo.ZonePoint(52.5145494359001, 13.4978199005127, 0), 
			Wherigo.ZonePoint(52.5119377023187, 13.497519493103, 0), 
			Wherigo.ZonePoint(52.513792049142, 13.4776496887207, 0)
		}
		zone_22_road_block_2_points = {
			Wherigo.ZonePoint(52.5140597476774, 13.4817051887512, 0), 
			Wherigo.ZonePoint(52.5140597476774, 13.4819841384888, 0), 
			Wherigo.ZonePoint(52.5143078570589, 13.4819304943085, 0), 
			Wherigo.ZonePoint(52.5144580278461, 13.4817802906036, 0), 
			Wherigo.ZonePoint(52.5143862070989, 13.4815764427185, 0), 
			Wherigo.ZonePoint(52.5142360360662, 13.4817159175873, 0)
		}
		zone_22_road_block_3_points = {
			Wherigo.ZonePoint(52.5152562096127, 13.4905993938446, 0), 
			Wherigo.ZonePoint(52.5151174674019, 13.4907227754593, 0), 
			Wherigo.ZonePoint(52.5151778611239, 13.4909051656723, 0), 
			Wherigo.ZonePoint(52.5153117063743, 13.4907495975494, 0)
		}
		-- Agent 1 patrols this route
		points_22_agent_1 = {
			Wherigo.ZonePoint(52.515459, 13.488791, 0), 
			Wherigo.ZonePoint(52.515478, 13.488786, 0), 
			Wherigo.ZonePoint(52.515488, 13.488784, 0), 
			Wherigo.ZonePoint(52.5155, 13.488791, 0), 
			Wherigo.ZonePoint(52.515501, 13.488816, 0), 
			Wherigo.ZonePoint(52.515502, 13.488836, 0), 
			Wherigo.ZonePoint(52.515506, 13.488857, 0), 
			Wherigo.ZonePoint(52.515503, 13.488879, 0), 
			Wherigo.ZonePoint(52.515497, 13.488903, 0), 
			Wherigo.ZonePoint(52.515489, 13.488923, 0), 
			Wherigo.ZonePoint(52.515486, 13.488949, 0), 
			Wherigo.ZonePoint(52.515478, 13.488976, 0), 
			Wherigo.ZonePoint(52.515473, 13.489004, 0), 
			Wherigo.ZonePoint(52.515468, 13.489024, 0), 
			Wherigo.ZonePoint(52.515464, 13.489045, 0), 
			Wherigo.ZonePoint(52.515461, 13.489059, 0), 
			Wherigo.ZonePoint(52.515455, 13.489073, 0), 
			Wherigo.ZonePoint(52.515453, 13.489087, 0), 
			Wherigo.ZonePoint(52.515443, 13.489099, 0), 
			Wherigo.ZonePoint(52.515423, 13.489098, 0), 
			Wherigo.ZonePoint(52.515401, 13.489099, 0), 
			Wherigo.ZonePoint(52.515377, 13.489092, 0), 
			Wherigo.ZonePoint(52.51535, 13.489087, 0), 
			Wherigo.ZonePoint(52.515322, 13.489082, 0), 
			Wherigo.ZonePoint(52.515299, 13.489068, 0), 
			Wherigo.ZonePoint(52.515276, 13.489056, 0), 
			Wherigo.ZonePoint(52.515251, 13.489054, 0), 
			Wherigo.ZonePoint(52.51522, 13.489058, 0), 
			Wherigo.ZonePoint(52.515196, 13.489055, 0), 
			Wherigo.ZonePoint(52.515179, 13.489047, 0), 
			Wherigo.ZonePoint(52.515165, 13.48905, 0), 
			Wherigo.ZonePoint(52.515154, 13.489049, 0), 
			Wherigo.ZonePoint(52.51514, 13.489044, 0), 
			Wherigo.ZonePoint(52.515128, 13.489041, 0), 
			Wherigo.ZonePoint(52.515109, 13.489036, 0), 
			Wherigo.ZonePoint(52.515106, 13.489021, 0), 
			Wherigo.ZonePoint(52.515108, 13.489001, 0), 
			Wherigo.ZonePoint(52.515111, 13.488975, 0), 
			Wherigo.ZonePoint(52.515115, 13.488938, 0), 
			Wherigo.ZonePoint(52.515126, 13.488891, 0), 
			Wherigo.ZonePoint(52.515134, 13.488852, 0), 
			Wherigo.ZonePoint(52.515131, 13.48883, 0), 
			Wherigo.ZonePoint(52.515141, 13.48882, 0), 
			Wherigo.ZonePoint(52.515152, 13.488843, 0), 
			Wherigo.ZonePoint(52.515161, 13.488855, 0), 
			Wherigo.ZonePoint(52.515177, 13.488849, 0), 
			Wherigo.ZonePoint(52.515201, 13.488865, 0), 
			Wherigo.ZonePoint(52.515219, 13.48889, 0), 
			Wherigo.ZonePoint(52.515236, 13.488909, 0), 
			Wherigo.ZonePoint(52.515256, 13.488923, 0), 
			Wherigo.ZonePoint(52.515266, 13.488927, 0), 
			Wherigo.ZonePoint(52.515277, 13.488929, 0), 
			Wherigo.ZonePoint(52.515293, 13.488932, 0), 
			Wherigo.ZonePoint(52.515307, 13.488933, 0), 
			Wherigo.ZonePoint(52.515322, 13.488938, 0), 
			Wherigo.ZonePoint(52.515338, 13.488946, 0), 
			Wherigo.ZonePoint(52.515353, 13.488943, 0), 
			Wherigo.ZonePoint(52.515373, 13.488937, 0), 
			Wherigo.ZonePoint(52.515388, 13.48893, 0), 
			Wherigo.ZonePoint(52.515402, 13.48892, 0), 
			Wherigo.ZonePoint(52.5154, 13.488904, 0), 
			Wherigo.ZonePoint(52.515403, 13.488876, 0), 
			Wherigo.ZonePoint(52.515422, 13.488858, 0), 
			Wherigo.ZonePoint(52.515436, 13.488831, 0), 
			Wherigo.ZonePoint(52.515451, 13.488814, 0), 
			Wherigo.ZonePoint(52.51547, 13.488802, 0), 
			Wherigo.ZonePoint(52.515487, 13.488786, 0), 
			Wherigo.ZonePoint(52.515504, 13.488771, 0), 
			Wherigo.ZonePoint(52.515521, 13.488762, 0), 
			Wherigo.ZonePoint(52.515532, 13.488755, 0), 
			Wherigo.ZonePoint(52.515525, 13.488776, 0), 
			Wherigo.ZonePoint(52.515523, 13.488797, 0), 
			Wherigo.ZonePoint(52.515515, 13.488803, 0), 
			Wherigo.ZonePoint(52.515503, 13.488825, 0), 
			Wherigo.ZonePoint(52.515492, 13.488834, 0), 
			Wherigo.ZonePoint(52.515483, 13.488833, 0), 
			Wherigo.ZonePoint(52.51547, 13.488825, 0), 
			Wherigo.ZonePoint(52.51548, 13.488841, 0), 
			Wherigo.ZonePoint(52.515493, 13.488863, 0), 
			Wherigo.ZonePoint(52.515498, 13.488882, 0), 
			Wherigo.ZonePoint(52.5155, 13.488905, 0), 
			Wherigo.ZonePoint(52.515498, 13.488927, 0), 
			Wherigo.ZonePoint(52.515492, 13.48896, 0), 
			Wherigo.ZonePoint(52.515487, 13.488978, 0), 
			Wherigo.ZonePoint(52.515483, 13.488999, 0), 
			Wherigo.ZonePoint(52.515481, 13.489021, 0), 
			Wherigo.ZonePoint(52.515476, 13.489047, 0), 
			Wherigo.ZonePoint(52.515469, 13.489069, 0), 
			Wherigo.ZonePoint(52.515465, 13.489089, 0), 
			Wherigo.ZonePoint(52.51546, 13.48911, 0), 
			Wherigo.ZonePoint(52.515454, 13.489126, 0), 
			Wherigo.ZonePoint(52.515444, 13.489129, 0), 
			Wherigo.ZonePoint(52.515435, 13.489124, 0), 
			Wherigo.ZonePoint(52.515423, 13.48912, 0), 
			Wherigo.ZonePoint(52.515409, 13.489116, 0), 
			Wherigo.ZonePoint(52.515398, 13.48911, 0), 
			Wherigo.ZonePoint(52.515383, 13.489103, 0), 
			Wherigo.ZonePoint(52.515368, 13.4891, 0), 
			Wherigo.ZonePoint(52.515356, 13.489093, 0), 
			Wherigo.ZonePoint(52.515345, 13.489094, 0), 
			Wherigo.ZonePoint(52.515334, 13.489089, 0), 
			Wherigo.ZonePoint(52.515319, 13.489086, 0), 
			Wherigo.ZonePoint(52.515305, 13.489085, 0), 
			Wherigo.ZonePoint(52.515287, 13.489086, 0), 
			Wherigo.ZonePoint(52.515274, 13.489093, 0), 
			Wherigo.ZonePoint(52.515258, 13.489097, 0), 
			Wherigo.ZonePoint(52.515242, 13.489097, 0), 
			Wherigo.ZonePoint(52.515231, 13.489099, 0), 
			Wherigo.ZonePoint(52.515218, 13.489096, 0), 
			Wherigo.ZonePoint(52.515199, 13.489085, 0), 
			Wherigo.ZonePoint(52.515181, 13.489083, 0), 
			Wherigo.ZonePoint(52.515171, 13.489082, 0), 
			Wherigo.ZonePoint(52.515156, 13.489078, 0), 
			Wherigo.ZonePoint(52.51515, 13.489066, 0), 
			Wherigo.ZonePoint(52.515153, 13.489049, 0), 
			Wherigo.ZonePoint(52.515159, 13.489023, 0), 
			Wherigo.ZonePoint(52.515166, 13.489002, 0), 
			Wherigo.ZonePoint(52.515177, 13.488977, 0), 
			Wherigo.ZonePoint(52.515189, 13.488948, 0), 
			Wherigo.ZonePoint(52.515197, 13.48893, 0), 
			Wherigo.ZonePoint(52.515204, 13.488911, 0), 
			Wherigo.ZonePoint(52.515208, 13.488887, 0), 
			Wherigo.ZonePoint(52.515217, 13.488854, 0), 
			Wherigo.ZonePoint(52.515239, 13.488838, 0), 
			Wherigo.ZonePoint(52.515257, 13.488842, 0), 
			Wherigo.ZonePoint(52.515272, 13.488833, 0), 
			Wherigo.ZonePoint(52.51528, 13.488815, 0), 
			Wherigo.ZonePoint(52.515289, 13.488792, 0), 
			Wherigo.ZonePoint(52.515299, 13.488809, 0), 
			Wherigo.ZonePoint(52.515322, 13.488823, 0), 
			Wherigo.ZonePoint(52.515334, 13.48882, 0), 
			Wherigo.ZonePoint(52.515344, 13.488815, 0), 
			Wherigo.ZonePoint(52.51536, 13.488813, 0), 
			Wherigo.ZonePoint(52.51538, 13.488809, 0), 
			Wherigo.ZonePoint(52.515398, 13.488807, 0), 
			Wherigo.ZonePoint(52.51542, 13.488804, 0), 
			Wherigo.ZonePoint(52.515438, 13.488796, 0), 
			Wherigo.ZonePoint(52.515457, 13.488792, 0)
		}
		-- Agent 2 patrols this route
		points_22_agent_2 = {
			Wherigo.ZonePoint(52.515459, 13.488791, 0), 
			Wherigo.ZonePoint(52.515478, 13.488786, 0), 
			Wherigo.ZonePoint(52.515488, 13.488784, 0), 
			Wherigo.ZonePoint(52.5155, 13.488791, 0), 
			Wherigo.ZonePoint(52.515501, 13.488816, 0), 
			Wherigo.ZonePoint(52.515502, 13.488836, 0), 
			Wherigo.ZonePoint(52.515506, 13.488857, 0), 
			Wherigo.ZonePoint(52.515503, 13.488879, 0), 
			Wherigo.ZonePoint(52.515497, 13.488903, 0), 
			Wherigo.ZonePoint(52.515489, 13.488923, 0), 
			Wherigo.ZonePoint(52.515486, 13.488949, 0), 
			Wherigo.ZonePoint(52.515478, 13.488976, 0), 
			Wherigo.ZonePoint(52.515473, 13.489004, 0), 
			Wherigo.ZonePoint(52.515468, 13.489024, 0), 
			Wherigo.ZonePoint(52.515464, 13.489045, 0), 
			Wherigo.ZonePoint(52.515461, 13.489059, 0), 
			Wherigo.ZonePoint(52.515455, 13.489073, 0), 
			Wherigo.ZonePoint(52.515453, 13.489087, 0), 
			Wherigo.ZonePoint(52.515443, 13.489099, 0), 
			Wherigo.ZonePoint(52.515423, 13.489098, 0), 
			Wherigo.ZonePoint(52.515401, 13.489099, 0), 
			Wherigo.ZonePoint(52.515377, 13.489092, 0), 
			Wherigo.ZonePoint(52.51535, 13.489087, 0), 
			Wherigo.ZonePoint(52.515322, 13.489082, 0), 
			Wherigo.ZonePoint(52.515299, 13.489068, 0), 
			Wherigo.ZonePoint(52.515276, 13.489056, 0), 
			Wherigo.ZonePoint(52.515251, 13.489054, 0), 
			Wherigo.ZonePoint(52.51522, 13.489058, 0), 
			Wherigo.ZonePoint(52.515196, 13.489055, 0), 
			Wherigo.ZonePoint(52.515179, 13.489047, 0), 
			Wherigo.ZonePoint(52.515165, 13.48905, 0), 
			Wherigo.ZonePoint(52.515154, 13.489049, 0), 
			Wherigo.ZonePoint(52.51514, 13.489044, 0), 
			Wherigo.ZonePoint(52.515128, 13.489041, 0), 
			Wherigo.ZonePoint(52.515109, 13.489036, 0), 
			Wherigo.ZonePoint(52.515106, 13.489021, 0), 
			Wherigo.ZonePoint(52.515108, 13.489001, 0), 
			Wherigo.ZonePoint(52.515111, 13.488975, 0), 
			Wherigo.ZonePoint(52.515115, 13.488938, 0), 
			Wherigo.ZonePoint(52.515126, 13.488891, 0), 
			Wherigo.ZonePoint(52.515134, 13.488852, 0), 
			Wherigo.ZonePoint(52.515131, 13.48883, 0), 
			Wherigo.ZonePoint(52.515141, 13.48882, 0), 
			Wherigo.ZonePoint(52.515152, 13.488843, 0), 
			Wherigo.ZonePoint(52.515161, 13.488855, 0), 
			Wherigo.ZonePoint(52.515177, 13.488849, 0), 
			Wherigo.ZonePoint(52.515201, 13.488865, 0), 
			Wherigo.ZonePoint(52.515219, 13.48889, 0), 
			Wherigo.ZonePoint(52.515236, 13.488909, 0), 
			Wherigo.ZonePoint(52.515256, 13.488923, 0), 
			Wherigo.ZonePoint(52.515266, 13.488927, 0), 
			Wherigo.ZonePoint(52.515277, 13.488929, 0), 
			Wherigo.ZonePoint(52.515293, 13.488932, 0), 
			Wherigo.ZonePoint(52.515307, 13.488933, 0), 
			Wherigo.ZonePoint(52.515322, 13.488938, 0), 
			Wherigo.ZonePoint(52.515338, 13.488946, 0), 
			Wherigo.ZonePoint(52.515353, 13.488943, 0), 
			Wherigo.ZonePoint(52.515373, 13.488937, 0), 
			Wherigo.ZonePoint(52.515388, 13.48893, 0), 
			Wherigo.ZonePoint(52.515402, 13.48892, 0), 
			Wherigo.ZonePoint(52.5154, 13.488904, 0), 
			Wherigo.ZonePoint(52.515403, 13.488876, 0), 
			Wherigo.ZonePoint(52.515422, 13.488858, 0), 
			Wherigo.ZonePoint(52.515436, 13.488831, 0), 
			Wherigo.ZonePoint(52.515451, 13.488814, 0), 
			Wherigo.ZonePoint(52.51547, 13.488802, 0), 
			Wherigo.ZonePoint(52.515487, 13.488786, 0), 
			Wherigo.ZonePoint(52.515504, 13.488771, 0), 
			Wherigo.ZonePoint(52.515521, 13.488762, 0), 
			Wherigo.ZonePoint(52.515532, 13.488755, 0), 
			Wherigo.ZonePoint(52.515525, 13.488776, 0), 
			Wherigo.ZonePoint(52.515523, 13.488797, 0), 
			Wherigo.ZonePoint(52.515515, 13.488803, 0), 
			Wherigo.ZonePoint(52.515503, 13.488825, 0), 
			Wherigo.ZonePoint(52.515492, 13.488834, 0), 
			Wherigo.ZonePoint(52.515483, 13.488833, 0), 
			Wherigo.ZonePoint(52.51547, 13.488825, 0), 
			Wherigo.ZonePoint(52.51548, 13.488841, 0), 
			Wherigo.ZonePoint(52.515493, 13.488863, 0), 
			Wherigo.ZonePoint(52.515498, 13.488882, 0), 
			Wherigo.ZonePoint(52.5155, 13.488905, 0), 
			Wherigo.ZonePoint(52.515498, 13.488927, 0), 
			Wherigo.ZonePoint(52.515492, 13.48896, 0), 
			Wherigo.ZonePoint(52.515487, 13.488978, 0), 
			Wherigo.ZonePoint(52.515483, 13.488999, 0), 
			Wherigo.ZonePoint(52.515481, 13.489021, 0), 
			Wherigo.ZonePoint(52.515476, 13.489047, 0), 
			Wherigo.ZonePoint(52.515469, 13.489069, 0), 
			Wherigo.ZonePoint(52.515465, 13.489089, 0), 
			Wherigo.ZonePoint(52.51546, 13.48911, 0), 
			Wherigo.ZonePoint(52.515454, 13.489126, 0), 
			Wherigo.ZonePoint(52.515444, 13.489129, 0), 
			Wherigo.ZonePoint(52.515435, 13.489124, 0), 
			Wherigo.ZonePoint(52.515423, 13.48912, 0), 
			Wherigo.ZonePoint(52.515409, 13.489116, 0), 
			Wherigo.ZonePoint(52.515398, 13.48911, 0), 
			Wherigo.ZonePoint(52.515383, 13.489103, 0), 
			Wherigo.ZonePoint(52.515368, 13.4891, 0), 
			Wherigo.ZonePoint(52.515356, 13.489093, 0), 
			Wherigo.ZonePoint(52.515345, 13.489094, 0), 
			Wherigo.ZonePoint(52.515334, 13.489089, 0), 
			Wherigo.ZonePoint(52.515319, 13.489086, 0), 
			Wherigo.ZonePoint(52.515305, 13.489085, 0), 
			Wherigo.ZonePoint(52.515287, 13.489086, 0), 
			Wherigo.ZonePoint(52.515274, 13.489093, 0), 
			Wherigo.ZonePoint(52.515258, 13.489097, 0), 
			Wherigo.ZonePoint(52.515242, 13.489097, 0), 
			Wherigo.ZonePoint(52.515231, 13.489099, 0), 
			Wherigo.ZonePoint(52.515218, 13.489096, 0), 
			Wherigo.ZonePoint(52.515199, 13.489085, 0), 
			Wherigo.ZonePoint(52.515181, 13.489083, 0), 
			Wherigo.ZonePoint(52.515171, 13.489082, 0), 
			Wherigo.ZonePoint(52.515156, 13.489078, 0), 
			Wherigo.ZonePoint(52.51515, 13.489066, 0), 
			Wherigo.ZonePoint(52.515153, 13.489049, 0), 
			Wherigo.ZonePoint(52.515159, 13.489023, 0), 
			Wherigo.ZonePoint(52.515166, 13.489002, 0), 
			Wherigo.ZonePoint(52.515177, 13.488977, 0), 
			Wherigo.ZonePoint(52.515189, 13.488948, 0), 
			Wherigo.ZonePoint(52.515197, 13.48893, 0), 
			Wherigo.ZonePoint(52.515204, 13.488911, 0), 
			Wherigo.ZonePoint(52.515208, 13.488887, 0), 
			Wherigo.ZonePoint(52.515217, 13.488854, 0), 
			Wherigo.ZonePoint(52.515239, 13.488838, 0), 
			Wherigo.ZonePoint(52.515257, 13.488842, 0), 
			Wherigo.ZonePoint(52.515272, 13.488833, 0), 
			Wherigo.ZonePoint(52.51528, 13.488815, 0), 
			Wherigo.ZonePoint(52.515289, 13.488792, 0), 
			Wherigo.ZonePoint(52.515299, 13.488809, 0), 
			Wherigo.ZonePoint(52.515322, 13.488823, 0), 
			Wherigo.ZonePoint(52.515334, 13.48882, 0), 
			Wherigo.ZonePoint(52.515344, 13.488815, 0), 
			Wherigo.ZonePoint(52.51536, 13.488813, 0), 
			Wherigo.ZonePoint(52.51538, 13.488809, 0), 
			Wherigo.ZonePoint(52.515398, 13.488807, 0), 
			Wherigo.ZonePoint(52.51542, 13.488804, 0), 
			Wherigo.ZonePoint(52.515438, 13.488796, 0), 
			Wherigo.ZonePoint(52.515457, 13.488792, 0)
		}
		-- Agent 3 patrols this route
		points_22_agent_3 = {
			Wherigo.ZonePoint(52.514455, 13.49333, 0), 
			Wherigo.ZonePoint(52.514465, 13.493326, 0), 
			Wherigo.ZonePoint(52.514491, 13.493331, 0), 
			Wherigo.ZonePoint(52.5145, 13.493338, 0), 
			Wherigo.ZonePoint(52.51451, 13.493331, 0), 
			Wherigo.ZonePoint(52.514521, 13.493317, 0), 
			Wherigo.ZonePoint(52.514524, 13.493284, 0), 
			Wherigo.ZonePoint(52.514525, 13.493265, 0), 
			Wherigo.ZonePoint(52.514527, 13.493244, 0), 
			Wherigo.ZonePoint(52.514531, 13.493226, 0), 
			Wherigo.ZonePoint(52.514525, 13.493204, 0), 
			Wherigo.ZonePoint(52.514516, 13.493184, 0), 
			Wherigo.ZonePoint(52.514512, 13.493168, 0), 
			Wherigo.ZonePoint(52.514498, 13.493157, 0), 
			Wherigo.ZonePoint(52.514483, 13.493154, 0), 
			Wherigo.ZonePoint(52.514472, 13.493155, 0), 
			Wherigo.ZonePoint(52.514456, 13.493154, 0), 
			Wherigo.ZonePoint(52.514445, 13.493152, 0), 
			Wherigo.ZonePoint(52.514434, 13.49315, 0), 
			Wherigo.ZonePoint(52.514425, 13.493148, 0), 
			Wherigo.ZonePoint(52.514413, 13.493146, 0), 
			Wherigo.ZonePoint(52.514397, 13.493142, 0), 
			Wherigo.ZonePoint(52.514384, 13.49314, 0), 
			Wherigo.ZonePoint(52.514377, 13.493158, 0), 
			Wherigo.ZonePoint(52.514376, 13.493186, 0), 
			Wherigo.ZonePoint(52.514381, 13.4932, 0), 
			Wherigo.ZonePoint(52.514383, 13.493218, 0), 
			Wherigo.ZonePoint(52.514386, 13.493236, 0), 
			Wherigo.ZonePoint(52.514391, 13.493255, 0), 
			Wherigo.ZonePoint(52.514398, 13.493272, 0), 
			Wherigo.ZonePoint(52.514404, 13.493286, 0), 
			Wherigo.ZonePoint(52.514402, 13.493301, 0), 
			Wherigo.ZonePoint(52.514402, 13.493315, 0), 
			Wherigo.ZonePoint(52.514404, 13.493347, 0), 
			Wherigo.ZonePoint(52.514408, 13.493361, 0), 
			Wherigo.ZonePoint(52.514423, 13.493358, 0), 
			Wherigo.ZonePoint(52.514437, 13.493358, 0), 
			Wherigo.ZonePoint(52.514453, 13.493359, 0), 
			Wherigo.ZonePoint(52.514467, 13.49335, 0), 
			Wherigo.ZonePoint(52.514478, 13.49335, 0), 
			Wherigo.ZonePoint(52.514508, 13.493352, 0), 
			Wherigo.ZonePoint(52.514522, 13.493345, 0), 
			Wherigo.ZonePoint(52.514535, 13.493344, 0), 
			Wherigo.ZonePoint(52.514541, 13.493332, 0), 
			Wherigo.ZonePoint(52.514552, 13.493343, 0), 
			Wherigo.ZonePoint(52.514568, 13.493345, 0), 
			Wherigo.ZonePoint(52.514579, 13.493361, 0), 
			Wherigo.ZonePoint(52.514565, 13.493367, 0), 
			Wherigo.ZonePoint(52.514542, 13.493353, 0), 
			Wherigo.ZonePoint(52.514533, 13.493357, 0), 
			Wherigo.ZonePoint(52.514524, 13.493351, 0), 
			Wherigo.ZonePoint(52.51451, 13.493343, 0), 
			Wherigo.ZonePoint(52.514495, 13.49334, 0), 
			Wherigo.ZonePoint(52.514482, 13.493329, 0), 
			Wherigo.ZonePoint(52.514473, 13.493325, 0), 
			Wherigo.ZonePoint(52.514461, 13.493322, 0), 
			Wherigo.ZonePoint(52.514447, 13.493322, 0), 
			Wherigo.ZonePoint(52.514432, 13.493316, 0), 
			Wherigo.ZonePoint(52.51442, 13.493321, 0), 
			Wherigo.ZonePoint(52.514405, 13.493323, 0), 
			Wherigo.ZonePoint(52.514391, 13.493327, 0), 
			Wherigo.ZonePoint(52.514381, 13.49333, 0), 
			Wherigo.ZonePoint(52.514371, 13.493324, 0), 
			Wherigo.ZonePoint(52.514351, 13.49332, 0), 
			Wherigo.ZonePoint(52.514339, 13.49331, 0), 
			Wherigo.ZonePoint(52.51433, 13.493307, 0), 
			Wherigo.ZonePoint(52.51432, 13.493306, 0), 
			Wherigo.ZonePoint(52.514308, 13.493304, 0), 
			Wherigo.ZonePoint(52.514298, 13.493286, 0), 
			Wherigo.ZonePoint(52.514288, 13.493271, 0), 
			Wherigo.ZonePoint(52.51428, 13.493259, 0), 
			Wherigo.ZonePoint(52.514267, 13.493248, 0), 
			Wherigo.ZonePoint(52.514247, 13.493233, 0), 
			Wherigo.ZonePoint(52.514233, 13.493213, 0), 
			Wherigo.ZonePoint(52.51422, 13.493186, 0), 
			Wherigo.ZonePoint(52.514202, 13.493165, 0), 
			Wherigo.ZonePoint(52.514188, 13.493147, 0), 
			Wherigo.ZonePoint(52.5142, 13.493146, 0), 
			Wherigo.ZonePoint(52.514209, 13.49315, 0), 
			Wherigo.ZonePoint(52.51422, 13.493151, 0), 
			Wherigo.ZonePoint(52.514236, 13.493156, 0), 
			Wherigo.ZonePoint(52.514245, 13.493151, 0), 
			Wherigo.ZonePoint(52.514256, 13.493141, 0), 
			Wherigo.ZonePoint(52.514265, 13.493142, 0), 
			Wherigo.ZonePoint(52.514283, 13.493147, 0), 
			Wherigo.ZonePoint(52.514293, 13.49315, 0), 
			Wherigo.ZonePoint(52.514302, 13.493156, 0), 
			Wherigo.ZonePoint(52.514313, 13.493166, 0), 
			Wherigo.ZonePoint(52.514328, 13.493172, 0), 
			Wherigo.ZonePoint(52.514343, 13.493174, 0), 
			Wherigo.ZonePoint(52.514354, 13.493174, 0), 
			Wherigo.ZonePoint(52.51437, 13.493177, 0), 
			Wherigo.ZonePoint(52.514397, 13.493182, 0), 
			Wherigo.ZonePoint(52.514422, 13.493191, 0), 
			Wherigo.ZonePoint(52.514438, 13.4932, 0), 
			Wherigo.ZonePoint(52.514455, 13.493221, 0), 
			Wherigo.ZonePoint(52.514456, 13.49325, 0), 
			Wherigo.ZonePoint(52.514457, 13.493268, 0), 
			Wherigo.ZonePoint(52.514456, 13.493296, 0)
		}
		zone_23_hospital_points = {
			Wherigo.ZonePoint(52.5142621528044, 13.4943652153015, 0), 
			Wherigo.ZonePoint(52.5142474621411, 13.4945073723793, 0), 
			Wherigo.ZonePoint(52.5141462596603, 13.4944939613342, 0), 
			Wherigo.ZonePoint(52.5141119813478, 13.4947675466537, 0), 
			Wherigo.ZonePoint(52.5142066547172, 13.4947943687439, 0), 
			Wherigo.ZonePoint(52.5141968609298, 13.4949150681496, 0), 
			Wherigo.ZonePoint(52.5142850049376, 13.4949338436127, 0), 
			Wherigo.ZonePoint(52.5143421352186, 13.4943893551826, 0)
		}
		zone_23c_heroes_end_points = {
			Wherigo.ZonePoint(52.5158887053167, 13.5009017586708, 0), 
			Wherigo.ZonePoint(52.5158544283635, 13.500936627388, 0), 
			Wherigo.ZonePoint(52.5158544283635, 13.5010251402855, 0)
		}
		zone_24d_mourners_end_points = {
			Wherigo.ZonePoint(52.5184512399019, 13.492289185524, 0), 
			Wherigo.ZonePoint(52.5184414470606, 13.4925292432308, 0), 
			Wherigo.ZonePoint(52.5185997643943, 13.4925372898579, 0), 
			Wherigo.ZonePoint(52.5186005804615, 13.492294549942, 0)
		}
	end, 
	[2] = function()
		memo_name = "Notizblock"
		memo_description = "Im Notizblock wird festgehalten, was bisher geschehen ist."
		memo_command_view_caption = "Anschauen"
		function save_game(entry)
			if entry then
				text_memo = string.format([[%s
---
%s]], entry, text_memo)
			end
			prometheus_chapter_2:RequestSync()
		end
		text_memo = "Hier halte ich in umgekehrter chronologischer Reihenfolge wichtige Ereignisse fest. Ich kann im Uebrigen extrem schnell schreiben! :-D Bei wichtigen Ereignissen wird das Spiel automatisch gespeichert und hier ein Eintrag gemacht."
		text_event_01_previously = "Ich hab das Virus unschaedlich gemacht und John Greenwitch nicht an Mr. Johnson verkauft. Mr. Johnson ist mir dafuer bestimmt boese und wird mir wohl auch die Konsequenzen meines Heldspielens aufzeigen, sollten wir uns je wieder begegnen. Allerdings ich habe da so ein Gefuehl..."
		text_event_04_call_from_johnson = "Mr. Johnson rief mich an und wies mich auf einen Nachrichtenbeitrag hin. Das Virus breitet sich wohl schneller aus, als befuerchtet. Johnson macht mich dafuer verantwortlich und beauftragt mich, noch einmal mit John Greenwitch zu sprechen."
		text_event_06a_call_from_johnson_daughter_abducted = "\"... es geht um Greenwitchs Tochter. Er wird Ihre Hilfe benoetigen!\" hat Johnson mir gesagt. Sollte ich Greenwitch davon berichten oder ist das nur einfache Panikmache?"
		text_event_08_call_to_greenwitch_a_honest = "Ich habe Greenwitch von Johnsons Anruf berichtet. Er will mich treffen."
		text_event_08_call_to_greenwitch_b_hide = "Ich habe mit John Greenwitch gesprochen, ihm aber verschwiegen, dass Johnson mich anrief. Greenwitch will mich treffen."
		text_event_08_call_to_greenwitch_c_a06 = [[Ich habe Greenwitch von Johnsons Anruf berichtet und auch davon, dass es "um seine Tochter ginge". Greenwitch will mich treffen.
2GHHJR]]
		text_event_10_shake_off_pursuers_first = "Greenwitch hat mir ploetzlich einen anderen Treffpunkt uebermittelt. Ich sollte mich dort hin begeben. Und ich werde beobachtet. Ich sollte meine Verfolger so schnell wie moeglich loswerden. Wahrscheinlich wird mir das nicht gleich beim ersten Versuch gelingen."
		text_event_11_call_from_greenwitch_abduction = "Greenwitchs Tochter Fiona wurde entfuehrt. Er sandte mir einen Mitschnitt vom Anruf. Ich sollte mit den anhoeren, vielleicht gibt es ein paar Hinweise auf ihren Verbleib. Und ich sollte meine UV-Lampe bereithalten. Vielleicht hat gibt es irgendwelche Spuren ..."
		text_event_11_call_from_greenwitch_abduction_known = "Geahnt hatte ich es schon: Greenwitchs Tochter Fiona wurde entfuehrt. Er sandte mir einen Mitschnitt vom Anruf. Ich sollte mir den anhoeren, vielleicht gibt es ein paar Hinweise auf ihren Verbleib. Und ich sollte meine UV-Lampe bereithalten. Vielleicht hat gibt es irgendwelche Spuren ..."
		text_event_15_call_from_johnson_radio_tag = "Mr. Johnson hat Fiona entfuehrt, um meine Aufmerksamkeit zu erhalten. Die Spurensuche brachte mich zur Wohnung von einer Journalistin namens H. Onekana. Sie ist Patient 0, der Indexfall fuer Berlin. Sie liegt in Quarantaene und duerfte die Nacht wohl nicht ueberleben. Johnson redete mir ins Gewissen, dass wenn ich schon so einen Aufwand betreibe, Greenwitchs Tochter zu finden, dann sollte ich mir aber auch vor Augen fuehren, was passieren wird, wenn das Gegenmittel nicht in Masse produziert werden kann. Er hat Fiona mit einem Peilsender versehen und sie laufen lassen. Ich soll ihr unauffaellig folgen. Johnson vermutet, sie trifft sich mit ihrem Vater."
		text_event_17_call_from_johnson_stay = "Fiona trifft ihren Vater. Johnson bedeutet mir stehen zu bleiben, damit die beiden nicht gewarnt werden. Ich koennte noch etwas naeher ran gehen, wenn ich dem Gespraech zwischen den beiden lauschen moechte."
		text_event_20a_johnson_kidnaps_greenwitch = "Es geht alles sehr schnell. Ein schwarzer Van faehrt vor und ein paar Gorillas in schicken Anzuegen steigen aus und verwickeln Greenwitch in einen Faustkampf. Waehrend seine Tochter Fiona fliehen kann, wird John ohnmaechtig geschlagen und in den Van gezogen und abtransportiert. Ich kann nur hoffen, dass das Gegenmittel schnell synthetisiert und weltweit verbreitet wird."
		text_event_21a_call_from_johnson_gratitude_traitors_end = "Johnson ist mir dankbar und laesst mich das auch wissen. Er moechte mich einmal mehr fuer die Zeus Inc. rekrutieren. Ich denke, ich bin diesmal bereit dafuer. Dazu soll ich mich an den toten Briefkasten begeben und in die Mitarbeiterliste eintragen."
		text_event_21b_call_from_johnson_threat = "Ich habe Greenwitch und seine Tochter gewarnt. Greenwitch gab mir daraufhin das Gegenmittel, das ich so schnell wie moeglich zu seiner Kontaktperson im Krankenhaus bringen soll. Nun rief mich auch Johnson an und liess mich wissen, wie gering er mich und meine Entscheidung achtet. Er hetzt seine Leute auf mich, um gewaltsam an das Gegenmittel zu kommen. Ich muss mich zum Krankenhaus beeilen."
		text_event_23c_reaching_hospital_heroes_end = [[Ich hab Greenwitchs Kontakt, eine Aerztin, rechtzeitig treffen koennen. Mit dem Gegenmittel wird sie Frau Onekana retten koennen. Ausserdem wird das Gegenmittel weiter synthetisiert, wobei das wohl tatsaechlich nicht so schnell gehen wird, als wenn ein grosser Konzern, wie Zeus Inc. das Gegenmittel bekommen haette...
Ich soll mich zu einem toten Briefkasten begeben und mich dort in eine Liste von Troubleshootern eintragen, die dann gerufen werden koennen, wenn man sie spaeter braucht.]]
		text_event_23d_lost_antidote_to_johnson = "Ich konnte Johnsons Schergen nicht entkommen. Ploetzlich war ich von Gorillas in schicken Anzuegen umzingelt. Sie nahmen mir nicht nur das Gegenmittel ab, sondern sorgten auch dafuer, dass ich Johnsons Verachtung fuer mich fuer die naechsten Wochen nicht vergessen werde. Dennoch sollte ich zum Krankenhaus und ..."
		text_event_24d_mourners_end = "Ich konnte Greenwitchs Kontakt, einer Aerztin, kaum in die Augen schauen als ich ihr sagte, dass ich versagt habe. Sie meinte, dass Frau Onekana damit die Nacht nicht ueberleben wird. Ich sollte zumindest zum Friedhof gehen und mich ins Kondolenzbuch eintragen. Ein paar Worte sollte ich ihr zumindest hinterlassen ..."
		text_event_completed_game = "Ich habe dieses Abenteuer beendet."
		text_event_completion_code = "Completion Code"
	end, 
	[3] = function()
		dialog_scripts_language = "german"
		text_yes = "ja"
		text_no = "nein"
		text_accept = "annehmen"
		text_reject = "ablehnen"
		text_ignore_call = "Sie ignorieren den Anruf"
		text_ok = "Okay"
		text_incoming_call_johnson = "Anruf von Mr. Johnson"
		text_incoming_call_greenwitch = "Anruf von Greenwitch"
		--[[
		DRAMATIS PERSONAE
		Johnson                     - Matze
		Greenwitch                  - Tobi
		Fiona Greenwitch (Tochter)  - Regina
		Nachrichtensprecher         - Mathi
		Arzt                        - Anastasia
		PATIENT_0                   - *** Keine Sprechrolle ***
		--]]
		character_john_greenwitch_name = "John Greenwitch"
		character_john_greenwitch_description = "John Greenwitch ist ein Virologe und ehemaliger Mitarbeiter der Prometheus Corporation. Als Whistleblower deckte er die Verstrickungen seines Unternehmens um das Pandora-Virus auf. Er ist bislang auch weltweit der einzige Wissenschaftler, der ein stabiles Gegenmittel gegen das Virus entwickelt hat. Die Zeus Incorporated will seiner unbedingt habhaft werden."
		character_fiona_greenwitch_name = "Fiona Greenwitch"
		character_fiona_greenwitch_description = "Fiona ist die Tochter von John Greenwitch. Mr. Johnson hatte sie entfuehrt, um an John Greenwitch heranzukommen."
		character_mr_johnson_name = "Mr. Johnson"
		character_mr_johnson_description = "Mr. Johnson arbeitet fuer die Zeus Incorporated, einem Konkurrenzunternehmen zur Prometheus Corporation. Er rekrutiert gern Laufburschen und moechte John Greenwitch davon ueberzeugen, fuer die Zeus Inc. zu arbeiten."
		character_medical_doctor_name = "Dr. WHO"
		character_medical_doctor_description = "Dr. WHO ist John Greenwitchs Kontaktperson und arbeitet fuer die Weltgesundheitsorganisation."
		-- 1) ---
		task_01_previously_name = "Was bisher geschah ..."
		task_01_previously_description = "Sie koennen sich entweder eine Zusammenfassung vom Vorgaenger (GC4CTGM) geben lassen oder gleich mit dem Spiel beginnen."
		question_01_previously = "Benoetigen Sie eine Zusammenfassung von dem, was bisher geschah? Sie koennen sich die Zusammenfassung auch jederzeit noch einmal anschauen."
		text_01_previously = [[Prometheus - Chapter 1: Projekt Pandora
coord.info/GC4CTGM

Vor ein paar Monaten wurde ich von einem Whistleblower namens John Greenwitch angesprochen. Er arbeitete als Virologe fuer die Prometheus Corporation. Als dort ein Projekt, an dem er arbeitete, ausser Kontrolle geriet, musste er fliehen. Es ging um die Entwicklung eines Gegenmittels fuer ein Virus, von dem Greenwitch mutmasste, dass es die Prometheus Corporation selbst erschaffen und irgendwo in Berlin freigesetzt hat. Greenwitch hatte irgendwo seine Aufzeichnungen versteckt und beauftragte mich, sie ihm zu besorgen, da er sich selbst versteckt halten musste. Kurz nachdem ich die Daten gefunden hatte und ihm uebersandte, rief mich ein ominoeser Mister Johnson von einer ebenso ominoesen Zeus Incorporated an. Diese Firma scheint ein direkter Konkurrent zur Prometheus zu sein. Er beauftragte mich, Greenwitch an ihn auszuliefern, da dann bei der Zeus das Gegenmittel viel besser vervielfaeltigt werden koennte. Ich entschied mich gegen Johnson, was er mir wahrscheinlich noch immer uebel nimmt. Stattdessen half ich Greenwitch, der mit Hilfe der Daten ein kurzlebiges Antidot synthetisieren konnte, was er auf das freigesetzte Virus ansetzen wollte. Da er abermals fliehen musste, hinterliess er mir das Antidot und ich musste das Virus neutralisieren, was mir auch gelang.]]
		-- 2) JohnsonAnruf 1.1
		text_02_call_from_johnson_1_1 = [[Ich gruesse Sie! Sie erinnern sich sicher noch an mich! Johnson. Ich arbeite fuer die Zeus Inc. Wir hatten vor einiger Zeit die Ehre, uns kennen zu lernen. Es ging um das Virus, das die Prometheus Corp. freisetzen wollte. Ich hatte Ihnen meine Hilfe angeboten aber Sie haben abgelehnt.
Es gibt da etwas, dass Sie sich ansehen sollten:]]
		-- 3) Nachrichtenbeitrag
		item_03_news_name = "Nachrichtenbeitrag"
		item_03_news_description = "Nachrichtenbeitrag ueber die Ausbreitung des Virus"
		item_03_news_command_view_caption = "Anschauen"
		text_03_news_link = "http://youtu.be/le0_GkG7Hu8"
		text_03_news = (([[Link zum Nachrichtenbeitrag:
]]..text_03_news_link)..[[

]])..[[... auch von Seiten der WHO gibt man sich ratlos. Von den 8.000 dokumentierten Faellen in Ostafrika verliefen mehr als 90 Prozent toedlich.
In einer Pressekonferenz der WHO gab man bekannt, es werde nichts unversucht gelassen, ein Gegenmittel zu entwickeln. Experten schaetzen, dass noch Monate vergehen werden, bis das Virus bekaempft werden kann.
Heute Morgen gab das Ministerium fuer Gesundheit in Berlin eine erste bestaetigte Infektion in Deutschland bekannt. Das Auswaertige Amt verschaerfte darauf hin noch einmal seine Reisewarnungen fuer eine Vielzahl der afrikanischen und nun erstmalig auch sued-europaeischen Staaten.
Bewahren Sie Ruhe!
Bleiben Sie wenn moeglich zu Hause und halten Sie sich von Menschenmassen fern. Fuer den Fall, dass Sie Ihre Wohnung verlassen muessen, tragen Sie einen Mundschutz. Falls Sie Anzeichen von Uebelkeit oder unerklaerliche Blutungen haben, kontaktieren Sie umgehend den Rettungsdienst.
Das Bundesministerium fuer Gesundheit hat fuer weitere Fragen unter 0176 81 90 83 61 eine Servicehotline eingerichtet ...]]
		-- 4) JohnsonAnruf 1.2
		text_04_call_from_johnson_1_2 = [[Was Sie hier sehen, ist nur die Spitze des Eisbergs. Die Medien sprechen von weltweit weniger als 10.000 Infizierten. Doch glauben Sie mir, die tatsaechlichen Zahlen sind weitaus groesser. Es wird versucht, die Menschen mit banalen Sicherheitsvorschriften ruhig zu halten.
All das sind nur bequeme Luegen, um ihnen ein Gefuehl von Sicherheit zu geben. Jeden Tag breitet sich das Virus schneller aus. Ein Heilmittel wird selbst von den optimistischsten Wissenschaftlern nicht in den naechsten Monaten erwartet.
Aber in einem Punkt haben die Medien Recht: Heute Morgen wurde der erste Patient in ein Berliner Krankenhaus eingeliefert. Morgen schon wird es vermutlich die naechsten Infizierten geben. Zunaechst die Familie, dann Freunde, Nachbarn...
In den naechsten Wochen werden dutzende Menschen ueber unerklaerliche Uebelkeit klagen. Bald schon verspueren sie starken Husten, spaeter unerklaerliche Blutungen aus Mund, Nase und den Augen... Man wird sie ins Krankenhaus bringen, doch bis dahin haben sie wiederum Hunderte infiziert.
Maenner, Frauen, Kinder... sie alle werden sterben! Und alles nur, weil Sie den Helden spielen wollten.
Es wird Zeit, dass Sie ueber die Konsequenzen Ihres Tuns nachdenken. Reden Sie noch einmal mit John Greenwitch! Er ist noch immer der Einzige, der bisher ein Gegenmittel erschaffen konnte. Wir brauchen ihn.]]
		-- A5) -> A6) Johnson erzaehlt von Tochter
		text_06a_call_from_johnson_daughter_abducted = {
			"Ich habe Ihnen schon einmal nicht vertraut. Und ich vertraue Ihnen auch jetzt nicht!", 
			"Sie muessen mir nicht vertrauen. Aber es geht um Greenwitchs Tochter. Er wird Ihre Hilfe benoetigen!"
		}
		-- B5) -> B6) ---
		text_05b_call_from_johnson = "Alles klar, ich rede mit ihm!"
		-- 7) ---
		task_07_call_to_greenwitch_name = "John Greenwitch anrufen"
		task_07_call_to_greenwitch_description = "Ich muss mit John Greenwitch sprechen"
		-- 8) Anrufen bei Greenwitch. Er geht ans Telefon und sagt:
		text_08_call_to_greenwitch = "Sie sind es? Hmm... was fuer ein Zufall, dass Sie ausgerechnet jetzt anrufen. Worum geht es?"
		-- A) Ehrlich -> Dankbar
		text_08_call_to_greenwitch_a_honest = {
			"Johnson hat mich gebeten, nach Ihnen zu schauen.", 
			"Ich hatte so etwas bereits befuerchtet ..."
		}
		-- B) Verheimlichen -> Angepisst
		text_08_call_to_greenwitch_b_hide = {
			"Ich habe gehoert, wir haben einen ersten Ausbruch in Deutschland. Zeit etwas zu unternehmen!", 
			"Das klingt, als wollten Sie noch ueber etwas anderes reden, aber gut ..."
		}
		-- C) Nach Tochter fragen (NUR wenn A6 gewaehlt wurde) -> Wird schweigsam
		-- Da hab ich mal "Er hat Ihre Tocher" in "Es geht um Ihre Tochter" umgewandelt. Vielleicht nicht gleich mit der Entfuehrung rausplatzen. Das kommt ja eh gleich nochmal!
		text_08_call_to_greenwitch_c_a06 = {
			"Johnson rief mich an. \"Es geht um Ihre Tochter\", meinte er ...", 
			[[Verstehe. Wir sollten nicht am Telefon darueber reden!
2GHHJR]]
		}
		-- Antwort auf alles von John Greenwitch
		text_08_call_to_greenwitch_end = "Treffen Sie mich an den folgenden Koordinaten. Schnell!"
		-- 9) ---
		-- 10) In Zone - Anruf von Greenwitch (Komm zu anderer Zone)
		-- TODO: ORT SPEZIFIZIEREN!
		text_10_call_from_greenwitch_followed = "Augen auf! Sie werden verfolgt. Es ist hier zu unsicher und ich brauche Sie ohnehin an einem anderen Ort. Kommen Sie so schnell wie moeglich dort hin."
		text_10_shake_off_pursuers_first = "Zunaechst muss ich meine Verfolger loswerden, bevor ich mich mit John Greenwitch treffen kann. Ich sollte diesen Ort erstmal verlassen und zurueckkehren, wenn ich nicht mehr beobachtet werde."
		text_10_no_pursuers_anymore = "Ich denke ich habe meine Verfolger abgeschuettelt. Ich sollte mich schnell zum Treffpunkt mit Greenwitch begeben."
		-- 11) Bei Punkt X: Anruf von Greenwitch.
		-- John Greenwitch erzaehlt von Entfuehrung, wenn der Spieler das
		-- nicht weiss, oder es Greenwitch nicht erzaehlt hat.
		text_11_call_from_greenwitch_abduction = [[Sehr gut. Ich glaube, es ist Ihnen niemand mehr gefolgt. Ich muss immer noch sehr vorsichtig sein. Vielleicht mehr denn je!
Aber ich habe den Punkt, an dem Sie sich befinden auch nicht zufaellig gewaehlt. Es es geht um... Fiona... Meine Tochter. Sie wurde gestern von hier entfuehrt. Und Johnson steckt dahinter.
Dieser Hund will mich dazu bringen, ihm die Forschungsdaten zu geben. Er will ein Gegenmittel, dass er teuer verkaufen kann.
Gott, ich hatte nicht gedacht, dass er zu so etwas im Stande waere. Wie konnte ich nur so naiv sein?
Ich... ich erhielt einen Anruf von ihr kurz nach der Entfuehrung. Ich sende Ihnen jetzt den Mitschnitt. Vielleicht hilft das, bei der Suche nach meiner Tochter.
Versuchen Sie mit Ihrer UV-Lampe Spuren zu finden.
Helfen Sie mir! Ich habe durch meine Arbeit schon ihre Mutter verloren. Ich kann nicht auch noch ohne meine Tochter leben. Ich bitte Sie! Bitte! Wenn nicht meinetwegen, dann um das Leben meiner Tochter zu schuetzen!]]
		-- Auch hier erzaehlt John Greenwitch von der Entfuehrung, bezieht
		-- sich aber auf darauf, dass der Spieler das schon weiss.
		text_11_call_from_greenwitch_abduction_known = [[Sehr gut. Ich glaube, Ihnen ist niemand mehr gefolgt. Ich muss immer noch sehr vorsichtig sein. Mehr denn je! 
Aber ich habe den Punkt, an dem Sie sich befinden auch nicht zufaellig gewaehlt. Sie wissen ja, es es geht um Fiona... Meine Tochter. sie wurde gestern von hier entfuehrt und - oh ja - raten sie mal, von wem! 
 Johnson steckt dahinter.
Dieser Hund will mich dazu bringen, ihm die Forschungsdaten zu geben. Er will ein Gegenmittel, dass er teuer verkaufen kann.
Gott, ich hatte nicht gedacht, dass er zu so etwas im Stande waere. Wie konnte ich nur so naiv sein? 
Ich... ich erhielt einen Anruf von ihr kurz nach der Entfuehrung. Ich sende Ihnen jetzt den Mitschnitt. Vielleicht hilft das, meine Tochter zu finden.
Versuchen Sie mit Ihrer UV-Lampe Spuren zu finden. Vielleicht koennen Sie so meine Tochter aufspueren. Helfen Sie mir! Ich habe durch meine Arbeit schon ihre Mutter verloren. Ich kann nicht auch noch ohne meine Tochter leben. Ich bitte Sie! Bitte! Wenn nicht meinetwegen, dann um das Leben meiner Tochter zu schuetzen!]]
		-- 12) Item Telefonanruf
		--[[
		 (Ein Anruf von Johnson und Tochter):
		 verraet ein paar Hinweise fuer Aufenthaltsort
		--]]
		item_12_call_from_johnson_abducted_daughter_name = "Mitschnitt von Fiona's Anruf"
		item_12_call_from_johnson_abducted_daughter_description = "John Greenwitch hat den Anruf von Mr. Johnson an ihn, bei dem auch seine Tochter sprach, mitgeschnitten. Er hat mir diesen Mitschnitt zugesandt, da Fiona Hinweise auf ihren Aufenthaltsort genannt hat."
		item_12_command_listen_caption = "Anhoeren"
		text_12_call_from_johnson_abducted_daughter = [[Papa? Bist Du da? Mir gehts gut, aber Du musst tun, was sie verlangen!
Hilf mir! Ich bin gleich bei den Bruecken an der Bahn und da ist... Das reicht fuer's Erste. (... unterbricht Johnson den Anruf)]]
		-- 13) ---
		task_13_find_fiona_name = "Fiona finden"
		task_13_find_fiona_description = "Ich muss Fiona finden. Am besten suche ich nach Hinweisen bei den moeglichen Aufenthaltsorten."
		question_13_fionas_whereabouts = "Ich muss herausfinden, wo sie festgehalten wird."
		-- 14) Richtige Zone gefunden
		text_14_call_from_johnson_right_zone = [[Nicht schlecht! Gar nicht schlecht! Sie haben meine Spur gefunden. Ich bin beeindruckt. Sie sind wirklich ein hervorragender Troubleshooter!
Ein Mensch mit aussergewoehnlichen Faehigkeiten. Die Zeus Inc. benoetigt immer Mitarbeiter wie Sie! Aber nein... das ist nicht der Grund fuer Ihre Anwesenheit. Und nein, es ist auch nicht John Greenwitchs Tochter. Oh bitte, keine Angst. Ihr geht es gut. Ich bin kein Unmensch!
Ich will Ihnen etwas zeigen! Darum, sagen Sie mir: wie klang John Greenwitch, als er Ihnen von seiner Tochter erzaehlte? Hat er gebettelt? Hat er gewinselt? Sehen Sie sich nur an! Sie geben ALLES um nur ein einziges Menschenleben zu retten. Ein Kind, welches noch nicht einmal Ihr eigenes ist!
Weshalb tun Sie so etwas? Seinetwegen? Oder weil Sie Leben retten wollen? Glauben Sie mir, es stehen weit mehr Leben auf dem Spiel!
Nehmen Sie all sein Leid und all seine Sorgen und vertausendfachen Sie sie! Schon waehrend wir reden, sterben Unschuldige. Nur, weil Sie den Helden spielen mussten! Koennen Sie nach all dem noch immer die alleinige Verantwortung dafuer tragen?
Wissen Sie, ich habe Sie nicht ohne Grund an diesen Ort gefuehrt. Hier in der Naehe wohnt Frau Onekana. 46 Jahre. Geschieden. Auslandskorrespondentin. Hat ein unehelichen Sohn... Eine ganz normale Frau. Bis auf eines... SIE ist die erste Infizierte. 'Patient 0'.
Zur Zeit liegt sie im Krankenhaus in Quarantaene. Die Aerzte geben ihr vielleicht noch einen Tag. Was schaetzen Sie? Wie viele ihrer Nachbarn hat sie wohl bereits infiziert? Wie viele werden in den naechsten Wochen sterben? Und wie viele davon sind noch Kinder?
Verstehen Sie mich nicht falsch! John Greenwitchs Tochter ist in Sicherheit. Ich habe sie gehen lassen. Alles was ich brauchte, war Ihre ungeteilte Aufmerksamkeit. Die habe ich jetzt. Ich gebe Ihnen noch eine weitere Gelegenheit, das Richtige zu tun. Sie muessen mir helfen. Sie muessen uns ALLEN helfen. Arbeiten Sie mit mir zusammen - es gibt noch mehr Eltern, die Angst um ihre Kinder haben...]]
		-- 15) Peilsender angebracht - neuer Auftrag
		text_15_call_from_johnson_radio_tag = "... ich habe Greenwitchs Tochter ohne ihr Wissen mit einem Peilsender versehen. Sie wird sich mit ihrem Vater treffen wollen. Das ist unsere Gelegenheit, das Ganze doch noch zu einem guten Ende zu bringen. Ich werde Ihr Telefon so modifizieren, dass Sie ihre Position sehen koennen. Fuer alles Weitere werde ich einen Funkkanal mit Ihnen offen halten. Folgen Sie ihr unauffaellig und geben Sie mir Bescheid, wenn Sie Greenwitch gefunden haben! Er hat noch immer das Gegenmittel. Nun liegt alles an Ihnen! Einmal mehr. Treffen Sie Ihre Entscheidung! Unsere Zukunft liegt in Ihren Haenden!"
		-- 16) Tochter-Zone wandert
		text_16_track_fiona = "John Greenwitchs Tochter schaut sich nervoes um. Wenn sie sich beobachtet fuehlt, wird sie nicht zu ihrem Vater gehen. Besser ich folge ihr mit etwas Abstand."
		--[[
		Wie machen wir das hier? Erst Johnson, dann der Dialog?
		Dann muessen wir den nicht unterbrechen und 'ne Entscheidungslogik da rein quetschen.
		Aber cooler waere natuerlich, wenn die sich unterhalten und dann Johnson sagt, dass die Jungs kommen!
		Einfacher ist natuerlich, den Dialog da zu haben und unten
		2 Buttons "Eingreifen" und "Nicht eingreifen!" zu haben.
		--]]
		-- 17) Nachricht von Johnson. Er hat gemerkt, dass Fiona stehen geblieben ist.
		text_17_call_from_johnson_stay = "Sie ist stehen geblieben. Ich schaetze, sie hat ihn getroffen. Ich schicke meine Leute los. In etwa 4 Minuten ist alles geschafft! Unternehmen Sie nichts, bis wir ihn haben und halten Sie Abstand! Ich moechte nicht, dass er gewarnt wird!"
		-- 18) Tochter trifft John, Dialog der beiden
		timeout_18_greenwitch_meets_daughter = {}
		text_18_greenwitch_meets_daughter = {}
		--[[
		Vorstop Spielzeit: 238 sekunden - Genug zum Handeln und noch einmal eine gute Zusammenfassung der "Verantwortung",
		die der Spieler hier traegt. Mir gefaellt der Dialog! :-)
		
		(=> Sie hat Dich geliebt so wie ich Dich liebe!)
		... joa ist recht herzschmerzig :)
		
		-----------------------------------------------------------------------------------
		--]]
		text_18 = "Fiona trifft ihren Vater. Sie beginnen ein Gespraech."
		function accumulate_text_18(next_argument)
			text_18 = string.format([[%s
---
%s]], next_argument, text_18)
		end
		-- Greenwitch:[ueberrascht]
		timeout_18_greenwitch_meets_daughter[1] = 4
		text_18_greenwitch_meets_daughter[1] = [[John Greenwitch:
]].."Fio! Fiona? Bist Du das? Gott sei Dank! Bist Du verletzt?"
		-- Fiona: 
		timeout_18_greenwitch_meets_daughter[2] = 6
		text_18_greenwitch_meets_daughter[2] = [[Fiona:
]].."Oh gut, dass Du fragst. Mir geht es prima. Ich wurde nur mal eben entfuehrt. Uebrigens: Deinetwegen!"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[3] = 5
		text_18_greenwitch_meets_daughter[3] = [[John Greenwitch:
]].."Mein Gott, es tut mir Leid, mein Liebling! Verzeih mir! Es wird alles wieder gut! Ich verspreche es Dir!"
		-- Fiona:
		timeout_18_greenwitch_meets_daughter[4] = 3
		text_18_greenwitch_meets_daughter[4] = [[Fiona:
]].."Ich hasse es, wenn Du Dinge versprichst, die Du nicht halten wirst."
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[5] = 12
		text_18_greenwitch_meets_daughter[5] = [[John Greenwitch:
]].."Fio, ich weiss, Du gibst mir die Schuld daran. Aber es war dieser Johnson. Er allein ist dafuer verantwortlich. Eines Tages finde ich ihn. Und dann lasse ihn dafuer bezahlen was er Dir angetan hat! DAS verspreche ich Dir!"
		-- Fiona:
		timeout_18_greenwitch_meets_daughter[6] = 4
		text_18_greenwitch_meets_daughter[6] = [[Fiona:
]].."Mag sein, dass er mich entfuehrt hat. Aber was bitte hast Du getan, um mich da raus zu holen?"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[7] = 2
		text_18_greenwitch_meets_daughter[7] = [[John Greenwitch:
]].."Es ist bald vorbei!"
		-- Fiona: 
		timeout_18_greenwitch_meets_daughter[8] = 2
		text_18_greenwitch_meets_daughter[8] = [[Fiona:
]].."Was bitte soll das bedeuten?"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[9] = 12
		text_18_greenwitch_meets_daughter[9] = [[John Greenwitch:
]].."Ich habe das Gegenmittel bei mir. Ich muss es zum Krankenhaus bringen damit wir mehr davon herstellen koennen. Aber ich muss mich beeilen. Wir koennen niemandem trauen. Johnson wird alles tun, um es in seine Finger zu bekommen und wird er es verkaufen."
		-- Fiona:
		timeout_18_greenwitch_meets_daughter[10] = 3
		text_18_greenwitch_meets_daughter[10] = [[Fiona:
]].."Verdammt nochmal! Na und, dann soll er es doch verkaufen!"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[11] = 7
		text_18_greenwitch_meets_daughter[11] = [[John Greenwitch:
]].."Versteh doch, Fio. Er denkt nur an sein Geld. Aber das bekommt er nur, so lange er der Einzige ist, der das Gegenmittel produzieren kann."
		timeout_18_greenwitch_meets_daughter[12] = 7
		text_18_greenwitch_meets_daughter[12] = [[John Greenwitch:
]]..[[So lange ich weiss, wie man es herstellt, wird er uns jagen.
Es... es tut mir leid, dass ich Dich mit hineingezogen habe!]]
		-- Fiona: [zynisch] 
		timeout_18_greenwitch_meets_daughter[13] = 6
		text_18_greenwitch_meets_daughter[13] = [[Fiona:
]].."Oh, gut! Er wird uns also umbringen! Das macht es natuerlich viel besser! Glaubst Du, Mom haette auch so gehandelt?"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[14] = 7
		text_18_greenwitch_meets_daughter[14] = [[John Greenwitch:
]].."Deine Mutter hat an das geglaubt, was wir getan haben. Was wir... was ICH immer noch tue! Sie glaubte an unsere Verantwortung."
		-- Fiona:
		timeout_18_greenwitch_meets_daughter[15] = 7
		text_18_greenwitch_meets_daughter[15] = [[Fiona:
]].."Ach ja? Hat sie vielleicht auch etwas ueber Verantwortung gegenueber der eigenen Familie gesagt? Ich glaube nicht, dass sie gerade stolz auf Dich waere."
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[16] = 9
		text_18_greenwitch_meets_daughter[16] = [[John Greenwitch:
]].."Du irrst Dich. Wenn Du Deine Mutter so gekannt haettest, wie ich sie damals kennen gelernt habe... Ach Gott, Du wuesstest, dass ihr alle Menschen wichtig waren. Fuer sie war Naechstenliebe keine Frage des Geldes."
		timeout_18_greenwitch_meets_daughter[17] = 13
		text_18_greenwitch_meets_daughter[17] = [[John Greenwitch:
]].."Und sie hat sich niemals von denen abhalten lassen, die anders dachten. Deine Mutter war niemand, die einfach davon lief. Sie tat was sie fuer notwendig hielt. Auch wenn es bedeuten sollte, dass sie vielleicht niemals ihre eigene Tochter aufwachsen sehen wuerde."
		-- Fiona: [wuetend]
		timeout_18_greenwitch_meets_daughter[18] = 11
		text_18_greenwitch_meets_daughter[18] = [[Fiona:
]]..[[Nein! Das geschah, weil Du nicht auf sie aufpassen konntest!
Sieh Dich nur an! Ich werde entfuehrt und was tust Du? Statt nach Deiner eigenen Tochter zu suchen, rennst Du zum Krankenhaus um Gott zu spielen.]]
		timeout_18_greenwitch_meets_daughter[19] = 10
		text_18_greenwitch_meets_daughter[19] = [[Fiona:
]].."Wenn es nach Dir ginge, waere ich jetzt auch irgendwo wie ein Hund verscharrt. Ist es das, was Du willst? Bist Du erst zufrieden, wenn niemand mehr da ist? Damit Du in aller Ruhe 'die Welt retten' kannst?"
		timeout_18_greenwitch_meets_daughter[20] = 12
		text_18_greenwitch_meets_daughter[20] = [[Fiona:
]].."Und spaeter kannst Du jedem erzaehlen, was fuer ein Held Du warst! Welch furchtbaren Verlust Du dafuer auf Dich nehmen musstest! Nein, Du machst es Dir zu leicht! DU ALLEIN bist Schuld an ihrem Tod!"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[21] = 8
		text_18_greenwitch_meets_daughter[21] = [[John Greenwitch:
]].."Was denn? Was? Glaubst Du ich wuerde sie nicht auch jeden Tag vermissen? Aber Du hast recht... vielleicht habe ich Fehler begangen. Wer weiss?"
		timeout_18_greenwitch_meets_daughter[22] = 13
		text_18_greenwitch_meets_daughter[22] = [[John Greenwitch:
]].."Es vergeht kein Tag, an dem ich mir nicht selbst die Schuld fuer ihren Tod gebe. Aber wir muessen lernen, mit den Konsequenzen unserer Entscheidungen zu leben! Und genau deswegen koennen wir nicht einfach unsere Augen verschliessen und hoffen, dass alles irgendwann wieder besser wird. Denn das wird es nicht!"
		timeout_18_greenwitch_meets_daughter[23] = 7
		text_18_greenwitch_meets_daughter[23] = [[John Greenwitch:
]]..[[Es wird immer nur schlimmer.
Wir muessen dafuer kaempfen, was uns wichtig ist! Du bist das Wichtigste in meinem Leben, Fio! Immer!]]
		timeout_18_greenwitch_meets_daughter[24] = 14
		text_18_greenwitch_meets_daughter[24] = (([[John Greenwitch:
]]..[[Und wir muessen uns bei jeder Entscheidung fragen, auf welcher Seite wir stehen und ob wir das Richtige tun.
Und irgendwann wenn all das hier vorueber ist, und Du auf diese Zeit zurueckblickst, wirst Du vielleicht erkennen warum ich das hier tun musste. Auch wenn es schmerzt.

]])..[[Fiona:
]]).."Papa!"
		-- Fiona:
		timeout_18_greenwitch_meets_daughter[25] = 3
		text_18_greenwitch_meets_daughter[25] = [[Fiona:
]].."Lass uns einfach weglaufen und ein normales Leben fuehren!"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[26] = 8
		text_18_greenwitch_meets_daughter[26] = [[John Greenwitch:
]].."Er wird uns finden. Er wird... mich... ueberall finden. Du hast Recht, ich habe Dich schon zu sehr in Gefahr gebracht!"
		timeout_18_greenwitch_meets_daughter[27] = 8
		text_18_greenwitch_meets_daughter[27] = (([[John Greenwitch:
]]..[[Es gibt nur eine Loesung. Du musst ohne mich fliehen. Lauf weg! Erzaehl niemandem, wo Du bist. Nicht einmal mir. Und bleib dort, bis alles vorueber ist!

]])..[[Fiona:
]]).."Nein!"
		-- Fiona: [zitternd]
		timeout_18_greenwitch_meets_daughter[28] = 5
		text_18_greenwitch_meets_daughter[28] = [[Fiona:
]].."Ich musste schon ohne Mutter aufwachsen. Ich kann nicht auch noch ohne Vater leben!"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[29] = 5
		text_18_greenwitch_meets_daughter[29] = [[John Greenwitch:
]].."Wenn ich nicht zu Ende bringe, was ich begonnen habe, werden noch viele Toechter ohne ihre Eltern aufwachsen muessen ..."
		timeout_18_greenwitch_meets_daughter[30] = 2
		text_18_greenwitch_meets_daughter[30] = [[John Greenwitch:
]].."Die Menschen brauchen mich!"
		-- Fiona:
		timeout_18_greenwitch_meets_daughter[31] = 3
		text_18_greenwitch_meets_daughter[31] = (((([[Fiona:
]]..[[Niemand braucht Dich ...

]])..[[John Greenwitch:
]])..[[Ach Fio!

]])..[[Fiona:
]]).."... Nein, hoer mir zu!"
		-- Fiona: 
		timeout_18_greenwitch_meets_daughter[32] = 11
		text_18_greenwitch_meets_daughter[32] = [[Fiona:
]].."Niemand braucht Dich... so sehr wie ich! Aber... ich verstehe, warum Du das tun musst! Und Du tust das Richtige!"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[33] = 4
		text_18_greenwitch_meets_daughter[33] = [[John Greenwitch:
]].."Weisst Du, wie sehr Du Deiner Mutter in solchen Momenten aehnelst?"
		timeout_18_greenwitch_meets_daughter[34] = 5
		text_18_greenwitch_meets_daughter[34] = (((([[John Greenwitch:
]]..[[Hach Gott, ich habe sie so geliebt ...

]])..[[Fiona:
]])..[[Ich liebe Dich, Papa!

]])..[[John Greenwitch:
]]).."Ich liebe Dich auch, mein Engel!"
		-- Greenwitch:
		timeout_18_greenwitch_meets_daughter[35] = 3
		text_18_greenwitch_meets_daughter[35] = [[John Greenwitch:
]].."Ich werde nicht zulassen, dass Dir etwas zustoesst ..."
		-- 19
		task_19_warn_greenwitch_or_wait_name = "Entscheidung"
		task_19_warn_greenwitch_or_wait_description = "Ich muss mich entscheiden! Entweder ich gehe zu John Greenwitch unterbreche sein Gespraech mit seiner Tochter um ihn zu warnen, oder ich warte ab, und lasse zu, dass ihn Mr. Johnsons Agenten ergreifen."
		text_19_warn_greenwitch = "Warnen!"
		text_19_cannot_warn_greenwitch = "Ich muss zu Greenwitch hingehen, um ihn zu warnen."
		text_19_cannot_warn_greenwitch_anymore = "Es ist zu spaet, um Greenwitch zu warnen."
		--[[
		-----------------------------------------------------------------------------------
		Wenn nicht vorher "EINGREIFEN" geklickt wurde (und die Zeit um ist):
		
		DER WAGEN KOMMT UND SCHNAPPT DIE BEIDEN (oder nur JOHN GREENWITCH???
		Bleibt noch 'n offener Handlungsfaden, wenn sie in Teil 3 ggf. nach ihrem Vater sucht ...)
		--]]
		-- A19) ---
		-- task_19_warn_greenwitch_or_wait -> "wait"
		-- A20) ---
		-- A21) Johnson ruft an und bedankt sich.
		text_21a_call_from_johnson_gratitude_traitors_end = [[Sehr gut, sehr gut. Ich danke Ihnen. Ich muss gestehen, ich hatte Zweifel, wem Ihre Loyalitaet gilt. Es freut mich umso mehr, zu erkennen, dass sie der ganzen Menschheit gilt.
Vielleicht schon in wenigen Wochen werden wir eine erste Serie des Gegenmittels herstellen koennen. Effizienter als es jedes lokale Krankenhaus jemals schaffen wuerde. Dank Ihres Einsatzes werden tausende Leben gerettet.
Sie haben das Richtige getan und ich bin froh, Sie in meinem Team zu wissen. Ich weiss, was jetzt folgt wird nicht einfach. Aber gemeinsam koennen wir viel bewegen. Ich verlasse mich auf Sie! Wir haben da einen toten Briefkasten. Ich hoffe, Sie werden diesmal endgueltig fuer uns arbeiten!]]
		-- ENDE VERRAeTER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		-- B19) ---
		-- task_19_warn_greenwitch_or_wait -> "warn"
		-- B20) Greenwitch bedankt sich
		--[[
		Gibt Zusammenfassung ueber den Plan.
		Gibt Spieler Gegenmittel und Task, ihn ins Krankenhaus zu bringen.
		Reden Sie auf jeden Fall mit unserer Kontaktperson dort!
		Er vernichtet den Peilsender und verschwindet.
		--]]
		text_20b_call_from_greenwitch_antidote = [[Sie hier? Ich verstehe. Danke!
Johnson kann nicht weit sein. Ich vermute, die wissen bereits von meinem Plan. Mit Ihrer Hilfe bin ich zuversichtlich.
Die suchen mich. Aber vielleicht nicht Sie...
Sie muessen dieses Gegenmittel zum Krankenhaus bringen. Passen Sie auf Johnsons Schergen auf. Wenn die Sie in die Finger kriegen, haben wir alles verloren.
Aber bedenken Sie, was es zu gewinnen gibt, wenn wir das Gegenmittel im Krankenhaus synthetisieren koennen. Wir werden Menschen retten! Also los, verlieren wir keine Zeit. Beeilen Sie sich!]]
		item_20b_minigame_rules_name = "Minigame-Regeln"
		item_20b_minigame_rules_description = "Kurze Anleitung, wie man Mr. Johnsons Schergen ausweicht. ACHTUNG: Das Spiel wird dabei nicht pausiert!"
		item_20b_minigame_rules_content = ((([[Zunaechst eine allgemeine Information und eine Warnung: Die hier beschrieben Regeln kannst du dir jederzeit nochmal anschauen. ABER: Nur beim ersten Mal wird dabei auch das Spiel pausiert. Mr. Johnson hetzt seine Schergen auf dich und du musst denen ausweichen. Gelingt das nicht, ist das Gegengift verloren. Dieses Minispiel funktioniert mit bestimmten Arten von Zonen. Wir empfehlen daher, diesen Teil des Spiels ausschliesslich mit der Karte zu spielen.

]]..[[Umgebende Zone: Das ist die Spielfeldbegrenzung. Diese Zone ist am staerksten ueberwacht und darf auf gar keinen Fall betreten werden.

]])..[[Fuenfeckige Zone: Das ist ein Helikopter, der dir folgt. Falls er dich erreicht, du also innerhalb der fuenfeckigen Zone bist, sucht er genauer und wenn er dich findet, hetzt er alle Vans auf dich. Du hast etwa eine Minute, diesen Suchbereich wieder zu verlassen. Der Helikopter wird dir nach einer Weile wieder folgen.

]])..[[Rechteckige Zone: Dies ist eine Strassensperre bestehend aus schwarzen Vans. Diese Zone darfst du auf keinen Fall betreten.

]]).."Dreieckige Zone: Das ist ein patroullierender Agent, der nach dir sucht. Auch diese Zone darf auf keinen Fall betreten werden."
		item_20b_command_view_caption = "Anschauen"
		task_20b_bring_antidote_to_hospital_name = "Gegenmittel in Krankenhaus bringen"
		task_20b_bring_antidote_to_hospital_description = "Ich muss das Gegenmittel so schnell wie moeglich ins Krankenhaus bringen. Johnsons Leute werden mir hinterher sein"
		item_20_antidote_name = "Gegenmittel"
		item_20_antidote_description = "Ein Gegenmittel-Prototyp. Er neutralisiert das Virus in seiner jetzigen Form. Doch es mutiert schnell und Johnsen ist mir auf den Fersen. Ich muss es so schnell wie moeglich John Greenwitchs Kontaktperson im Krankenhaus uebergeben, damit es in Massen synthetisiert werden kann."
		-- B21) Nachricht von Johnson: Er schickt seine Schergen los!
		text_21b_call_from_johnson_threat = [[Hmm, das verletzt mich... ich hatte gehofft, Sie waeren ein Mensch, der aus seinen Fehlern lernen kann. Aber offenbar ist es Ihnen lieber, sich weiter als Rebell zu sehen.
Nun, ich habe Wichtigeres zu tun als mich mit einem Egoisten, wie Ihnen abzugeben. Bleiben Sie wo Sie sind und geben Sie das Gegenmittel einem meiner Agenten. Andernfalls muss ich Sie als Bedrohung der Zeus Inc. betrachten.]]
		-- B22) Johnsons Schergen entkommen
		-- C23) Im Krankenhaus angekommen
		text_23c_reaching_hospital_heroes_end = [[Hey, hier drueben! Sind Sie der Troubleshooter? Ich hatte Greenwitch erwartet. Man kann niemandem mehr trauen. Haben Sie das Gegenmittel? Fantastisch! Ich werde mich gleich darum kuemmern, es weiter zu synthetisieren. Wir retten Leben!
Ich weiss gar nicht, wie ich Ihnen genug danken kann. Aber es gibt keinen Grund unvorsichtig zu werden. Gerade jetzt muessen wir wachsam bleiben.
Der alte tote Briefkasten ist zu unsicher geworden. Der neue befindet sich an den folgenden Koordinaten. Ach und noch etwas... Ich glaube, ich spreche auch im Namen von Frau Onekana. Sie retten ihr Leben: Danke! Man bekommt nicht oft eine zweite Chance!]]
		-- HELDEN ENDE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		-- D23) Johnsons Schergen nicht entkommen. Gegenmittel verloren
		-- D24) Am Krankenhaus angekommen
		--[[
		Am Krankenhaus wartet eine Aerztin (in Person):
		--]]
		text_24d_reaching_hospital_mourners_end = [[Hey hier drueben! Was... Oh nein! Was ist passiert? Wie sehen Sie denn aus? Wo ist das Gegenmittel?
Oh, verflucht! Das war ihre einzige Chance! Sie wird die Nacht nicht ueberleben... Ich habe noch eine Bitte an Sie: Beten Sie fuer Frau Onekana.
Es... es gibt da ein Kondolenzbuch. Sie hatte nicht viele Freunde aber vielleicht moechten Sie ja ein paar Worte fuer sie hinterlassen. Ein letzter Moment in stillem Gedenken, bevor wir - schon bald - noch viel dunkleren Zeiten entgegentreten ...]]
		-- ENDE TRAUERGAeSTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		-- Completion Code
		item_completion_code_name = "Completion Code"
		item_completion_code_description = "Den Completion Code can man bei wherigo.com eingeben. Er ist fuer jeden Spieler eindeutig!"
		item_completion_code_command_view_caption = "Anzeigen"
		-- Credits
		item_credits_name = "Credits"
		item_credits_description = "Wer hat GC57EJE realisiert?"
		item_credits_command_view_caption = "Credits zeigen"
		item_credits_text = (((((((((([[Ende

]]..[[Vielen Dank fuer das Durchspielen unseres Spiels. Wir hoffen ihr hattet viel Spass damit, denn eine Menge Leute haben Ihre Freizeit geopfert, um GC57EJE zu realisieren:

]])..[[DRAMATIS PERSONAE

]])..[[John Greenwitch
     Dave
]])..[[Fiona Greenwitch
     Usurpatorchen
]])..[[Mr. Johnson
     Mahanako
]])..[[Arzt
     Anastasia Reich
]])..[[Nachrichtensprecher
     Mathias Reich
]])..[[
]])..[[STORY
     Dave und Mahanako]])..[[KAMERA
     Dave
]])..[[PROGRAMMIERUNG
     Mahanako]]
	end, 
	[4] = function()
		zone_meet_greenwitch_name = "Treffen mit Greenwitch"
		zone_09_meet_greenwitch_description = "John Greenwitch moechte, dass wir uns hier treffen"
		zone_10_shake_off_pursuers_name = "Beobachtetes Gebiet"
		zone_10_shake_off_pursuers_description = "Ich werde beobachtet. Ich muss diesen Bereich so schnell wie moeglich verlassen."
		zone_11_meet_greenwitch_description = "Hier treffe ich mich mit John Greenwitch. Allerdings nur dann, wenn ich meine Verfolger abgeschuettelt habe."
		zone_13_fionas_whereabouts_name = "Moeglicher Aufenthaltsort von Fiona"
		zone_13_fionas_whereabouts_description = "Den Hinweisen nach, ist das einer der Orte, wo Fiona sein koennte."
		zone_16_fiona_name = "Fiona"
		zone_16_fiona_description = "Ich darf Fiona nicht zu nahe kommen."
		zone_18_greenwitch_meets_daughter_name = "John Greenwitch und Fiona"
		zone_18_greenwitch_meets_daughter_description = "John Greenwitch unterhaelt sich mit seiner Tochter Fiona. Ich koennte beide davor warnen, dass Johnson's Leute gleich kommen, oder einfach abwarten und es geschehen lassen."
		zone_21a_traitors_end_name = "Toter Briefkasten"
		zone_21a_traitors_end_description = [[Hier irgendwo befindet sich ein toter Briefkasten, bei dem ich mich als neuer Mitarbeiter fuer die Zeus Incorporated eintragen kann.

]].."Hinweis: Augenhoehe, zertrampelt kein Buschwerk."
		zone_22_helicopter_name = "Zeus Inc. Helikopter"
		zone_22_helicopter_description = "Der Hubschrauber der Zeus Inc. sucht nach mir, wenn er mich ueberfliegt, muss ich seinem Sichtbereich so schnell wie moeglich wieder entkommen."
		zone_22_road_block_name = "Strassensperre"
		zone_22_road_block_description = "Mr. Johnson hat dort ein paar Vans zur Beobachtung der Strasse abgestellt. Ich muss einen anderen Weg finden und darf den Vans auf keinen Fall zu nahe kommen."
		zone_22_agents_name = "Zeus Inc. Agent"
		zone_22_agents_description = "Einer von Mr. Johnsons Agenten. Ich muss an ihm vorbei schleichen. Ich darf ihm nicht zu nahe kommen."
		zone_23_hospital_name = "Krankenhaus"
		zone_23_hospital_description = "Hier wird John Greenwitch's Kontaktperson, ein Arzt, auf mich warten. Dieser Kontaktperson muss ich das Gegenmittel uebergeben."
		zone_23c_heroes_end_name = "Toter Briefkasten"
		zone_23c_heroes_end_description = [[Hier irgendwo befindet sich ein toter Briefkasten, bei dem ich mich eintragen kann.

]].."Hinweis: Augenhoehe, zertrampelt kein Buschwerk."
		zone_24d_mourners_end_name = "Kondolenzbuch"
		zone_24d_mourners_end_description = [[Hier befindet sich das Kondolenzbuch fuer Frau Onekana. Ich sollte mich einschreiben und mich wenigstens an ihren vollstaendigen Namen erinnern.

]].."Hinweis: Bitte verhaltet Euch dem Ort angemessen. Gedenkt im Sitzen. Gebuesche muessen gar nicht betreten werden."
	end
}

-- Begin user directives --
_Urwigo.InlineRequire(0)
_Urwigo.InlineRequire(1)
_Urwigo.InlineRequire(2)
_Urwigo.InlineRequire(3)
_Urwigo.InlineRequire(4)

-- End user directives --

prometheus_chapter_2 = Wherigo.ZCartridge()

-- Media --
img_zone_hospital = Wherigo.ZMedia(prometheus_chapter_2)
img_zone_hospital.Id = "98908595-2357-4a30-8452-3d8d8eb2db90"
img_zone_hospital.Name = _Mzr2("\100\071\050\057\060\063\062\028\057\072\063\124\016\100\085\092\040")
img_zone_hospital.Description = ""
img_zone_hospital.AltText = ""
img_zone_hospital.Resources = {
	{
		Type = "gif", 
		Filename = "hospital.gif", 
		Directives = {}
	}
}
img_footprints = Wherigo.ZMedia(prometheus_chapter_2)
img_footprints.Id = "7a187241-400c-4031-93b9-c9a37f836025"
img_footprints.Name = _Mzr2("\100\071\050\057\041\063\063\085\016\019\100\062\085\124")
img_footprints.Description = ""
img_footprints.AltText = ""
img_footprints.Resources = {
	{
		Type = "png", 
		Filename = "footprints.png", 
		Directives = {}
	}
}
img_memo = Wherigo.ZMedia(prometheus_chapter_2)
img_memo.Id = "b9e52ba0-d613-4de5-bbc8-2cb8dc0639be"
img_memo.Name = _Mzr2("\100\071\050\057\071\028\071\063")
img_memo.Description = ""
img_memo.AltText = _Mzr2("\038\028\071\063")
img_memo.Resources = {
	{
		Type = "jpg", 
		Filename = "memo.jpg", 
		Directives = {}
	}
}
icon_memo = Wherigo.ZMedia(prometheus_chapter_2)
icon_memo.Id = "09f0e490-6486-4a0e-b7f8-43532cf81475"
icon_memo.Name = _Mzr2("\100\093\063\062\057\071\028\071\063")
icon_memo.Description = ""
icon_memo.AltText = _Mzr2("\038\028\071\063")
icon_memo.Resources = {
	{
		Type = "png", 
		Filename = "icon_memo.png", 
		Directives = {}
	}
}
img_incoming_call = Wherigo.ZMedia(prometheus_chapter_2)
img_incoming_call.Id = "9f4e480a-d3fb-426c-8c44-ea0042d3c397"
img_incoming_call.Name = _Mzr2("\100\071\050\057\100\062\093\063\071\100\062\050\057\093\092\040\040")
img_incoming_call.Description = ""
img_incoming_call.AltText = ""
img_incoming_call.Resources = {
	{
		Type = "jpg", 
		Filename = "incoming_call.jpg", 
		Directives = {}
	}
}
sound_phone_ring = Wherigo.ZMedia(prometheus_chapter_2)
sound_phone_ring.Id = "e196878b-07e7-4480-b483-ca3ea859198d"
sound_phone_ring.Name = _Mzr2("\124\063\073\062\009\057\016\072\063\062\028\057\019\100\062\050")
sound_phone_ring.Description = ""
sound_phone_ring.AltText = ""
sound_phone_ring.Resources = {
	{
		Type = "wav", 
		Filename = "phone_ring.wav", 
		Directives = {}
	}
}
sound_phone_ring_garmin = Wherigo.ZMedia(prometheus_chapter_2)
sound_phone_ring_garmin.Id = "14f8306b-1090-4eda-b024-c28fa9aa98ef"
sound_phone_ring_garmin.Name = _Mzr2("\124\063\073\062\009\057\016\072\063\062\028\057\019\100\062\050\057\050\092\019\071\100\062")
sound_phone_ring_garmin.Description = ""
sound_phone_ring_garmin.AltText = ""
sound_phone_ring_garmin.Resources = {
	{
		Type = "fdl", 
		Filename = "phone_ring_garmin.fdl", 
		Directives = {}
	}
}
img_mr_johnson = Wherigo.ZMedia(prometheus_chapter_2)
img_mr_johnson.Id = "545bb132-3b49-4f0f-b67b-39caecda824d"
img_mr_johnson.Name = _Mzr2("\100\071\050\057\071\019\057\069\063\072\062\124\063\062")
img_mr_johnson.Description = ""
img_mr_johnson.AltText = _Mzr2("\038\019\026\053\037\063\072\062\124\063\062")
img_mr_johnson.Resources = {
	{
		Type = "jpg", 
		Filename = "mr_johnson.jpg", 
		Directives = {}
	}
}
audio_02_call_from_johnson_1_1 = Wherigo.ZMedia(prometheus_chapter_2)
audio_02_call_from_johnson_1_1.Id = "41fc3047-dea4-4862-9dd5-51db6d3f410c"
audio_02_call_from_johnson_1_1.Name = _Mzr2("\092\073\009\100\063\057\027\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\098\057\098")
audio_02_call_from_johnson_1_1.Description = ""
audio_02_call_from_johnson_1_1.AltText = ""
audio_02_call_from_johnson_1_1.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_02_call_from_johnson_1_1.mp3", 
		Directives = {}
	}
}
audio_04_call_from_johnson_1_2 = Wherigo.ZMedia(prometheus_chapter_2)
audio_04_call_from_johnson_1_2.Id = "ea1de4c1-d712-4c60-8fcb-e2bee8f38925"
audio_04_call_from_johnson_1_2.Name = _Mzr2("\092\073\009\100\063\057\027\065\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\098\057\020")
audio_04_call_from_johnson_1_2.Description = ""
audio_04_call_from_johnson_1_2.AltText = ""
audio_04_call_from_johnson_1_2.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_04_call_from_johnson_1_2.mp3", 
		Directives = {}
	}
}
audio_06a_call_from_johnson_daughter_abducted = Wherigo.ZMedia(prometheus_chapter_2)
audio_06a_call_from_johnson_daughter_abducted.Id = "eb1a6b67-496d-428a-bfb5-3f51e433dee3"
audio_06a_call_from_johnson_daughter_abducted.Name = _Mzr2("\092\073\009\100\063\057\027\029\092\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\009\092\073\050\072\085\028\019\057\092\119\009\073\093\085\028\009")
audio_06a_call_from_johnson_daughter_abducted.Description = ""
audio_06a_call_from_johnson_daughter_abducted.AltText = ""
audio_06a_call_from_johnson_daughter_abducted.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_06a_call_from_johnson_daughter_abducted.mp3", 
		Directives = {}
	}
}
audio_14_call_from_johnson_right_zone = Wherigo.ZMedia(prometheus_chapter_2)
audio_14_call_from_johnson_right_zone.Id = "d5bb8abf-d928-4e97-80eb-5514ce42330f"
audio_14_call_from_johnson_right_zone.Name = _Mzr2("\092\073\009\100\063\057\098\065\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\019\100\050\072\085\057\060\063\062\028")
audio_14_call_from_johnson_right_zone.Description = ""
audio_14_call_from_johnson_right_zone.AltText = ""
audio_14_call_from_johnson_right_zone.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_14_call_from_johnson_right_zone.mp3", 
		Directives = {}
	}
}
audio_15_call_from_johnson_radio_tag = Wherigo.ZMedia(prometheus_chapter_2)
audio_15_call_from_johnson_radio_tag.Id = "3f355a52-1a0d-417d-ba79-c59f88f87e1f"
audio_15_call_from_johnson_radio_tag.Name = _Mzr2("\092\073\009\100\063\057\098\012\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\019\092\009\100\063\057\085\092\050")
audio_15_call_from_johnson_radio_tag.Description = ""
audio_15_call_from_johnson_radio_tag.AltText = ""
audio_15_call_from_johnson_radio_tag.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_15_call_from_johnson_radio_tag.mp3", 
		Directives = {}
	}
}
audio_17_call_from_johnson_stay = Wherigo.ZMedia(prometheus_chapter_2)
audio_17_call_from_johnson_stay.Id = "bb624655-e6cf-438f-a4b9-5c8d9acac6c5"
audio_17_call_from_johnson_stay.Name = _Mzr2("\092\073\009\100\063\057\098\007\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\124\085\092\054")
audio_17_call_from_johnson_stay.Description = ""
audio_17_call_from_johnson_stay.AltText = ""
audio_17_call_from_johnson_stay.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_17_call_from_johnson_stay.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_01 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_01.Id = "2309489a-fd4f-4474-ad94-5efd9576bc4f"
audio_18_greenwitch_meets_daughter_01.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\098")
audio_18_greenwitch_meets_daughter_01.Description = ""
audio_18_greenwitch_meets_daughter_01.AltText = ""
audio_18_greenwitch_meets_daughter_01.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_01.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_02 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_02.Id = "78404dd7-fcfe-4763-b541-ee415283f417"
audio_18_greenwitch_meets_daughter_02.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\020")
audio_18_greenwitch_meets_daughter_02.Description = ""
audio_18_greenwitch_meets_daughter_02.AltText = ""
audio_18_greenwitch_meets_daughter_02.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_02.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_03 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_03.Id = "ceed0d07-8d53-48d0-be50-9e1def0ea76c"
audio_18_greenwitch_meets_daughter_03.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\046")
audio_18_greenwitch_meets_daughter_03.Description = ""
audio_18_greenwitch_meets_daughter_03.AltText = ""
audio_18_greenwitch_meets_daughter_03.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_03.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_04 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_04.Id = "e3c3a045-903a-4ce1-869c-b8e2cfe0d284"
audio_18_greenwitch_meets_daughter_04.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\065")
audio_18_greenwitch_meets_daughter_04.Description = ""
audio_18_greenwitch_meets_daughter_04.AltText = ""
audio_18_greenwitch_meets_daughter_04.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_04.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_05 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_05.Id = "d7446ec4-eaf6-43cc-a1db-42b62f6fb920"
audio_18_greenwitch_meets_daughter_05.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\012")
audio_18_greenwitch_meets_daughter_05.Description = ""
audio_18_greenwitch_meets_daughter_05.AltText = ""
audio_18_greenwitch_meets_daughter_05.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_05.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_06 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_06.Id = "83752729-585c-4929-8420-2256dd32a8b6"
audio_18_greenwitch_meets_daughter_06.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\029")
audio_18_greenwitch_meets_daughter_06.Description = ""
audio_18_greenwitch_meets_daughter_06.AltText = ""
audio_18_greenwitch_meets_daughter_06.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_06.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_07 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_07.Id = "2b3a82e3-a589-4521-900f-f06f2e398ee5"
audio_18_greenwitch_meets_daughter_07.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\007")
audio_18_greenwitch_meets_daughter_07.Description = ""
audio_18_greenwitch_meets_daughter_07.AltText = ""
audio_18_greenwitch_meets_daughter_07.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_07.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_08 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_08.Id = "29bda117-482d-4e2e-8b90-d09208d6f5d5"
audio_18_greenwitch_meets_daughter_08.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\091")
audio_18_greenwitch_meets_daughter_08.Description = ""
audio_18_greenwitch_meets_daughter_08.AltText = ""
audio_18_greenwitch_meets_daughter_08.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_08.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_09 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_09.Id = "54227d0f-3ed0-474c-ac98-04141a62a4ae"
audio_18_greenwitch_meets_daughter_09.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\027\116")
audio_18_greenwitch_meets_daughter_09.Description = ""
audio_18_greenwitch_meets_daughter_09.AltText = ""
audio_18_greenwitch_meets_daughter_09.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_09.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_10 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_10.Id = "8c1fd3d2-cfae-460b-9797-fd4f6bd3bc1c"
audio_18_greenwitch_meets_daughter_10.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\027")
audio_18_greenwitch_meets_daughter_10.Description = ""
audio_18_greenwitch_meets_daughter_10.AltText = ""
audio_18_greenwitch_meets_daughter_10.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_10.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_11 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_11.Id = "ac5053b5-9f02-486d-a4d7-3ad182306634"
audio_18_greenwitch_meets_daughter_11.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\098")
audio_18_greenwitch_meets_daughter_11.Description = ""
audio_18_greenwitch_meets_daughter_11.AltText = ""
audio_18_greenwitch_meets_daughter_11.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_11.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_12 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_12.Id = "8c06ae6d-2836-4cea-b401-4c4bf05aa9aa"
audio_18_greenwitch_meets_daughter_12.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\020")
audio_18_greenwitch_meets_daughter_12.Description = ""
audio_18_greenwitch_meets_daughter_12.AltText = ""
audio_18_greenwitch_meets_daughter_12.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_12.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_13 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_13.Id = "54a3922a-dd93-4aaf-b42c-efbe4a4c363f"
audio_18_greenwitch_meets_daughter_13.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\046")
audio_18_greenwitch_meets_daughter_13.Description = ""
audio_18_greenwitch_meets_daughter_13.AltText = ""
audio_18_greenwitch_meets_daughter_13.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_13.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_14 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_14.Id = "38203d66-9d7c-4e41-8509-214cc223e483"
audio_18_greenwitch_meets_daughter_14.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\065")
audio_18_greenwitch_meets_daughter_14.Description = ""
audio_18_greenwitch_meets_daughter_14.AltText = ""
audio_18_greenwitch_meets_daughter_14.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_14.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_15 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_15.Id = "37cf39e0-9550-44cd-89b6-a5e6d3366007"
audio_18_greenwitch_meets_daughter_15.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\012")
audio_18_greenwitch_meets_daughter_15.Description = ""
audio_18_greenwitch_meets_daughter_15.AltText = ""
audio_18_greenwitch_meets_daughter_15.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_15.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_16 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_16.Id = "ad4d2fb5-5d4d-4493-bec2-327d383d999d"
audio_18_greenwitch_meets_daughter_16.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\029")
audio_18_greenwitch_meets_daughter_16.Description = ""
audio_18_greenwitch_meets_daughter_16.AltText = ""
audio_18_greenwitch_meets_daughter_16.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_16.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_17 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_17.Id = "a3fe62cb-f5cb-4aa7-b63d-69d4fc03e64d"
audio_18_greenwitch_meets_daughter_17.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\007")
audio_18_greenwitch_meets_daughter_17.Description = ""
audio_18_greenwitch_meets_daughter_17.AltText = ""
audio_18_greenwitch_meets_daughter_17.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_17.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_18 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_18.Id = "03a98d85-6027-40b0-a536-ba0656d909f9"
audio_18_greenwitch_meets_daughter_18.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\091")
audio_18_greenwitch_meets_daughter_18.Description = ""
audio_18_greenwitch_meets_daughter_18.AltText = ""
audio_18_greenwitch_meets_daughter_18.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_18.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_19 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_19.Id = "891d9604-34ca-41d5-808b-14f76822c509"
audio_18_greenwitch_meets_daughter_19.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\098\116")
audio_18_greenwitch_meets_daughter_19.Description = ""
audio_18_greenwitch_meets_daughter_19.AltText = ""
audio_18_greenwitch_meets_daughter_19.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_19.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_20 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_20.Id = "dfa4fce6-52da-4a90-8019-11b73ada1bd1"
audio_18_greenwitch_meets_daughter_20.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\027")
audio_18_greenwitch_meets_daughter_20.Description = ""
audio_18_greenwitch_meets_daughter_20.AltText = ""
audio_18_greenwitch_meets_daughter_20.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_20.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_21 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_21.Id = "08ea3b78-649f-4df6-9373-0e2e5d1b9377"
audio_18_greenwitch_meets_daughter_21.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\098")
audio_18_greenwitch_meets_daughter_21.Description = ""
audio_18_greenwitch_meets_daughter_21.AltText = ""
audio_18_greenwitch_meets_daughter_21.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_21.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_22 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_22.Id = "5ff23ac3-c002-4c2e-8903-a35d0cf5ab73"
audio_18_greenwitch_meets_daughter_22.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\020")
audio_18_greenwitch_meets_daughter_22.Description = ""
audio_18_greenwitch_meets_daughter_22.AltText = ""
audio_18_greenwitch_meets_daughter_22.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_22.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_23 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_23.Id = "c0526010-c386-452d-9fb1-6814d7e37ecb"
audio_18_greenwitch_meets_daughter_23.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\046")
audio_18_greenwitch_meets_daughter_23.Description = ""
audio_18_greenwitch_meets_daughter_23.AltText = ""
audio_18_greenwitch_meets_daughter_23.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_23.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_24 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_24.Id = "be76612c-376d-4a52-a634-2dab2feb065f"
audio_18_greenwitch_meets_daughter_24.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\065")
audio_18_greenwitch_meets_daughter_24.Description = ""
audio_18_greenwitch_meets_daughter_24.AltText = ""
audio_18_greenwitch_meets_daughter_24.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_24.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_25 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_25.Id = "989d0690-7f06-4607-8d3d-5506d6adba65"
audio_18_greenwitch_meets_daughter_25.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\012")
audio_18_greenwitch_meets_daughter_25.Description = ""
audio_18_greenwitch_meets_daughter_25.AltText = ""
audio_18_greenwitch_meets_daughter_25.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_25.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_26 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_26.Id = "afa7024f-12cb-4f25-8957-bd44e7a9f50f"
audio_18_greenwitch_meets_daughter_26.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\029")
audio_18_greenwitch_meets_daughter_26.Description = ""
audio_18_greenwitch_meets_daughter_26.AltText = ""
audio_18_greenwitch_meets_daughter_26.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_26.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_27 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_27.Id = "08b8c1ec-c58f-4350-b617-6ad04d027f7a"
audio_18_greenwitch_meets_daughter_27.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\007")
audio_18_greenwitch_meets_daughter_27.Description = ""
audio_18_greenwitch_meets_daughter_27.AltText = ""
audio_18_greenwitch_meets_daughter_27.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_27.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_28 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_28.Id = "10f60ab8-b0ba-4290-a74c-0774035f3403"
audio_18_greenwitch_meets_daughter_28.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\091")
audio_18_greenwitch_meets_daughter_28.Description = ""
audio_18_greenwitch_meets_daughter_28.AltText = ""
audio_18_greenwitch_meets_daughter_28.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_28.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_29 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_29.Id = "394987b2-ea8d-4504-95d9-4d4b0c0e0659"
audio_18_greenwitch_meets_daughter_29.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\020\116")
audio_18_greenwitch_meets_daughter_29.Description = ""
audio_18_greenwitch_meets_daughter_29.AltText = ""
audio_18_greenwitch_meets_daughter_29.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_29.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_30 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_30.Id = "3e0057d9-24be-4db1-a1ae-96794f39a624"
audio_18_greenwitch_meets_daughter_30.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\046\027")
audio_18_greenwitch_meets_daughter_30.Description = ""
audio_18_greenwitch_meets_daughter_30.AltText = ""
audio_18_greenwitch_meets_daughter_30.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_30.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_31 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_31.Id = "31c66073-3c38-4d80-946a-b01c58d18bb2"
audio_18_greenwitch_meets_daughter_31.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\046\098")
audio_18_greenwitch_meets_daughter_31.Description = ""
audio_18_greenwitch_meets_daughter_31.AltText = ""
audio_18_greenwitch_meets_daughter_31.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_31.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_32 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_32.Id = "2a5b1637-6b32-475c-8f34-e57bbe68e104"
audio_18_greenwitch_meets_daughter_32.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\046\020")
audio_18_greenwitch_meets_daughter_32.Description = ""
audio_18_greenwitch_meets_daughter_32.AltText = ""
audio_18_greenwitch_meets_daughter_32.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_32.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_33 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_33.Id = "8461fe7e-9906-4d39-b4d4-46edce5e1cd1"
audio_18_greenwitch_meets_daughter_33.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\046\046")
audio_18_greenwitch_meets_daughter_33.Description = ""
audio_18_greenwitch_meets_daughter_33.AltText = ""
audio_18_greenwitch_meets_daughter_33.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_33.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_34 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_34.Id = "d5c063d5-08eb-4a45-9635-81837a21420f"
audio_18_greenwitch_meets_daughter_34.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\046\065")
audio_18_greenwitch_meets_daughter_34.Description = ""
audio_18_greenwitch_meets_daughter_34.AltText = ""
audio_18_greenwitch_meets_daughter_34.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_34.mp3", 
		Directives = {}
	}
}
audio_18_greenwitch_meets_daughter_35 = Wherigo.ZMedia(prometheus_chapter_2)
audio_18_greenwitch_meets_daughter_35.Id = "ecb7c947-9b7d-4126-8da4-1d63bb9d4082"
audio_18_greenwitch_meets_daughter_35.Name = _Mzr2("\092\073\009\100\063\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\046\012")
audio_18_greenwitch_meets_daughter_35.Description = ""
audio_18_greenwitch_meets_daughter_35.AltText = ""
audio_18_greenwitch_meets_daughter_35.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_18_greenwitch_meets_daughter_35.mp3", 
		Directives = {}
	}
}
audio_21a_call_from_johnson_gratitude_traitors_end = Wherigo.ZMedia(prometheus_chapter_2)
audio_21a_call_from_johnson_gratitude_traitors_end.Id = "3f66cfe5-e3e7-4a75-b943-36a09b63d374"
audio_21a_call_from_johnson_gratitude_traitors_end.Name = _Mzr2("\092\073\009\100\063\057\020\098\092\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\050\019\092\085\100\085\073\009\028\057\085\019\092\100\085\063\019\124\057\028\062\009")
audio_21a_call_from_johnson_gratitude_traitors_end.Description = ""
audio_21a_call_from_johnson_gratitude_traitors_end.AltText = ""
audio_21a_call_from_johnson_gratitude_traitors_end.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_21a_call_from_johnson_gratitude_traitors_end.mp3", 
		Directives = {}
	}
}
audio_21b_call_from_johnson_threat = Wherigo.ZMedia(prometheus_chapter_2)
audio_21b_call_from_johnson_threat.Id = "b6368ac1-f367-420f-835c-2d3291e43442"
audio_21b_call_from_johnson_threat.Name = _Mzr2("\092\073\009\100\063\057\020\098\119\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\085\072\019\028\092\085")
audio_21b_call_from_johnson_threat.Description = ""
audio_21b_call_from_johnson_threat.AltText = ""
audio_21b_call_from_johnson_threat.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_21b_call_from_johnson_threat.mp3", 
		Directives = {}
	}
}
img_john_greenwitch = Wherigo.ZMedia(prometheus_chapter_2)
img_john_greenwitch.Id = "b8847243-9d48-4615-a256-dcfe693dcbb5"
img_john_greenwitch.Name = _Mzr2("\100\071\050\057\069\063\072\062\057\050\019\028\028\062\126\100\085\093\072")
img_john_greenwitch.Description = ""
img_john_greenwitch.AltText = _Mzr2("\037\063\072\062\053\018\019\028\028\062\126\100\085\093\072")
img_john_greenwitch.Resources = {
	{
		Type = "jpg", 
		Filename = "john_greenwitch.jpg", 
		Directives = {}
	}
}
img_telephone = Wherigo.ZMedia(prometheus_chapter_2)
img_telephone.Id = "7f96ebbb-5fcc-4753-a458-1a8026f851f5"
img_telephone.Name = _Mzr2("\100\071\050\057\085\028\040\028\016\072\063\062\028")
img_telephone.Description = ""
img_telephone.AltText = ""
img_telephone.Resources = {
	{
		Type = "jpg", 
		Filename = "telephone.jpg", 
		Directives = {}
	}
}
icon_telephone = Wherigo.ZMedia(prometheus_chapter_2)
icon_telephone.Id = "e61517e0-5a95-497e-b598-1fa530af11a0"
icon_telephone.Name = _Mzr2("\100\093\063\062\057\085\028\040\028\016\072\063\062\028")
icon_telephone.Description = ""
icon_telephone.AltText = ""
icon_telephone.Resources = {
	{
		Type = "jpg", 
		Filename = "icon_telephone.jpg", 
		Directives = {}
	}
}
audio_10_call_from_greenwitch_followed = Wherigo.ZMedia(prometheus_chapter_2)
audio_10_call_from_greenwitch_followed.Id = "d1f721f5-4bbd-4015-9e47-6e78f6cf83cb"
audio_10_call_from_greenwitch_followed.Name = _Mzr2("\092\073\009\100\063\057\098\027\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072\057\041\063\040\040\063\126\028\009")
audio_10_call_from_greenwitch_followed.Description = ""
audio_10_call_from_greenwitch_followed.AltText = ""
audio_10_call_from_greenwitch_followed.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_10_call_from_greenwitch_followed.mp3", 
		Directives = {}
	}
}
audio_11_call_from_greenwitch_abduction = Wherigo.ZMedia(prometheus_chapter_2)
audio_11_call_from_greenwitch_abduction.Id = "800381d6-f5cc-486c-893e-5ae21cef89bf"
audio_11_call_from_greenwitch_abduction.Name = _Mzr2("\092\073\009\100\063\057\098\098\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072\057\092\119\009\073\093\085\100\063\062")
audio_11_call_from_greenwitch_abduction.Description = ""
audio_11_call_from_greenwitch_abduction.AltText = ""
audio_11_call_from_greenwitch_abduction.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_11_call_from_greenwitch_abduction.mp3", 
		Directives = {}
	}
}
audio_11_call_from_greenwitch_abduction_known = Wherigo.ZMedia(prometheus_chapter_2)
audio_11_call_from_greenwitch_abduction_known.Id = "da405453-d674-4fc3-8055-571a43cc434c"
audio_11_call_from_greenwitch_abduction_known.Name = _Mzr2("\092\073\009\100\063\057\098\098\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072\057\092\119\009\073\093\085\100\063\062\057\036\062\063\126\062")
audio_11_call_from_greenwitch_abduction_known.Description = ""
audio_11_call_from_greenwitch_abduction_known.AltText = ""
audio_11_call_from_greenwitch_abduction_known.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_11_call_from_greenwitch_abduction_known.mp3", 
		Directives = {}
	}
}
img_zeus = Wherigo.ZMedia(prometheus_chapter_2)
img_zeus.Id = "d095b259-520b-48a9-b052-e058ecd81d6a"
img_zeus.Name = _Mzr2("\100\071\050\057\060\028\073\124")
img_zeus.Description = ""
img_zeus.AltText = ""
img_zeus.Resources = {
	{
		Type = "jpg", 
		Filename = "zeus.jpg", 
		Directives = {}
	}
}
img_antidote = Wherigo.ZMedia(prometheus_chapter_2)
img_antidote.Id = "7ae8721f-2358-43f1-babd-c4cc2523b8df"
img_antidote.Name = _Mzr2("\100\071\050\057\092\062\085\100\009\063\085\028")
img_antidote.Description = ""
img_antidote.AltText = ""
img_antidote.Resources = {
	{
		Type = "jpg", 
		Filename = "antidote.jpg", 
		Directives = {}
	}
}
img_fiona_greenwitch = Wherigo.ZMedia(prometheus_chapter_2)
img_fiona_greenwitch.Id = "74316fcc-bdc5-4f97-95c5-e1c254f052f2"
img_fiona_greenwitch.Name = _Mzr2("\100\071\050\057\041\100\063\062\092\057\050\019\028\028\062\126\100\085\093\072")
img_fiona_greenwitch.Description = ""
img_fiona_greenwitch.AltText = _Mzr2("\045\100\063\062\092\053\018\019\028\028\062\126\100\085\093\072")
img_fiona_greenwitch.Resources = {
	{
		Type = "jpg", 
		Filename = "fiona_greenwitch.jpg", 
		Directives = {}
	}
}
img_prometheus_chapter_1 = Wherigo.ZMedia(prometheus_chapter_2)
img_prometheus_chapter_1.Id = "e976e679-6d8f-4fd8-91d4-ebd10403c24e"
img_prometheus_chapter_1.Name = _Mzr2("\100\071\050\057\016\019\063\071\028\085\072\028\073\124\057\093\072\092\016\085\028\019\057\098")
img_prometheus_chapter_1.Description = ""
img_prometheus_chapter_1.AltText = ""
img_prometheus_chapter_1.Resources = {
	{
		Type = "png", 
		Filename = "prometheus_chapter_1_120x150.png", 
		Directives = {}
	}
}
img_20b_minigame_rules = Wherigo.ZMedia(prometheus_chapter_2)
img_20b_minigame_rules.Id = "94ccc0a1-b681-4639-8f16-18f278420a3c"
img_20b_minigame_rules.Name = _Mzr2("\100\071\050\057\020\027\119\057\071\100\062\100\050\092\071\028\057\019\073\040\028\124")
img_20b_minigame_rules.Description = ""
img_20b_minigame_rules.AltText = ""
img_20b_minigame_rules.Resources = {
	{
		Type = "png", 
		Filename = "20b_minigame_rules.png", 
		Directives = {}
	}
}
img_van = Wherigo.ZMedia(prometheus_chapter_2)
img_van.Id = "07fb1f2b-508b-42c1-8d61-3e1169e6ba20"
img_van.Name = _Mzr2("\100\071\050\057\056\092\062")
img_van.Description = ""
img_van.AltText = ""
img_van.Resources = {
	{
		Type = "jpg", 
		Filename = "van.jpg", 
		Directives = {}
	}
}
sound_lost_antidote_to_johnson = Wherigo.ZMedia(prometheus_chapter_2)
sound_lost_antidote_to_johnson.Id = "ba23b971-42b1-4023-bea4-16e98ae44046"
sound_lost_antidote_to_johnson.Name = _Mzr2("\124\063\073\062\009\057\040\063\124\085\057\092\062\085\100\009\063\085\028\057\085\063\057\069\063\072\062\124\063\062")
sound_lost_antidote_to_johnson.Description = ""
sound_lost_antidote_to_johnson.AltText = ""
sound_lost_antidote_to_johnson.Resources = {
	{
		Type = "mp3", 
		Filename = "lost_antidote_to_johnson.mp3", 
		Directives = {}
	}
}
sound_helicopter = Wherigo.ZMedia(prometheus_chapter_2)
sound_helicopter.Id = "0b5c20b6-02a7-4baa-8255-3445bef85a34"
sound_helicopter.Name = _Mzr2("\124\063\073\062\009\057\072\028\040\100\093\063\016\085\028\019")
sound_helicopter.Description = ""
sound_helicopter.AltText = ""
sound_helicopter.Resources = {
	{
		Type = "mp3", 
		Filename = "helicopter.mp3", 
		Directives = {}
	}
}
audio_23c_reaching_hospital_heroes_end = Wherigo.ZMedia(prometheus_chapter_2)
audio_23c_reaching_hospital_heroes_end.Id = "6caca8bd-93e1-487b-9146-7359a749338c"
audio_23c_reaching_hospital_heroes_end.Name = _Mzr2("\092\073\009\100\063\057\020\046\093\057\019\028\092\093\072\100\062\050\057\072\063\124\016\100\085\092\040\057\072\028\019\063\028\124\057\028\062\009")
audio_23c_reaching_hospital_heroes_end.Description = ""
audio_23c_reaching_hospital_heroes_end.AltText = ""
audio_23c_reaching_hospital_heroes_end.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_23c_reaching_hospital_heroes_end.mp3", 
		Directives = {}
	}
}
audio_24d_reaching_hospital_mourners_end = Wherigo.ZMedia(prometheus_chapter_2)
audio_24d_reaching_hospital_mourners_end.Id = "45eba89d-ad09-4a69-9d4d-aef9da210165"
audio_24d_reaching_hospital_mourners_end.Name = _Mzr2("\092\073\009\100\063\057\020\065\009\057\019\028\092\093\072\100\062\050\057\072\063\124\016\100\085\092\040\057\071\063\073\019\062\028\019\124\057\028\062\009")
audio_24d_reaching_hospital_mourners_end.Description = ""
audio_24d_reaching_hospital_mourners_end.AltText = ""
audio_24d_reaching_hospital_mourners_end.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_24d_reaching_hospital_mourners_end.mp3", 
		Directives = {}
	}
}
img_16_track_fiona = Wherigo.ZMedia(prometheus_chapter_2)
img_16_track_fiona.Id = "a49b388b-b8cc-4fb2-b136-cb4399f1178f"
img_16_track_fiona.Name = _Mzr2("\100\071\050\057\098\029\057\085\019\092\093\036\057\041\100\063\062\092")
img_16_track_fiona.Description = ""
img_16_track_fiona.AltText = ""
img_16_track_fiona.Resources = {
	{
		Type = "jpg", 
		Filename = "16_track_fiona.jpg", 
		Directives = {}
	}
}
img_18_greenwitch_meets_daughter_far = Wherigo.ZMedia(prometheus_chapter_2)
img_18_greenwitch_meets_daughter_far.Id = "58dfcdbf-e36c-4f24-9d81-59de1cbba504"
img_18_greenwitch_meets_daughter_far.Name = _Mzr2("\100\071\050\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\041\092\019")
img_18_greenwitch_meets_daughter_far.Description = ""
img_18_greenwitch_meets_daughter_far.AltText = ""
img_18_greenwitch_meets_daughter_far.Resources = {
	{
		Type = "jpg", 
		Filename = "18_greenwitch_meets_daughter_far.jpg", 
		Directives = {}
	}
}
img_18_greenwitch_meets_daughter_near = Wherigo.ZMedia(prometheus_chapter_2)
img_18_greenwitch_meets_daughter_near.Id = "8a65bd57-ae72-4a81-a1a3-31520d75475b"
img_18_greenwitch_meets_daughter_near.Name = _Mzr2("\100\071\050\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\057\062\028\092\019")
img_18_greenwitch_meets_daughter_near.Description = ""
img_18_greenwitch_meets_daughter_near.AltText = ""
img_18_greenwitch_meets_daughter_near.Resources = {
	{
		Type = "jpg", 
		Filename = "18_greenwitch_meets_daughter_near.jpg", 
		Directives = {}
	}
}
audio_12_call_from_johnson_abducted_daughter = Wherigo.ZMedia(prometheus_chapter_2)
audio_12_call_from_johnson_abducted_daughter.Id = "f91554fc-939c-4f0d-9813-9908ad9e7c4c"
audio_12_call_from_johnson_abducted_daughter.Name = _Mzr2("\092\073\009\100\063\057\098\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\092\119\009\073\093\085\028\009\057\009\092\073\050\072\085\028\019")
audio_12_call_from_johnson_abducted_daughter.Description = ""
audio_12_call_from_johnson_abducted_daughter.AltText = ""
audio_12_call_from_johnson_abducted_daughter.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_12_call_from_johnson_abducted_daughter.mp3", 
		Directives = {}
	}
}
audio_08_call_to_greenwitch = Wherigo.ZMedia(prometheus_chapter_2)
audio_08_call_to_greenwitch.Id = "c948e1c9-356a-4d9d-9ac7-d4aba3a6f43a"
audio_08_call_to_greenwitch.Name = _Mzr2("\092\073\009\100\063\057\027\091\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072")
audio_08_call_to_greenwitch.Description = ""
audio_08_call_to_greenwitch.AltText = ""
audio_08_call_to_greenwitch.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_08_call_to_greenwitch.mp3", 
		Directives = {}
	}
}
audio_08_call_to_greenwitch_a_honest = Wherigo.ZMedia(prometheus_chapter_2)
audio_08_call_to_greenwitch_a_honest.Id = "66a907fe-0313-44fa-ab28-f1f82736d8e8"
audio_08_call_to_greenwitch_a_honest.Name = _Mzr2("\092\073\009\100\063\057\027\091\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072\057\092\057\072\063\062\028\124\085")
audio_08_call_to_greenwitch_a_honest.Description = ""
audio_08_call_to_greenwitch_a_honest.AltText = ""
audio_08_call_to_greenwitch_a_honest.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_08_call_to_greenwitch_a_honest.mp3", 
		Directives = {}
	}
}
audio_08_call_to_greenwitch_b_hide = Wherigo.ZMedia(prometheus_chapter_2)
audio_08_call_to_greenwitch_b_hide.Id = "69f40051-01a8-43ae-a9b3-6fa11cbbd4c3"
audio_08_call_to_greenwitch_b_hide.Name = _Mzr2("\092\073\009\100\063\057\027\091\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072\057\119\057\072\100\009\028")
audio_08_call_to_greenwitch_b_hide.Description = ""
audio_08_call_to_greenwitch_b_hide.AltText = ""
audio_08_call_to_greenwitch_b_hide.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_08_call_to_greenwitch_b_hide.mp3", 
		Directives = {}
	}
}
audio_08_call_to_greenwitch_c_a06 = Wherigo.ZMedia(prometheus_chapter_2)
audio_08_call_to_greenwitch_c_a06.Id = "a9764fc4-ef4f-4b4e-82d6-ff07d20a42d7"
audio_08_call_to_greenwitch_c_a06.Name = _Mzr2("\092\073\009\100\063\057\027\091\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072\057\093\057\092\027\029")
audio_08_call_to_greenwitch_c_a06.Description = ""
audio_08_call_to_greenwitch_c_a06.AltText = ""
audio_08_call_to_greenwitch_c_a06.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_08_call_to_greenwitch_c_a06.mp3", 
		Directives = {}
	}
}
audio_08_call_to_greenwitch_end = Wherigo.ZMedia(prometheus_chapter_2)
audio_08_call_to_greenwitch_end.Id = "9f75998e-67e1-40a6-a430-e73c3270a94e"
audio_08_call_to_greenwitch_end.Name = _Mzr2("\092\073\009\100\063\057\027\091\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072\057\028\062\009")
audio_08_call_to_greenwitch_end.Description = ""
audio_08_call_to_greenwitch_end.AltText = ""
audio_08_call_to_greenwitch_end.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_08_call_to_greenwitch_end.mp3", 
		Directives = {}
	}
}
icon_title = Wherigo.ZMedia(prometheus_chapter_2)
icon_title.Id = "fecc2012-e3d5-435a-b740-4da807bbe3e2"
icon_title.Name = _Mzr2("\100\093\063\062\057\085\100\085\040\028")
icon_title.Description = ""
icon_title.AltText = ""
icon_title.Resources = {
	{
		Type = "jpg", 
		Filename = "icon_title.jpg", 
		Directives = {}
	}
}
img_title = Wherigo.ZMedia(prometheus_chapter_2)
img_title.Id = "d385f888-c144-456f-89d9-01544928c440"
img_title.Name = _Mzr2("\100\071\050\057\085\100\085\040\028")
img_title.Description = ""
img_title.AltText = ""
img_title.Resources = {
	{
		Type = "jpg", 
		Filename = "title.jpg", 
		Directives = {}
	}
}
sound_helicopter_leaving = Wherigo.ZMedia(prometheus_chapter_2)
sound_helicopter_leaving.Id = "7c0d0f93-34cc-4183-9547-a9fa8e1f331d"
sound_helicopter_leaving.Name = _Mzr2("\124\063\073\062\009\057\072\028\040\100\093\063\016\085\028\019\057\040\028\092\056\100\062\050")
sound_helicopter_leaving.Description = ""
sound_helicopter_leaving.AltText = ""
sound_helicopter_leaving.Resources = {
	{
		Type = "mp3", 
		Filename = "helicopter_leaving.mp3", 
		Directives = {}
	}
}
img_doctor_who = Wherigo.ZMedia(prometheus_chapter_2)
img_doctor_who.Id = "cde90756-618c-48e0-975c-f0c23da057f6"
img_doctor_who.Name = _Mzr2("\100\071\050\057\009\063\093\085\063\019\057\126\072\063")
img_doctor_who.Description = ""
img_doctor_who.AltText = ""
img_doctor_who.Resources = {
	{
		Type = "jpg", 
		Filename = "doctor_WHO.jpg", 
		Directives = {}
	}
}
img_03_news = Wherigo.ZMedia(prometheus_chapter_2)
img_03_news.Id = "5a2ce791-e6c6-42dc-9884-edaebb464690"
img_03_news.Name = _Mzr2("\100\071\050\057\027\046\057\062\028\126\124")
img_03_news.Description = ""
img_03_news.AltText = ""
img_03_news.Resources = {
	{
		Type = "jpg", 
		Filename = "news_image.jpg", 
		Directives = {}
	}
}
audio_03_news = Wherigo.ZMedia(prometheus_chapter_2)
audio_03_news.Id = "eb06a310-c750-493e-8eb4-9f395714bada"
audio_03_news.Name = _Mzr2("\092\073\009\100\063\057\027\046\057\062\028\126\124")
audio_03_news.Description = ""
audio_03_news.AltText = ""
audio_03_news.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_03_news.mp3", 
		Directives = {}
	}
}
audio_20b_call_from_greenwitch_antidote = Wherigo.ZMedia(prometheus_chapter_2)
audio_20b_call_from_greenwitch_antidote.Id = "1956678d-afd1-4d3a-9468-ecfdddb87f81"
audio_20b_call_from_greenwitch_antidote.Name = _Mzr2("\092\073\009\100\063\057\020\027\119\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072\057\092\062\085\100\009\063\085\028")
audio_20b_call_from_greenwitch_antidote.Description = ""
audio_20b_call_from_greenwitch_antidote.AltText = ""
audio_20b_call_from_greenwitch_antidote.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_20b_call_from_greenwitch_antidote.mp3", 
		Directives = {}
	}
}
-- Cartridge Info --
prometheus_chapter_2.Id="b2246a48-0d51-4545-a9cc-9d5c7da9307b"
prometheus_chapter_2.Name="Prometheus DE - Chapter 2: Konsequenzen"
prometheus_chapter_2.Description=[[Nachdem du dich in Kapitel 1 Projekt Pandora (coord.info/gc4ctgm) gegen Mr. Johnson entschieden hast, muss die Welt und auch du nun die Konsequenzen dafuer tragen, dass das Gegenmittel nicht in Masse produziert wurde. Mr. Johnson gibt dir aber noch einmal eine Chance.]]
prometheus_chapter_2.Visible=true
prometheus_chapter_2.Activity="Fiction"
prometheus_chapter_2.StartingLocationDescription=[[Fuer weitere Informationen geh bitte zum zugehoerigen Geocache GC57EJE (coord.info/gc57eje)]]
prometheus_chapter_2.StartingLocation = ZonePoint(52.50991,13.46219,0)
prometheus_chapter_2.Version="3.4"
prometheus_chapter_2.Company=""
prometheus_chapter_2.Author="David Greenwitch and Mahanako"
prometheus_chapter_2.BuilderVersion="URWIGO 1.20.5218.24064"
prometheus_chapter_2.CreateDate="09/12/2013 19:14:05"
prometheus_chapter_2.PublishDate="1/1/0001 12:00:00 AM"
prometheus_chapter_2.UpdateDate="08/10/2014 18:23:45"
prometheus_chapter_2.LastPlayedDate="1/1/0001 12:00:00 AM"
prometheus_chapter_2.TargetDevice="PocketPC"
prometheus_chapter_2.TargetDeviceVersion="0"
prometheus_chapter_2.StateId="1"
prometheus_chapter_2.CountryId="2"
prometheus_chapter_2.Complete=false
prometheus_chapter_2.UseLogging=true

prometheus_chapter_2.Media=img_title

prometheus_chapter_2.Icon=icon_title


-- Zones --
zone_09_meet_greenwitch = Wherigo.Zone(prometheus_chapter_2)
zone_09_meet_greenwitch.Id = "d4c68bdd-0764-4b24-9100-d4515b97c224"
zone_09_meet_greenwitch.Name = _Mzr2("\060\063\062\028\057\027\116\057\071\028\028\085\057\050\019\028\028\062\126\100\085\093\072")
zone_09_meet_greenwitch.Description = ""
zone_09_meet_greenwitch.Visible = false
zone_09_meet_greenwitch.Commands = {}
zone_09_meet_greenwitch.DistanceRange = Distance(-1, "feet")
zone_09_meet_greenwitch.ShowObjects = "OnEnter"
zone_09_meet_greenwitch.ProximityRange = Distance(60, "meters")
zone_09_meet_greenwitch.AllowSetPositionTo = false
zone_09_meet_greenwitch.Active = false
zone_09_meet_greenwitch.Points = {
	ZonePoint(52.5101257209479, 13.4644505381584, 0), 
	ZonePoint(52.5106317773181, 13.4649252891541, 0), 
	ZonePoint(52.5110366182187, 13.4640562534332, 0), 
	ZonePoint(52.5109092896278, 13.4639006853104, 0), 
	ZonePoint(52.510840727926, 13.4637558460236, 0)
}
zone_09_meet_greenwitch.OriginalPoint = ZonePoint(52.5107088268077, 13.4642177224159, 0)
zone_09_meet_greenwitch.DistanceRangeUOM = "Feet"
zone_09_meet_greenwitch.ProximityRangeUOM = "Meters"
zone_09_meet_greenwitch.OutOfRangeName = ""
zone_09_meet_greenwitch.InRangeName = ""
zone_11_meet_greenwitch = Wherigo.Zone(prometheus_chapter_2)
zone_11_meet_greenwitch.Id = "2569aee9-c498-40ab-a3b4-463d6728f71b"
zone_11_meet_greenwitch.Name = _Mzr2("\060\063\062\028\057\098\098\057\071\028\028\085\057\050\019\028\028\062\126\100\085\093\072")
zone_11_meet_greenwitch.Description = ""
zone_11_meet_greenwitch.Visible = false
zone_11_meet_greenwitch.Commands = {}
zone_11_meet_greenwitch.DistanceRange = Distance(-1, "feet")
zone_11_meet_greenwitch.ShowObjects = "OnEnter"
zone_11_meet_greenwitch.ProximityRange = Distance(60, "meters")
zone_11_meet_greenwitch.AllowSetPositionTo = false
zone_11_meet_greenwitch.Active = false
zone_11_meet_greenwitch.Points = {
	ZonePoint(52.51179894963, 13.4750372171402, 0), 
	ZonePoint(52.5117254921468, 13.4750828146935, 0), 
	ZonePoint(52.5116961091192, 13.4751579165459, 0), 
	ZonePoint(52.5117418160426, 13.4752115607262, 0), 
	ZonePoint(52.5117956848556, 13.4752061963081, 0), 
	ZonePoint(52.5118364945184, 13.4751471877098, 0), 
	ZonePoint(52.5118528183729, 13.4750479459763, 0)
}
zone_11_meet_greenwitch.OriginalPoint = ZonePoint(52.5117781949551, 13.4751272627286, 0)
zone_11_meet_greenwitch.DistanceRangeUOM = "Feet"
zone_11_meet_greenwitch.ProximityRangeUOM = "Meters"
zone_11_meet_greenwitch.OutOfRangeName = ""
zone_11_meet_greenwitch.InRangeName = ""
zone_23_hospital = Wherigo.Zone(prometheus_chapter_2)
zone_23_hospital.Id = "e3a08363-4965-4ae0-871a-d4dd773c70b5"
zone_23_hospital.Name = _Mzr2("\060\063\062\028\057\020\046\057\072\063\124\016\100\085\092\040")
zone_23_hospital.Description = ""
zone_23_hospital.Visible = false
zone_23_hospital.Media = img_zone_hospital
zone_23_hospital.Icon = img_zone_hospital
zone_23_hospital.Commands = {}
zone_23_hospital.DistanceRange = Distance(-1, "feet")
zone_23_hospital.ShowObjects = "OnEnter"
zone_23_hospital.ProximityRange = Distance(60, "meters")
zone_23_hospital.AllowSetPositionTo = false
zone_23_hospital.Active = false
zone_23_hospital.Points = {
	ZonePoint(52.5142621528044, 13.4943652153015, 0), 
	ZonePoint(52.5142474621411, 13.4945073723793, 0), 
	ZonePoint(52.5141462596603, 13.4944939613342, 0), 
	ZonePoint(52.5141119813478, 13.4947675466537, 0), 
	ZonePoint(52.5142066547172, 13.4947943687439, 0), 
	ZonePoint(52.5141968609298, 13.4949150681496, 0), 
	ZonePoint(52.5142850049376, 13.4949338436127, 0), 
	ZonePoint(52.5143421352186, 13.4943893551826, 0)
}
zone_23_hospital.OriginalPoint = ZonePoint(52.5142248139696, 13.4946458414197, 0)
zone_23_hospital.DistanceRangeUOM = "Feet"
zone_23_hospital.ProximityRangeUOM = "Meters"
zone_23_hospital.OutOfRangeName = ""
zone_23_hospital.InRangeName = ""
zone_10_shake_off_pursuers = Wherigo.Zone(prometheus_chapter_2)
zone_10_shake_off_pursuers.Id = "4d84c128-90b8-4a12-81fd-fddbd2013a65"
zone_10_shake_off_pursuers.Name = _Mzr2("\060\063\062\028\057\098\027\057\124\072\092\036\028\057\063\041\041\057\016\073\019\124\073\028\019\124")
zone_10_shake_off_pursuers.Description = ""
zone_10_shake_off_pursuers.Visible = false
zone_10_shake_off_pursuers.Commands = {}
zone_10_shake_off_pursuers.DistanceRange = Distance(-1, "feet")
zone_10_shake_off_pursuers.ShowObjects = "OnEnter"
zone_10_shake_off_pursuers.ProximityRange = Distance(60, "meters")
zone_10_shake_off_pursuers.AllowSetPositionTo = false
zone_10_shake_off_pursuers.Active = false
zone_10_shake_off_pursuers.Points = {
	ZonePoint(52.5107950200654, 13.4651345014572, 0), 
	ZonePoint(52.5106742204907, 13.4650701284409, 0), 
	ZonePoint(52.5107166636223, 13.4649762511253, 0)
}
zone_10_shake_off_pursuers.OriginalPoint = ZonePoint(52.5107286347261, 13.4650602936745, 0)
zone_10_shake_off_pursuers.DistanceRangeUOM = "Feet"
zone_10_shake_off_pursuers.ProximityRangeUOM = "Meters"
zone_10_shake_off_pursuers.OutOfRangeName = ""
zone_10_shake_off_pursuers.InRangeName = ""
zone_13_fionas_whereabouts_right = Wherigo.Zone(prometheus_chapter_2)
zone_13_fionas_whereabouts_right.Id = "4f96d2e5-7d6e-492a-ab40-0aa5063ef7e7"
zone_13_fionas_whereabouts_right.Name = _Mzr2("\060\063\062\028\057\098\046\057\041\100\063\062\092\124\057\126\072\028\019\028\092\119\063\073\085\124\057\019\100\050\072\085")
zone_13_fionas_whereabouts_right.Description = ""
zone_13_fionas_whereabouts_right.Visible = false
zone_13_fionas_whereabouts_right.Media = img_footprints
zone_13_fionas_whereabouts_right.Icon = img_footprints
zone_13_fionas_whereabouts_right.Commands = {}
zone_13_fionas_whereabouts_right.DistanceRange = Distance(-1, "feet")
zone_13_fionas_whereabouts_right.ShowObjects = "OnEnter"
zone_13_fionas_whereabouts_right.ProximityRange = Distance(60, "meters")
zone_13_fionas_whereabouts_right.AllowSetPositionTo = false
zone_13_fionas_whereabouts_right.Active = false
zone_13_fionas_whereabouts_right.Points = {
	ZonePoint(52.5092425570015, 13.4758847951889, 0), 
	ZonePoint(52.5091739926996, 13.4760993719101, 0), 
	ZonePoint(52.5092752066316, 13.4761878848076, 0), 
	ZonePoint(52.5093666254666, 13.4759947657585, 0)
}
zone_13_fionas_whereabouts_right.OriginalPoint = ZonePoint(52.5092645954498, 13.4760417044163, 0)
zone_13_fionas_whereabouts_right.DistanceRangeUOM = "Feet"
zone_13_fionas_whereabouts_right.ProximityRangeUOM = "Meters"
zone_13_fionas_whereabouts_right.OutOfRangeName = ""
zone_13_fionas_whereabouts_right.InRangeName = ""
zone_13_fionas_whereabouts_wrong_4 = Wherigo.Zone(prometheus_chapter_2)
zone_13_fionas_whereabouts_wrong_4.Id = "70930210-3296-4f76-8092-da455a428cf2"
zone_13_fionas_whereabouts_wrong_4.Name = _Mzr2("\060\063\062\028\057\098\046\057\041\100\063\062\092\124\057\126\072\028\019\028\092\119\063\073\085\124\057\126\019\063\062\050\057\065")
zone_13_fionas_whereabouts_wrong_4.Description = ""
zone_13_fionas_whereabouts_wrong_4.Visible = false
zone_13_fionas_whereabouts_wrong_4.Media = img_footprints
zone_13_fionas_whereabouts_wrong_4.Icon = img_footprints
zone_13_fionas_whereabouts_wrong_4.Commands = {}
zone_13_fionas_whereabouts_wrong_4.DistanceRange = Distance(-1, "feet")
zone_13_fionas_whereabouts_wrong_4.ShowObjects = "OnEnter"
zone_13_fionas_whereabouts_wrong_4.ProximityRange = Distance(60, "meters")
zone_13_fionas_whereabouts_wrong_4.AllowSetPositionTo = false
zone_13_fionas_whereabouts_wrong_4.Active = false
zone_13_fionas_whereabouts_wrong_4.Points = {
	ZonePoint(52.5084328384175, 13.4765794873238, 0), 
	ZonePoint(52.5082777494865, 13.4767055511475, 0), 
	ZonePoint(52.5084410009777, 13.4768611192703, 0), 
	ZonePoint(52.5085732342411, 13.4767431020737, 0)
}
zone_13_fionas_whereabouts_wrong_4.OriginalPoint = ZonePoint(52.5084312057807, 13.4767223149538, 0)
zone_13_fionas_whereabouts_wrong_4.DistanceRangeUOM = "Feet"
zone_13_fionas_whereabouts_wrong_4.ProximityRangeUOM = "Meters"
zone_13_fionas_whereabouts_wrong_4.OutOfRangeName = ""
zone_13_fionas_whereabouts_wrong_4.InRangeName = ""
zone_13_fionas_whereabouts_wrong_2 = Wherigo.Zone(prometheus_chapter_2)
zone_13_fionas_whereabouts_wrong_2.Id = "c4fdff6f-c06a-4605-8e91-3d1f95c97487"
zone_13_fionas_whereabouts_wrong_2.Name = _Mzr2("\060\063\062\028\057\098\046\057\041\100\063\062\092\124\057\126\072\028\019\028\092\119\063\073\085\124\057\126\019\063\062\050\057\020")
zone_13_fionas_whereabouts_wrong_2.Description = ""
zone_13_fionas_whereabouts_wrong_2.Visible = false
zone_13_fionas_whereabouts_wrong_2.Media = img_footprints
zone_13_fionas_whereabouts_wrong_2.Icon = img_footprints
zone_13_fionas_whereabouts_wrong_2.Commands = {}
zone_13_fionas_whereabouts_wrong_2.DistanceRange = Distance(-1, "feet")
zone_13_fionas_whereabouts_wrong_2.ShowObjects = "OnEnter"
zone_13_fionas_whereabouts_wrong_2.ProximityRange = Distance(60, "meters")
zone_13_fionas_whereabouts_wrong_2.AllowSetPositionTo = false
zone_13_fionas_whereabouts_wrong_2.Active = false
zone_13_fionas_whereabouts_wrong_2.Points = {
	ZonePoint(52.5102334624698, 13.4760430455208, 0), 
	ZonePoint(52.5102905980181, 13.4761986136436, 0), 
	ZonePoint(52.5103665065604, 13.4761583805084, 0), 
	ZonePoint(52.5103142684379, 13.4760229289532, 0)
}
zone_13_fionas_whereabouts_wrong_2.OriginalPoint = ZonePoint(52.5103012088715, 13.4761057421565, 0)
zone_13_fionas_whereabouts_wrong_2.DistanceRangeUOM = "Feet"
zone_13_fionas_whereabouts_wrong_2.ProximityRangeUOM = "Meters"
zone_13_fionas_whereabouts_wrong_2.OutOfRangeName = ""
zone_13_fionas_whereabouts_wrong_2.InRangeName = ""
zone_16_fiona = Wherigo.Zone(prometheus_chapter_2)
zone_16_fiona.Id = "04ef1c02-3eee-4d78-925c-4815b321f4c9"
zone_16_fiona.Name = _Mzr2("\060\063\062\028\057\098\029\057\041\100\063\062\092")
zone_16_fiona.Description = ""
zone_16_fiona.Visible = false
zone_16_fiona.Media = img_footprints
zone_16_fiona.Icon = img_footprints
zone_16_fiona.Commands = {}
zone_16_fiona.DistanceRange = Distance(-1, "feet")
zone_16_fiona.ShowObjects = "OnEnter"
zone_16_fiona.ProximityRange = Distance(60, "meters")
zone_16_fiona.AllowSetPositionTo = false
zone_16_fiona.Active = false
zone_16_fiona.Points = {
	ZonePoint(52.5093617280338, 13.4761556982994, 0), 
	ZonePoint(52.5093405058188, 13.4762039780617, 0), 
	ZonePoint(52.5093209160728, 13.4761556982994, 0)
}
zone_16_fiona.OriginalPoint = ZonePoint(52.5093410499751, 13.4761717915535, 0)
zone_16_fiona.DistanceRangeUOM = "Feet"
zone_16_fiona.ProximityRangeUOM = "Meters"
zone_16_fiona.OutOfRangeName = ""
zone_16_fiona.InRangeName = ""
zone_18_greenwitch_meets_daughter = Wherigo.Zone(prometheus_chapter_2)
zone_18_greenwitch_meets_daughter.Id = "130bd306-d265-47d6-a4b3-4cd1310f7347"
zone_18_greenwitch_meets_daughter.Name = _Mzr2("\060\063\062\028\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019")
zone_18_greenwitch_meets_daughter.Description = ""
zone_18_greenwitch_meets_daughter.Visible = false
zone_18_greenwitch_meets_daughter.Commands = {}
zone_18_greenwitch_meets_daughter.DistanceRange = Distance(-1, "feet")
zone_18_greenwitch_meets_daughter.ShowObjects = "OnEnter"
zone_18_greenwitch_meets_daughter.ProximityRange = Distance(10, "meters")
zone_18_greenwitch_meets_daughter.AllowSetPositionTo = false
zone_18_greenwitch_meets_daughter.Active = false
zone_18_greenwitch_meets_daughter.Points = {
	ZonePoint(52.5135978034519, 13.478070795536, 0), 
	ZonePoint(52.5136304498464, 13.4778964519501, 0), 
	ZonePoint(52.513736550461, 13.4778106212616, 0), 
	ZonePoint(52.5138442831306, 13.4778428077698, 0), 
	ZonePoint(52.5139226339971, 13.4779098629951, 0), 
	ZonePoint(52.5140271016018, 13.4779876470566, 0), 
	ZonePoint(52.5139650739915, 13.4782049059868, 0), 
	ZonePoint(52.5139014139846, 13.478422164917, 0), 
	ZonePoint(52.5137218596219, 13.4782934188843, 0)
}
zone_18_greenwitch_meets_daughter.OriginalPoint = ZonePoint(52.5138163522319, 13.4780487418175, 0)
zone_18_greenwitch_meets_daughter.DistanceRangeUOM = "Feet"
zone_18_greenwitch_meets_daughter.ProximityRangeUOM = "Meters"
zone_18_greenwitch_meets_daughter.OutOfRangeName = ""
zone_18_greenwitch_meets_daughter.InRangeName = ""
zone_21a_traitors_end = Wherigo.Zone(prometheus_chapter_2)
zone_21a_traitors_end.Id = "da35f994-6410-4ecd-aa93-19b2a3084454"
zone_21a_traitors_end.Name = _Mzr2("\060\063\062\028\057\020\098\092\057\085\019\092\100\085\063\019\124\057\028\062\009")
zone_21a_traitors_end.Description = ""
zone_21a_traitors_end.Visible = false
zone_21a_traitors_end.Media = img_zeus
zone_21a_traitors_end.Commands = {}
zone_21a_traitors_end.DistanceRange = Distance(-1, "feet")
zone_21a_traitors_end.ShowObjects = "OnEnter"
zone_21a_traitors_end.ProximityRange = Distance(60, "meters")
zone_21a_traitors_end.AllowSetPositionTo = false
zone_21a_traitors_end.Active = false
zone_21a_traitors_end.Points = {
	ZonePoint(52.5154928864905, 13.4818822145462, 0), 
	ZonePoint(52.5154324932015, 13.4818848967552, 0), 
	ZonePoint(52.5154275964447, 13.4820163249969, 0), 
	ZonePoint(52.5154855413652, 13.482027053833, 0)
}
zone_21a_traitors_end.OriginalPoint = ZonePoint(52.5154596293755, 13.4819526225328, 0)
zone_21a_traitors_end.DistanceRangeUOM = "Feet"
zone_21a_traitors_end.ProximityRangeUOM = "Meters"
zone_21a_traitors_end.OutOfRangeName = ""
zone_21a_traitors_end.InRangeName = ""
zone_23c_heroes_end = Wherigo.Zone(prometheus_chapter_2)
zone_23c_heroes_end.Id = "b32e043f-1929-4a1c-adb0-6451862fa193"
zone_23c_heroes_end.Name = _Mzr2("\060\063\062\028\057\020\046\093\057\072\028\019\063\028\124\057\028\062\009")
zone_23c_heroes_end.Description = ""
zone_23c_heroes_end.Visible = false
zone_23c_heroes_end.Commands = {}
zone_23c_heroes_end.DistanceRange = Distance(-1, "feet")
zone_23c_heroes_end.ShowObjects = "OnEnter"
zone_23c_heroes_end.ProximityRange = Distance(60, "meters")
zone_23c_heroes_end.AllowSetPositionTo = false
zone_23c_heroes_end.Active = false
zone_23c_heroes_end.Points = {
	ZonePoint(52.5158887053167, 13.5009017586708, 0), 
	ZonePoint(52.5158544283635, 13.500936627388, 0), 
	ZonePoint(52.5158870730815, 13.5010251402855, 0)
}
zone_23c_heroes_end.OriginalPoint = ZonePoint(52.5158767355872, 13.5009545087814, 0)
zone_23c_heroes_end.DistanceRangeUOM = "Feet"
zone_23c_heroes_end.ProximityRangeUOM = "Meters"
zone_23c_heroes_end.OutOfRangeName = ""
zone_23c_heroes_end.InRangeName = ""
zone_24d_mourners_end = Wherigo.Zone(prometheus_chapter_2)
zone_24d_mourners_end.Id = "41396016-36e6-4d4d-bc93-12b91cb3adde"
zone_24d_mourners_end.Name = _Mzr2("\060\063\062\028\057\020\065\009\057\071\063\073\019\062\028\019\124\057\028\062\009")
zone_24d_mourners_end.Description = ""
zone_24d_mourners_end.Visible = false
zone_24d_mourners_end.Commands = {}
zone_24d_mourners_end.DistanceRange = Distance(-1, "feet")
zone_24d_mourners_end.ShowObjects = "OnEnter"
zone_24d_mourners_end.ProximityRange = Distance(60, "meters")
zone_24d_mourners_end.AllowSetPositionTo = false
zone_24d_mourners_end.Active = false
zone_24d_mourners_end.Points = {
	ZonePoint(52.5184512399019, 13.492289185524, 0), 
	ZonePoint(52.5184414470606, 13.4925292432308, 0), 
	ZonePoint(52.5185997643943, 13.4925372898579, 0), 
	ZonePoint(52.5186005804615, 13.492294549942, 0)
}
zone_24d_mourners_end.OriginalPoint = ZonePoint(52.5185232579546, 13.4924125671387, 0)
zone_24d_mourners_end.DistanceRangeUOM = "Feet"
zone_24d_mourners_end.ProximityRangeUOM = "Meters"
zone_24d_mourners_end.OutOfRangeName = ""
zone_24d_mourners_end.InRangeName = ""
zone_22_helicopter = Wherigo.Zone(prometheus_chapter_2)
zone_22_helicopter.Id = "52e2a97a-4af2-4dfc-84fa-055ad8300075"
zone_22_helicopter.Name = _Mzr2("\060\063\062\028\057\020\020\057\072\028\040\100\093\063\016\085\028\019")
zone_22_helicopter.Description = ""
zone_22_helicopter.Visible = false
zone_22_helicopter.Commands = {}
zone_22_helicopter.DistanceRange = Distance(-1, "feet")
zone_22_helicopter.ShowObjects = "OnEnter"
zone_22_helicopter.ProximityRange = Distance(60, "meters")
zone_22_helicopter.AllowSetPositionTo = false
zone_22_helicopter.Active = false
zone_22_helicopter.Points = {
	ZonePoint(52.5144972027497, 13.4766411781311, 0), 
	ZonePoint(52.514644108327, 13.4769201278687, 0), 
	ZonePoint(52.514712664095, 13.476625084877, 0)
}
zone_22_helicopter.OriginalPoint = ZonePoint(52.5146179917239, 13.4767287969589, 0)
zone_22_helicopter.DistanceRangeUOM = "Feet"
zone_22_helicopter.ProximityRangeUOM = "Meters"
zone_22_helicopter.OutOfRangeName = ""
zone_22_helicopter.InRangeName = ""
zone_22_road_block_1 = Wherigo.Zone(prometheus_chapter_2)
zone_22_road_block_1.Id = "2bc86e38-bdf6-4a20-8b9a-edf1d153b147"
zone_22_road_block_1.Name = _Mzr2("\060\063\062\028\057\020\020\057\019\063\092\009\057\119\040\063\093\036\057\098")
zone_22_road_block_1.Description = ""
zone_22_road_block_1.Visible = false
zone_22_road_block_1.Commands = {}
zone_22_road_block_1.DistanceRange = Distance(-1, "feet")
zone_22_road_block_1.ShowObjects = "OnEnter"
zone_22_road_block_1.ProximityRange = Distance(60, "meters")
zone_22_road_block_1.AllowSetPositionTo = false
zone_22_road_block_1.Active = false
zone_22_road_block_1.Points = {
	ZonePoint(52.5131130016395, 13.4758472442627, 0), 
	ZonePoint(52.5106056584222, 13.4992790222168, 0), 
	ZonePoint(52.5156463177165, 13.500394821167, 0), 
	ZonePoint(52.5178661138022, 13.4785509109497, 0), 
	ZonePoint(52.5160119389039, 13.4821128845215, 0), 
	ZonePoint(52.5155679699233, 13.4866189956665, 0), 
	ZonePoint(52.5159074760179, 13.4876489639282, 0), 
	ZonePoint(52.5153590417921, 13.4915971755981, 0), 
	ZonePoint(52.5149411825492, 13.4920263290405, 0), 
	ZonePoint(52.5145494359001, 13.4978199005127, 0), 
	ZonePoint(52.5119377023187, 13.497519493103, 0), 
	ZonePoint(52.513792049142, 13.4776496887207, 0)
}
zone_22_road_block_1.OriginalPoint = ZonePoint(52.514608157344, 13.4889221191406, 0)
zone_22_road_block_1.DistanceRangeUOM = "Feet"
zone_22_road_block_1.ProximityRangeUOM = "Meters"
zone_22_road_block_1.OutOfRangeName = ""
zone_22_road_block_1.InRangeName = ""
zone_22_agent_1 = Wherigo.Zone(prometheus_chapter_2)
zone_22_agent_1.Id = "d8dd433e-572c-4522-9e63-3268d33a5f64"
zone_22_agent_1.Name = _Mzr2("\060\063\062\028\057\020\020\057\092\050\028\062\085\057\098")
zone_22_agent_1.Description = ""
zone_22_agent_1.Visible = false
zone_22_agent_1.Commands = {}
zone_22_agent_1.DistanceRange = Distance(-1, "feet")
zone_22_agent_1.ShowObjects = "OnEnter"
zone_22_agent_1.ProximityRange = Distance(60, "meters")
zone_22_agent_1.AllowSetPositionTo = false
zone_22_agent_1.Active = false
zone_22_agent_1.Points = {
	ZonePoint(52.5145665748891, 13.4847575426102, 0), 
	ZonePoint(52.5146449244677, 13.4847240149975, 0), 
	ZonePoint(52.514707767258, 13.4847401082516, 0), 
	ZonePoint(52.5147624485738, 13.4847508370876, 0), 
	ZonePoint(52.5148130491338, 13.4847642481327, 0), 
	ZonePoint(52.5148620173621, 13.4847803413868, 0), 
	ZonePoint(52.5149101694001, 13.4847964346409, 0), 
	ZonePoint(52.5149672988683, 13.4848165512085, 0), 
	ZonePoint(52.5150260605295, 13.4848487377167, 0), 
	ZonePoint(52.5150701317239, 13.484915792942, 0), 
	ZonePoint(52.5150668671925, 13.4849855303764, 0), 
	ZonePoint(52.515029325064, 13.4850284457207, 0), 
	ZonePoint(52.5149779086185, 13.4850458800793, 0), 
	ZonePoint(52.5149289405193, 13.4850177168846, 0), 
	ZonePoint(52.5148783400928, 13.485005646944, 0), 
	ZonePoint(52.5148187620965, 13.484992235899, 0), 
	ZonePoint(52.5147551033263, 13.4849788248539, 0), 
	ZonePoint(52.5146906283241, 13.4849680960178, 0), 
	ZonePoint(52.5146343146372, 13.4849439561367, 0), 
	ZonePoint(52.5145592296089, 13.484907746315, 0)
}
zone_22_agent_1.OriginalPoint = ZonePoint(52.5148334930843, 13.4848884344101, 0)
zone_22_agent_1.DistanceRangeUOM = "Feet"
zone_22_agent_1.ProximityRangeUOM = "Meters"
zone_22_agent_1.OutOfRangeName = ""
zone_22_agent_1.InRangeName = ""
zone_22_agent_2 = Wherigo.Zone(prometheus_chapter_2)
zone_22_agent_2.Id = "e9b33687-4fba-4cf3-bff4-da9940b6c2ff"
zone_22_agent_2.Name = _Mzr2("\060\063\062\028\057\020\020\057\092\050\028\062\085\057\020")
zone_22_agent_2.Description = ""
zone_22_agent_2.Visible = false
zone_22_agent_2.Commands = {}
zone_22_agent_2.DistanceRange = Distance(-1, "feet")
zone_22_agent_2.ShowObjects = "OnEnter"
zone_22_agent_2.ProximityRange = Distance(60, "meters")
zone_22_agent_2.AllowSetPositionTo = false
zone_22_agent_2.Active = false
zone_22_agent_2.Points = {
	ZonePoint(52.5156161211877, 13.4889491647482, 0), 
	ZonePoint(52.5155826601452, 13.4890235960484, 0), 
	ZonePoint(52.5155426700853, 13.4890497475863, 0), 
	ZonePoint(52.5154671785466, 13.4890933334827, 0), 
	ZonePoint(52.5154210674348, 13.4891422837973, 0), 
	ZonePoint(52.5153488401977, 13.4891355782747, 0), 
	ZonePoint(52.5152647789701, 13.4891168028116, 0), 
	ZonePoint(52.5152027531068, 13.4890685230494, 0), 
	ZonePoint(52.5151064496193, 13.4890108555555, 0), 
	ZonePoint(52.515115427072, 13.4889256954193, 0), 
	ZonePoint(52.5152003047158, 13.4888425469398, 0), 
	ZonePoint(52.5152843660666, 13.4888284653425, 0), 
	ZonePoint(52.5153627143655, 13.4888177365065, 0), 
	ZonePoint(52.5154316770754, 13.4887956082821, 0), 
	ZonePoint(52.5154781962387, 13.4887607395649, 0), 
	ZonePoint(52.515539405589, 13.4888023138046, 0), 
	ZonePoint(52.5156055115917, 13.4888908267021, 0)
}
zone_22_agent_2.OriginalPoint = ZonePoint(52.5153864777652, 13.4889561069362, 0)
zone_22_agent_2.DistanceRangeUOM = "Feet"
zone_22_agent_2.ProximityRangeUOM = "Meters"
zone_22_agent_2.OutOfRangeName = ""
zone_22_agent_2.InRangeName = ""
zone_13_fionas_whereabouts_wrong_3 = Wherigo.Zone(prometheus_chapter_2)
zone_13_fionas_whereabouts_wrong_3.Id = "bbdc5be1-3d7b-4a11-850f-90a40a7e0ddd"
zone_13_fionas_whereabouts_wrong_3.Name = _Mzr2("\060\063\062\028\057\098\046\057\041\100\063\062\092\124\057\126\072\028\019\028\092\119\063\073\085\124\057\126\019\063\062\050\057\046")
zone_13_fionas_whereabouts_wrong_3.Description = ""
zone_13_fionas_whereabouts_wrong_3.Visible = false
zone_13_fionas_whereabouts_wrong_3.Media = img_footprints
zone_13_fionas_whereabouts_wrong_3.Commands = {}
zone_13_fionas_whereabouts_wrong_3.DistanceRange = Distance(-1, "feet")
zone_13_fionas_whereabouts_wrong_3.ShowObjects = "OnEnter"
zone_13_fionas_whereabouts_wrong_3.ProximityRange = Distance(60, "meters")
zone_13_fionas_whereabouts_wrong_3.AllowSetPositionTo = false
zone_13_fionas_whereabouts_wrong_3.Active = false
zone_13_fionas_whereabouts_wrong_3.Points = {
	ZonePoint(52.5093290784681, 13.4763059020042, 0), 
	ZonePoint(52.5095119157238, 13.4764185547829, 0), 
	ZonePoint(52.5096653678335, 13.4763622283936, 0), 
	ZonePoint(52.509523343027, 13.4761664271355, 0)
}
zone_13_fionas_whereabouts_wrong_3.OriginalPoint = ZonePoint(52.5095074262631, 13.4763132780791, 0)
zone_13_fionas_whereabouts_wrong_3.DistanceRangeUOM = "Feet"
zone_13_fionas_whereabouts_wrong_3.ProximityRangeUOM = "Meters"
zone_13_fionas_whereabouts_wrong_3.OutOfRangeName = ""
zone_13_fionas_whereabouts_wrong_3.InRangeName = ""
zone_13_fionas_whereabouts_wrong_1 = Wherigo.Zone(prometheus_chapter_2)
zone_13_fionas_whereabouts_wrong_1.Id = "c5345a90-5512-4c69-b1b4-5a64a87972a2"
zone_13_fionas_whereabouts_wrong_1.Name = _Mzr2("\060\063\062\028\057\098\046\057\041\100\063\062\092\124\057\126\072\028\019\028\092\119\063\073\085\124\057\126\019\063\062\050\057\098")
zone_13_fionas_whereabouts_wrong_1.Description = ""
zone_13_fionas_whereabouts_wrong_1.Visible = false
zone_13_fionas_whereabouts_wrong_1.Media = img_footprints
zone_13_fionas_whereabouts_wrong_1.Commands = {}
zone_13_fionas_whereabouts_wrong_1.DistanceRange = Distance(-1, "feet")
zone_13_fionas_whereabouts_wrong_1.ShowObjects = "OnEnter"
zone_13_fionas_whereabouts_wrong_1.ProximityRange = Distance(60, "meters")
zone_13_fionas_whereabouts_wrong_1.AllowSetPositionTo = false
zone_13_fionas_whereabouts_wrong_1.Active = false
zone_13_fionas_whereabouts_wrong_1.Points = {
	ZonePoint(52.5082434665963, 13.4736049175262, 0), 
	ZonePoint(52.5081161299129, 13.4739857912064, 0), 
	ZonePoint(52.507954509745, 13.4738248586655, 0), 
	ZonePoint(52.508090009522, 13.4734627604485, 0)
}
zone_13_fionas_whereabouts_wrong_1.OriginalPoint = ZonePoint(52.508101028944, 13.4737195819616, 0)
zone_13_fionas_whereabouts_wrong_1.DistanceRangeUOM = "Feet"
zone_13_fionas_whereabouts_wrong_1.ProximityRangeUOM = "Meters"
zone_13_fionas_whereabouts_wrong_1.OutOfRangeName = ""
zone_13_fionas_whereabouts_wrong_1.InRangeName = ""
zone_22_agent_3 = Wherigo.Zone(prometheus_chapter_2)
zone_22_agent_3.Id = "63f94ae5-721f-4ec2-8c9c-050ee4b66434"
zone_22_agent_3.Name = _Mzr2("\060\063\062\028\057\020\020\057\092\050\028\062\085\057\046")
zone_22_agent_3.Description = ""
zone_22_agent_3.Visible = false
zone_22_agent_3.Commands = {}
zone_22_agent_3.DistanceRange = Distance(-1, "feet")
zone_22_agent_3.ShowObjects = "OnEnter"
zone_22_agent_3.ProximityRange = Distance(60, "meters")
zone_22_agent_3.AllowSetPositionTo = false
zone_22_agent_3.Active = false
zone_22_agent_3.Points = {
	ZonePoint(52.5142715385035, 13.4932782500982, 0), 
	ZonePoint(52.5143364221938, 13.4932976961136, 0), 
	ZonePoint(52.5143845748078, 13.4933090955019, 0), 
	ZonePoint(52.5144237497769, 13.4933272004128, 0), 
	ZonePoint(52.5144719022951, 13.4933318942785, 0), 
	ZonePoint(52.5145123014012, 13.4933439642191, 0), 
	ZonePoint(52.5145584134666, 13.4933486580849, 0), 
	ZonePoint(52.51457473631, 13.4932923316956, 0), 
	ZonePoint(52.5145478036151, 13.4932232648134, 0), 
	ZonePoint(52.514493530104, 13.4932111948729, 0), 
	ZonePoint(52.5144523148365, 13.4931991249323, 0), 
	ZonePoint(52.5144110995303, 13.49319845438, 0), 
	ZonePoint(52.5143698841855, 13.4931870549917, 0), 
	ZonePoint(52.5143070409119, 13.4931917488575, 0), 
	ZonePoint(52.5142874533798, 13.4932239353657, 0)
}
zone_22_agent_3.OriginalPoint = ZonePoint(52.5144268510212, 13.4932642579079, 0)
zone_22_agent_3.DistanceRangeUOM = "Feet"
zone_22_agent_3.ProximityRangeUOM = "Meters"
zone_22_agent_3.OutOfRangeName = ""
zone_22_agent_3.InRangeName = ""
zone_22_road_block_2 = Wherigo.Zone(prometheus_chapter_2)
zone_22_road_block_2.Id = "d9cf4bf2-533d-4f9f-8408-edf8ab2e7429"
zone_22_road_block_2.Name = _Mzr2("\060\063\062\028\057\020\020\057\019\063\092\009\057\119\040\063\093\036\057\020")
zone_22_road_block_2.Description = ""
zone_22_road_block_2.Visible = false
zone_22_road_block_2.Commands = {}
zone_22_road_block_2.DistanceRange = Distance(-1, "feet")
zone_22_road_block_2.ShowObjects = "OnEnter"
zone_22_road_block_2.ProximityRange = Distance(60, "meters")
zone_22_road_block_2.AllowSetPositionTo = false
zone_22_road_block_2.Active = false
zone_22_road_block_2.Points = {
	ZonePoint(52.5140597476774, 13.4817051887512, 0), 
	ZonePoint(52.5140597476774, 13.4819841384888, 0), 
	ZonePoint(52.5143078570589, 13.4819304943085, 0), 
	ZonePoint(52.5144580278461, 13.4817802906036, 0), 
	ZonePoint(52.5143862070989, 13.4815764427185, 0), 
	ZonePoint(52.5142360360662, 13.4817159175873, 0)
}
zone_22_road_block_2.OriginalPoint = ZonePoint(52.5142512705708, 13.481782078743, 0)
zone_22_road_block_2.DistanceRangeUOM = "Feet"
zone_22_road_block_2.ProximityRangeUOM = "Meters"
zone_22_road_block_2.OutOfRangeName = ""
zone_22_road_block_2.InRangeName = ""
zone_22_road_block_3 = Wherigo.Zone(prometheus_chapter_2)
zone_22_road_block_3.Id = "8f3762db-f211-42cf-a11b-0bffa6783ac9"
zone_22_road_block_3.Name = _Mzr2("\060\063\062\028\057\020\020\057\019\063\092\009\057\119\040\063\093\036\057\046")
zone_22_road_block_3.Description = ""
zone_22_road_block_3.Visible = false
zone_22_road_block_3.Commands = {}
zone_22_road_block_3.DistanceRange = Distance(-1, "feet")
zone_22_road_block_3.ShowObjects = "OnEnter"
zone_22_road_block_3.ProximityRange = Distance(60, "meters")
zone_22_road_block_3.AllowSetPositionTo = false
zone_22_road_block_3.Active = false
zone_22_road_block_3.Points = {
	ZonePoint(52.5152562096127, 13.4905993938446, 0), 
	ZonePoint(52.5151174674019, 13.4907227754593, 0), 
	ZonePoint(52.5151778611239, 13.4909051656723, 0), 
	ZonePoint(52.5153117063743, 13.4907495975494, 0)
}
zone_22_road_block_3.OriginalPoint = ZonePoint(52.5152158111282, 13.4907442331314, 0)
zone_22_road_block_3.DistanceRangeUOM = "Feet"
zone_22_road_block_3.ProximityRangeUOM = "Meters"
zone_22_road_block_3.OutOfRangeName = ""
zone_22_road_block_3.InRangeName = ""

-- Characters --
character_fiona_greenwitch = Wherigo.ZCharacter{
	Cartridge = prometheus_chapter_2, 
	Container = zone_16_fiona
}
character_fiona_greenwitch.Id = "30c5045c-c0a7-495a-9a30-7c0a5cea481e"
character_fiona_greenwitch.Name = _Mzr2("\045\100\063\062\092\053\018\019\028\028\062\126\100\085\093\072")
character_fiona_greenwitch.Description = ""
character_fiona_greenwitch.Visible = true
character_fiona_greenwitch.Media = img_fiona_greenwitch
character_fiona_greenwitch.Commands = {}
character_fiona_greenwitch.ObjectLocation = Wherigo.INVALID_ZONEPOINT
character_fiona_greenwitch.Gender = "Female"
character_fiona_greenwitch.Type = "NPC"
character_john_greenwitch = Wherigo.ZCharacter(prometheus_chapter_2)
character_john_greenwitch.Id = "1bcf5c92-57b6-4d9b-ac0b-d003396bfe0f"
character_john_greenwitch.Name = _Mzr2("\037\063\072\062\053\018\019\028\028\062\126\100\085\093\072")
character_john_greenwitch.Description = ""
character_john_greenwitch.Visible = true
character_john_greenwitch.Media = img_john_greenwitch
character_john_greenwitch.Commands = {}
character_john_greenwitch.ObjectLocation = Wherigo.INVALID_ZONEPOINT
character_john_greenwitch.Gender = "Male"
character_john_greenwitch.Type = "NPC"
character_mr_johnson = Wherigo.ZCharacter(prometheus_chapter_2)
character_mr_johnson.Id = "a236652c-deb4-400d-bef9-173d28e70ded"
character_mr_johnson.Name = _Mzr2("\038\019\026\053\037\063\072\062\124\063\062")
character_mr_johnson.Description = ""
character_mr_johnson.Visible = true
character_mr_johnson.Media = img_mr_johnson
character_mr_johnson.Commands = {}
character_mr_johnson.ObjectLocation = Wherigo.INVALID_ZONEPOINT
character_mr_johnson.Gender = "Male"
character_mr_johnson.Type = "NPC"
character_medical_doctor = Wherigo.ZCharacter{
	Cartridge = prometheus_chapter_2, 
	Container = zone_23_hospital
}
character_medical_doctor.Id = "b1e25ee7-22f3-4f88-b623-0966546c65cb"
character_medical_doctor.Name = _Mzr2("\125\019\026\053\014\032\075")
character_medical_doctor.Description = ""
character_medical_doctor.Visible = true
character_medical_doctor.Media = img_doctor_who
character_medical_doctor.Commands = {}
character_medical_doctor.ObjectLocation = Wherigo.INVALID_ZONEPOINT
character_medical_doctor.Gender = "Female"
character_medical_doctor.Type = "NPC"

-- Items --
item_12_call_from_johnson_abducted_daughter = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_12_call_from_johnson_abducted_daughter.Id = "581cc027-3b73-4529-bd04-2a11b87ae03b"
item_12_call_from_johnson_abducted_daughter.Name = _Mzr2("\100\085\028\071\057\098\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\092\119\009\073\093\085\028\009\057\009\092\073\050\072\085\028\019")
item_12_call_from_johnson_abducted_daughter.Description = ""
item_12_call_from_johnson_abducted_daughter.Visible = false
item_12_call_from_johnson_abducted_daughter.Commands = {
	command_listen = Wherigo.ZCommand{
		Text = _Mzr2("\093\063\071\071\092\062\009\057\040\100\124\085\028\062"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _Mzr2("\077\063\085\072\100\062\050\053\092\056\092\100\040\092\119\040\028")
	}
}
item_12_call_from_johnson_abducted_daughter.Commands.command_listen.Custom = true
item_12_call_from_johnson_abducted_daughter.Commands.command_listen.Id = "0ff9204d-81d1-4c2a-b7de-441c8c800206"
item_12_call_from_johnson_abducted_daughter.Commands.command_listen.WorksWithAll = true
item_12_call_from_johnson_abducted_daughter.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_12_call_from_johnson_abducted_daughter.Locked = false
item_12_call_from_johnson_abducted_daughter.Opened = false
item_memo = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_memo.Id = "ceeb1f7f-a7c0-4f33-be1d-045d52fc38dd"
item_memo.Name = _Mzr2("\100\085\028\071\057\071\028\071\063")
item_memo.Description = ""
item_memo.Visible = true
item_memo.Media = img_memo
item_memo.Icon = icon_memo
item_memo.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _Mzr2("\093\063\071\071\092\062\009\057\056\100\028\126"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _Mzr2("\077\063\085\072\100\062\050\053\092\056\092\100\040\092\119\040\028")
	}
}
item_memo.Commands.command_view.Custom = true
item_memo.Commands.command_view.Id = "522e3ce2-5c60-4655-87fd-d1ef0912e302"
item_memo.Commands.command_view.WorksWithAll = true
item_memo.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_memo.Locked = false
item_memo.Opened = false
item_03_news = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_03_news.Id = "01fc2598-e6bb-4c6d-bcee-67314d55ec1c"
item_03_news.Name = _Mzr2("\100\085\028\071\057\027\046\057\062\028\126\124")
item_03_news.Description = ""
item_03_news.Visible = false
item_03_news.Media = img_03_news
item_03_news.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _Mzr2("\093\063\071\071\092\062\009\057\056\100\028\126"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _Mzr2("\077\063\085\072\100\062\050\053\092\056\092\100\040\092\119\040\028")
	}
}
item_03_news.Commands.command_view.Custom = true
item_03_news.Commands.command_view.Id = "cd7bf40f-20cb-4965-9c20-35abac49d219"
item_03_news.Commands.command_view.WorksWithAll = true
item_03_news.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_03_news.Locked = false
item_03_news.Opened = false
item_20_antidote = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = character_john_greenwitch
}
item_20_antidote.Id = "7675fb2a-0321-4234-afb9-7f6d93fa1b08"
item_20_antidote.Name = _Mzr2("\100\085\028\071\057\020\027\057\092\062\085\100\009\063\085\028")
item_20_antidote.Description = ""
item_20_antidote.Visible = true
item_20_antidote.Media = img_antidote
item_20_antidote.Icon = img_antidote
item_20_antidote.Commands = {}
item_20_antidote.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_20_antidote.Locked = false
item_20_antidote.Opened = false
item_20b_minigame_rules = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_20b_minigame_rules.Id = "cb56b986-da32-429c-bd56-d4c3fafd3238"
item_20b_minigame_rules.Name = _Mzr2("\100\085\028\071\057\020\027\119\057\071\100\062\100\050\092\071\028\057\019\073\040\028\124")
item_20b_minigame_rules.Description = ""
item_20b_minigame_rules.Visible = false
item_20b_minigame_rules.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _Mzr2("\093\063\071\071\092\062\009\057\056\100\028\126"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = ""
	}
}
item_20b_minigame_rules.Commands.command_view.Custom = true
item_20b_minigame_rules.Commands.command_view.Id = "8d78d40d-245b-41bb-8a93-6eba429789ae"
item_20b_minigame_rules.Commands.command_view.WorksWithAll = true
item_20b_minigame_rules.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_20b_minigame_rules.Locked = false
item_20b_minigame_rules.Opened = false
item_completion_code = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_completion_code.Id = "9d5fc4e0-dd60-45e5-a32f-3a72a8028ba6"
item_completion_code.Name = _Mzr2("\100\085\028\071\057\093\063\071\016\040\028\085\100\063\062\057\093\063\009\028")
item_completion_code.Description = ""
item_completion_code.Visible = false
item_completion_code.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _Mzr2("\093\063\071\071\092\062\009\057\056\100\028\126"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = ""
	}
}
item_completion_code.Commands.command_view.Custom = true
item_completion_code.Commands.command_view.Id = "321a23cb-fdc9-4d98-ac84-63bfadcee6e2"
item_completion_code.Commands.command_view.WorksWithAll = true
item_completion_code.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_completion_code.Locked = false
item_completion_code.Opened = false
item_credits = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_credits.Id = "6e90b5c5-324f-4575-b62a-6dd8de9dc42e"
item_credits.Name = _Mzr2("\100\085\028\071\057\093\019\028\009\100\085\124")
item_credits.Description = ""
item_credits.Visible = false
item_credits.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _Mzr2("\093\063\071\071\092\062\009\057\056\100\028\126"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = ""
	}
}
item_credits.Commands.command_view.Custom = true
item_credits.Commands.command_view.Id = "0d8b9792-9397-4ca7-b09e-9668dfd0ea4c"
item_credits.Commands.command_view.WorksWithAll = true
item_credits.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_credits.Locked = false
item_credits.Opened = false

-- Tasks --
task_07_call_to_greenwitch = Wherigo.ZTask(prometheus_chapter_2)
task_07_call_to_greenwitch.Id = "161371c8-2006-4800-baac-b79ed6a1ed2d"
task_07_call_to_greenwitch.Name = _Mzr2("\085\092\124\036\057\027\007\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072")
task_07_call_to_greenwitch.Description = ""
task_07_call_to_greenwitch.Visible = false
task_07_call_to_greenwitch.Active = false
task_07_call_to_greenwitch.Complete = false
task_07_call_to_greenwitch.CorrectState = "None"
task_01_previously = Wherigo.ZTask(prometheus_chapter_2)
task_01_previously.Id = "76f37cb9-2b1e-4c09-aaa1-cd6ac8b901a4"
task_01_previously.Name = _Mzr2("\085\092\124\036\057\027\098\057\016\019\028\056\100\063\073\124\040\054")
task_01_previously.Description = ""
task_01_previously.Visible = true
task_01_previously.Active = true
task_01_previously.Complete = false
task_01_previously.CorrectState = "None"
task_04_call_from_johnson_1_2 = Wherigo.ZTask(prometheus_chapter_2)
task_04_call_from_johnson_1_2.Id = "e0e551e5-4f80-4c37-9632-edcc90d8d17d"
task_04_call_from_johnson_1_2.Name = _Mzr2("\085\092\124\036\057\027\065\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\098\057\020")
task_04_call_from_johnson_1_2.Description = ""
task_04_call_from_johnson_1_2.Visible = false
task_04_call_from_johnson_1_2.Active = false
task_04_call_from_johnson_1_2.Complete = false
task_04_call_from_johnson_1_2.CorrectState = "None"
task_08_call_to_greenwitch_end = Wherigo.ZTask(prometheus_chapter_2)
task_08_call_to_greenwitch_end.Id = "75b3ff2f-ce4f-4818-b3ff-196469ca00cd"
task_08_call_to_greenwitch_end.Name = _Mzr2("\085\092\124\036\057\027\091\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072\057\028\062\009")
task_08_call_to_greenwitch_end.Description = ""
task_08_call_to_greenwitch_end.Visible = false
task_08_call_to_greenwitch_end.Active = false
task_08_call_to_greenwitch_end.Complete = false
task_08_call_to_greenwitch_end.CorrectState = "None"
task_19_warn_greenwitch_or_wait = Wherigo.ZTask(prometheus_chapter_2)
task_19_warn_greenwitch_or_wait.Id = "17ba912e-1762-4391-98d3-6f10e9668b14"
task_19_warn_greenwitch_or_wait.Name = _Mzr2("\085\092\124\036\057\098\116\057\126\092\019\062\057\050\019\028\028\062\126\100\085\093\072\057\063\019\057\126\092\100\085")
task_19_warn_greenwitch_or_wait.Description = ""
task_19_warn_greenwitch_or_wait.Visible = false
task_19_warn_greenwitch_or_wait.Active = false
task_19_warn_greenwitch_or_wait.Complete = false
task_19_warn_greenwitch_or_wait.CorrectState = "None"
task_20b_bring_antidote_to_hospital = Wherigo.ZTask(prometheus_chapter_2)
task_20b_bring_antidote_to_hospital.Id = "715227a1-7964-43d6-8a16-ad0c38fd116b"
task_20b_bring_antidote_to_hospital.Name = _Mzr2("\085\092\124\036\057\020\027\119\057\119\019\100\062\050\057\092\062\085\100\009\063\085\028\057\085\063\057\072\063\124\016\100\085\092\040")
task_20b_bring_antidote_to_hospital.Description = ""
task_20b_bring_antidote_to_hospital.Visible = false
task_20b_bring_antidote_to_hospital.Active = false
task_20b_bring_antidote_to_hospital.Complete = false
task_20b_bring_antidote_to_hospital.CorrectState = "None"
debug_task = Wherigo.ZTask(prometheus_chapter_2)
debug_task.Id = "4f03c723-230e-4a2a-9759-2f8e72e7292a"
debug_task.Name = _Mzr2("\009\028\119\073\050\057\085\092\124\036")
debug_task.Description = ""
debug_task.Visible = false
debug_task.Active = false
debug_task.Complete = false
debug_task.CorrectState = "None"
debug_task_lose_antidote = Wherigo.ZTask(prometheus_chapter_2)
debug_task_lose_antidote.Id = "c325cdfa-7cf1-4a4e-a8a9-306774f4ce72"
debug_task_lose_antidote.Name = _Mzr2("\009\028\119\073\050\057\085\092\124\036\057\040\063\124\028\057\092\062\085\100\009\063\085\028")
debug_task_lose_antidote.Description = ""
debug_task_lose_antidote.Visible = false
debug_task_lose_antidote.Active = false
debug_task_lose_antidote.Complete = false
debug_task_lose_antidote.CorrectState = "None"
task_13_find_fiona = Wherigo.ZTask(prometheus_chapter_2)
task_13_find_fiona.Id = "73e8061a-96a8-4ef2-a6d3-12bad073d30f"
task_13_find_fiona.Name = _Mzr2("\085\092\124\036\057\098\046\057\041\100\062\009\057\041\100\063\062\092")
task_13_find_fiona.Description = ""
task_13_find_fiona.Visible = false
task_13_find_fiona.Active = false
task_13_find_fiona.Complete = false
task_13_find_fiona.CorrectState = "None"

-- Cartridge Variables --
string_yes = ""
string_no = ""
result = false
bool_06a_call_from_johnson_daughter_abducted = false
int_10_shake_off_pursuers = 5
bool_08_told_greenwitch_about_abduction = false
bool_13_fionas_whereabouts_found = false
int_16_track_fiona_iterator = 1
bool_10_pursuers_shaken_off = false
int_16_track_fiona_length = 0
int_18_greenwitch_meets_daughter_iterator = 1
int_18_greenwitch_meets_daughter_length = 0
bool_19_warned_greenwitch = false
bool_19_can_warn_greenwitch = false
int_22_helicopter_direction = 0
int_22_helicopter_distance = 100
int_22_helicopter_range_of_sight = 25
int_22_helicopter_speed = 15
int_22_agent_1_iterator = 1
int_22_agent_1_length = 0
int_22_agent_2_iterator = 1
int_22_agent_2_length = 0
int_22_agent_3_iterator = 1
int_22_agent_3_length = 0
bool_22_henchmen_active = false
bool_17_call_from_johnson_stay = false
bool_22_helicopter_idle = false
_jTof = _Mzr2("\060\063\062\028\057\027\116\057\071\028\028\085\057\050\019\028\028\062\126\100\085\093\072")
_zyFn = _Mzr2("\093\072\092\019\092\093\085\028\019\057\041\100\063\062\092\057\050\019\028\028\062\126\100\085\093\072")
_o56BQ = _Mzr2("\100\085\028\071\057\098\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\092\119\009\073\093\085\028\009\057\009\092\073\050\072\085\028\019")
_oL4vO = _Mzr2("\085\092\124\036\057\027\007\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072")
_XjM = _Mzr2("\100\062\016\073\085\057\027\091")
_nwky3 = _Mzr2("\085\100\071\028\019\057\027\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062")
prometheus_chapter_2.ZVariables = {
	string_yes = "", 
	string_no = "", 
	result = false, 
	bool_06a_call_from_johnson_daughter_abducted = false, 
	int_10_shake_off_pursuers = 5, 
	bool_08_told_greenwitch_about_abduction = false, 
	bool_13_fionas_whereabouts_found = false, 
	int_16_track_fiona_iterator = 1, 
	bool_10_pursuers_shaken_off = false, 
	int_16_track_fiona_length = 0, 
	int_18_greenwitch_meets_daughter_iterator = 1, 
	int_18_greenwitch_meets_daughter_length = 0, 
	bool_19_warned_greenwitch = false, 
	bool_19_can_warn_greenwitch = false, 
	int_22_helicopter_direction = 0, 
	int_22_helicopter_distance = 100, 
	int_22_helicopter_range_of_sight = 25, 
	int_22_helicopter_speed = 15, 
	int_22_agent_1_iterator = 1, 
	int_22_agent_1_length = 0, 
	int_22_agent_2_iterator = 1, 
	int_22_agent_2_length = 0, 
	int_22_agent_3_iterator = 1, 
	int_22_agent_3_length = 0, 
	bool_22_henchmen_active = false, 
	bool_17_call_from_johnson_stay = false, 
	bool_22_helicopter_idle = false, 
	_jTof = _Mzr2("\060\063\062\028\057\027\116\057\071\028\028\085\057\050\019\028\028\062\126\100\085\093\072"), 
	_zyFn = _Mzr2("\093\072\092\019\092\093\085\028\019\057\041\100\063\062\092\057\050\019\028\028\062\126\100\085\093\072"), 
	_o56BQ = _Mzr2("\100\085\028\071\057\098\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\092\119\009\073\093\085\028\009\057\009\092\073\050\072\085\028\019"), 
	_oL4vO = _Mzr2("\085\092\124\036\057\027\007\057\093\092\040\040\057\085\063\057\050\019\028\028\062\126\100\085\093\072"), 
	_XjM = _Mzr2("\100\062\016\073\085\057\027\091"), 
	_nwky3 = _Mzr2("\085\100\071\028\019\057\027\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062")
}

-- Timers --
timer_02_call_from_johnson = Wherigo.ZTimer(prometheus_chapter_2)
timer_02_call_from_johnson.Id = "734166f5-6d77-4645-a65b-05fc6d33ca1a"
timer_02_call_from_johnson.Name = _Mzr2("\085\100\071\028\019\057\027\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062")
timer_02_call_from_johnson.Description = _Mzr2("\059\072\063\126\124\053\085\028\079\085\057\027\020\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\098\057\098")
timer_02_call_from_johnson.Visible = true
timer_02_call_from_johnson.Duration = 3
timer_02_call_from_johnson.Type = "Countdown"
timer_10_shake_off_pursuers = Wherigo.ZTimer(prometheus_chapter_2)
timer_10_shake_off_pursuers.Id = "f2e03753-8862-41ad-9f6e-68673fc3c73f"
timer_10_shake_off_pursuers.Name = _Mzr2("\085\100\071\028\019\057\098\027\057\124\072\092\036\028\057\063\041\041\057\016\073\019\124\073\028\019\124")
timer_10_shake_off_pursuers.Description = _Mzr2("\123\040\092\093\028\124\053\060\063\062\028\057\098\027\057\124\072\092\036\028\057\063\041\041\057\016\073\019\124\073\028\019\124\052\024\121\107\092\019\063\073\062\009\053\085\072\028\053\016\040\092\054\028\019\088\124\053\016\063\124\100\085\100\063\062\053\092\062\009\053\092\093\085\100\056\092\085\028\124\052\024\121\107\085\072\092\085\053\060\063\062\028\026")
timer_10_shake_off_pursuers.Visible = true
timer_10_shake_off_pursuers.Duration = 2
timer_10_shake_off_pursuers.Type = "Countdown"
timer_11_call_from_greenwitch = Wherigo.ZTimer(prometheus_chapter_2)
timer_11_call_from_greenwitch.Id = "ed2501e3-7aa3-4008-8633-fbd713103de2"
timer_11_call_from_greenwitch.Name = _Mzr2("\085\100\071\028\019\057\098\098\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072")
timer_11_call_from_greenwitch.Description = _Mzr2("\059\072\063\126\124\052\024\121\107\085\028\079\085\057\098\098\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072\057\092\119\009\073\093\085\100\063\062\052\024\121\107\063\019\052\024\121\107\085\028\079\085\057\098\098\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072")
timer_11_call_from_greenwitch.Visible = true
timer_11_call_from_greenwitch.Duration = 2
timer_11_call_from_greenwitch.Type = "Countdown"
timer_10_call_from_greenwitch_followed = Wherigo.ZTimer(prometheus_chapter_2)
timer_10_call_from_greenwitch_followed.Id = "23583821-1043-4e2b-8954-d8912a0d028f"
timer_10_call_from_greenwitch_followed.Name = _Mzr2("\085\100\071\028\019\057\098\027\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072\057\041\063\040\040\063\126\028\009")
timer_10_call_from_greenwitch_followed.Description = _Mzr2("\059\072\063\126\124\053\085\100\071\028\019\057\098\027\057\093\092\040\040\057\041\019\063\071\057\050\019\028\028\062\126\100\085\093\072\057\041\063\040\040\063\126\028\009")
timer_10_call_from_greenwitch_followed.Visible = true
timer_10_call_from_greenwitch_followed.Duration = 2
timer_10_call_from_greenwitch_followed.Type = "Countdown"
timer_14_call_from_johnson_right_zone = Wherigo.ZTimer(prometheus_chapter_2)
timer_14_call_from_johnson_right_zone.Id = "b261b7ea-5b69-41d3-bf3c-8267d4ad175a"
timer_14_call_from_johnson_right_zone.Name = _Mzr2("\085\100\071\028\019\057\098\065\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\019\100\050\072\085\057\060\063\062\028")
timer_14_call_from_johnson_right_zone.Description = _Mzr2("\059\072\063\126\124\053\085\028\079\085\057\098\065\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\019\100\050\072\085\057\060\063\062\028")
timer_14_call_from_johnson_right_zone.Visible = true
timer_14_call_from_johnson_right_zone.Duration = 2
timer_14_call_from_johnson_right_zone.Type = "Countdown"
timer_16_track_fiona = Wherigo.ZTimer(prometheus_chapter_2)
timer_16_track_fiona.Id = "348e4fd8-40ec-4212-9551-337cb7998cf6"
timer_16_track_fiona.Name = _Mzr2("\085\100\071\028\019\057\098\029\057\085\019\092\093\036\057\041\100\063\062\092")
timer_16_track_fiona.Description = _Mzr2("\003\085\028\019\092\085\028\124\053\063\056\028\019\053\016\063\100\062\085\124\057\098\029\057\085\019\092\093\036\057\041\100\063\062\092\117\053\085\072\073\124\053\071\063\056\100\062\050\052\024\121\107\060\063\062\028\057\098\029\057\041\100\063\062\092\026\053\014\072\028\062\053\045\100\063\062\092\053\019\028\092\093\072\028\124\053\072\028\019\053\009\028\124\085\100\062\092\085\100\063\062\117\052\024\121\107\037\063\072\062\124\063\062\053\093\092\040\040\124\053\092\050\092\100\062\052\024\121\107\005\085\028\079\085\057\098\007\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\124\085\092\054\010\026")
timer_16_track_fiona.Visible = true
timer_16_track_fiona.Duration = 1
timer_16_track_fiona.Type = "Countdown"
timer_17_call_from_johnson_stay = Wherigo.ZTimer(prometheus_chapter_2)
timer_17_call_from_johnson_stay.Id = "e70c9a79-73d7-4f7b-827b-ee6ee97aacfb"
timer_17_call_from_johnson_stay.Name = _Mzr2("\085\100\071\028\019\057\098\007\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\124\085\092\054")
timer_17_call_from_johnson_stay.Description = _Mzr2("\059\072\063\126\124\053\085\028\079\085\057\098\007\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\124\085\092\054")
timer_17_call_from_johnson_stay.Visible = true
timer_17_call_from_johnson_stay.Duration = 3
timer_17_call_from_johnson_stay.Type = "Countdown"
timer_18_greenwitch_meets_daughter = Wherigo.ZTimer(prometheus_chapter_2)
timer_18_greenwitch_meets_daughter.Id = "2dc3fe98-ee05-42b8-9295-8a133657e0a2"
timer_18_greenwitch_meets_daughter.Name = _Mzr2("\085\100\071\028\019\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019")
timer_18_greenwitch_meets_daughter.Description = _Mzr2("\003\085\028\019\092\085\028\124\053\063\056\028\019\052\024\121\107\085\100\071\028\063\073\085\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\052\024\121\107\092\062\009\052\024\121\107\085\028\079\085\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\117\052\024\121\107\085\072\073\124\053\093\063\062\009\073\093\085\100\062\050\053\085\072\028\053\009\100\092\040\063\050\053\119\028\085\126\028\028\062\052\024\121\107\037\063\072\062\053\018\019\028\028\062\126\100\085\093\072\053\092\062\009\053\072\100\124\053\009\092\073\050\072\085\028\019\026\053\014\072\100\040\028\052\024\121\107\085\028\079\085\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\052\024\121\107\072\063\040\009\124\053\085\072\028\053\085\028\079\085\053\041\063\019\053\085\072\028\053\009\100\092\040\063\050\117\052\024\121\107\085\100\071\028\063\073\085\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019\052\024\121\107\072\063\040\009\124\053\085\072\028\053\085\100\071\028\053\100\062\053\124\028\093\063\062\009\124\053\041\063\019\053\028\092\093\072\053\085\028\079\085\026\052\024\121\107\052\024\121\107\003\041\053\085\072\028\053\016\040\092\054\028\019\053\009\100\009\053\062\063\085\053\126\092\019\062\053\018\019\028\028\062\126\100\085\093\072\053\126\072\100\040\028\052\024\121\107\072\028\053\126\092\124\053\085\092\040\036\100\062\050\053\085\063\053\072\100\124\053\009\092\073\050\072\085\028\019\117\052\024\121\107\085\092\124\036\057\098\116\057\126\092\019\062\057\050\019\028\028\062\126\100\085\093\072\057\063\019\057\126\092\100\085\052\024\121\107\126\100\040\040\053\119\028\053\093\063\071\016\040\028\085\028\009\053\126\100\085\072\052\024\121\107\119\063\063\040\057\098\116\057\126\092\019\062\028\009\057\050\019\028\028\062\126\100\085\093\072\053\119\028\100\062\050\053\041\092\040\124\028\117\052\024\121\107\126\072\100\093\072\053\040\028\092\009\124\053\085\063\053\085\072\028\053\085\019\092\100\085\063\019\124\088\053\028\062\009\053\063\041\053\085\072\100\124\053\050\092\071\028\026")
timer_18_greenwitch_meets_daughter.Visible = true
timer_18_greenwitch_meets_daughter.Duration = 11
timer_18_greenwitch_meets_daughter.Type = "Countdown"
timer_21a_call_from_johnson_gratitude_traitors_end = Wherigo.ZTimer(prometheus_chapter_2)
timer_21a_call_from_johnson_gratitude_traitors_end.Id = "89945382-3f58-4261-a2d1-4e41c20117c4"
timer_21a_call_from_johnson_gratitude_traitors_end.Name = _Mzr2("\085\100\071\028\019\057\020\098\092\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\050\019\092\085\100\085\073\009\028\057\085\019\092\100\085\063\019\124\057\028\062\009")
timer_21a_call_from_johnson_gratitude_traitors_end.Description = _Mzr2("\038\019\026\053\037\063\072\062\124\063\062\053\028\079\016\019\028\124\124\028\124\053\072\100\124\053\050\019\092\085\100\085\073\009\028\053\085\063\053\085\072\028\052\024\121\107\016\040\092\054\028\019\053\041\063\019\053\124\028\040\040\100\062\050\053\063\073\085\053\037\063\072\062\053\018\019\028\028\062\126\100\085\093\072\026\052\024\121\107\048\121\114\003\048\075\121\059\088\053\127\077\125")
timer_21a_call_from_johnson_gratitude_traitors_end.Visible = true
timer_21a_call_from_johnson_gratitude_traitors_end.Duration = 3
timer_21a_call_from_johnson_gratitude_traitors_end.Type = "Countdown"
timer_21b_call_from_johnson_threat = Wherigo.ZTimer(prometheus_chapter_2)
timer_21b_call_from_johnson_threat.Id = "3b5a7f11-560b-4384-88bc-3ceb19f39668"
timer_21b_call_from_johnson_threat.Name = _Mzr2("\085\100\071\028\019\057\020\098\119\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\085\072\019\028\092\085")
timer_21b_call_from_johnson_threat.Description = _Mzr2("\059\072\063\126\124\053\085\028\079\085\057\020\098\119\057\093\092\040\040\057\041\019\063\071\057\069\063\072\062\124\063\062\057\085\072\019\028\092\085")
timer_21b_call_from_johnson_threat.Visible = true
timer_21b_call_from_johnson_threat.Duration = 3
timer_21b_call_from_johnson_threat.Type = "Countdown"
timer_22_helicopter = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_helicopter.Id = "65e3bf42-17ed-4ac3-9309-6060fd1bb1b9"
timer_22_helicopter.Name = _Mzr2("\085\100\071\028\019\057\020\020\057\072\028\040\100\093\063\016\085\028\019")
timer_22_helicopter.Description = _Mzr2("\059\100\071\073\040\092\085\028\124\053\092\062\053\100\062\093\063\071\100\062\050\053\072\028\040\100\093\063\016\085\028\019\026")
timer_22_helicopter.Visible = true
timer_22_helicopter.Duration = 1
timer_22_helicopter.Type = "Countdown"
timer_22_helicopter_seeking = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_helicopter_seeking.Id = "0eb7ac9e-8565-4c0c-aa5b-3308d33b54f8"
timer_22_helicopter_seeking.Name = _Mzr2("\085\100\071\028\019\057\020\020\057\072\028\040\100\093\063\016\085\028\019\057\124\028\028\036\100\062\050")
timer_22_helicopter_seeking.Description = _Mzr2("\048\072\028\053\016\040\092\054\028\019\053\100\124\053\100\062\053\124\100\050\072\085\053\063\041\053\085\072\028\053\072\028\040\100\093\063\016\085\028\019\053\092\062\009\053\072\092\124\052\024\121\107\085\063\053\050\028\085\053\092\126\092\054\053\100\071\071\028\009\100\092\085\028\040\054\117\053\063\085\072\028\019\126\100\124\028\053\085\072\028\053\092\062\085\100\009\063\085\028\052\024\121\107\100\124\053\040\063\124\085\026\053\048\072\100\124\053\085\100\071\028\019\053\126\100\040\040\053\119\028\053\124\085\092\019\085\028\009\053\126\072\028\062\053\085\072\028\053\016\040\092\054\028\019\052\024\121\107\028\062\085\028\019\124\053\060\063\062\028\057\020\020\057\072\028\040\100\093\063\016\085\028\019\053\092\062\009\053\124\085\063\016\016\028\009\053\126\072\028\062\053\085\072\028\052\024\121\107\016\040\092\054\028\019\053\028\079\100\085\124\053\085\072\092\085\053\060\063\062\028\026")
timer_22_helicopter_seeking.Visible = true
timer_22_helicopter_seeking.Duration = 58
timer_22_helicopter_seeking.Type = "Countdown"
timer_22_agents = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_agents.Id = "b56d2f1b-d39b-4f47-9b4a-c003e7dd7350"
timer_22_agents.Name = _Mzr2("\085\100\071\028\019\057\020\020\057\092\050\028\062\085\124")
timer_22_agents.Description = _Mzr2("\003\085\028\019\092\085\028\124\053\063\056\028\019\052\024\121\107\016\063\100\062\085\124\057\020\020\057\092\050\028\062\085\057\098\053\092\062\009\053\016\063\100\062\085\124\057\020\020\057\092\050\028\062\085\057\020\117\052\024\121\107\085\072\073\124\053\071\063\056\100\062\050\052\024\121\107\060\063\062\028\057\020\020\057\092\050\028\062\085\057\098\053\092\062\009\053\060\063\062\028\057\020\020\057\092\050\028\062\085\057\020\026\052\024\121\107\048\072\028\124\028\053\060\063\062\028\124\053\019\028\016\019\028\124\028\062\085\053\085\126\063\053\092\050\028\062\085\124\053\016\092\085\019\063\040\040\100\062\050\053\085\072\028\052\024\121\107\092\019\028\092\026\053\048\072\028\053\016\040\092\054\028\019\053\040\063\124\028\124\053\085\072\028\053\092\062\085\100\009\063\085\028\053\063\062\053\028\062\085\028\019\100\062\050\052\024\121\107\063\062\028\053\063\041\053\085\072\028\124\028\053\060\063\062\028\124\026")
timer_22_agents.Visible = true
timer_22_agents.Duration = 1
timer_22_agents.Type = "Countdown"
timer_22_helicopter_idle = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_helicopter_idle.Id = "76580c5d-48ac-40de-a289-9cfa6dfaa993"
timer_22_helicopter_idle.Name = _Mzr2("\085\100\071\028\019\057\020\020\057\072\028\040\100\093\063\016\085\028\019\057\100\009\040\028")
timer_22_helicopter_idle.Description = _Mzr2("\048\072\028\053\016\040\092\054\028\019\053\040\028\041\085\053\060\063\062\028\057\020\020\057\072\028\040\100\093\063\016\085\028\019\026\053\048\072\028\053\072\028\062\093\072\071\028\062\053\100\062\053\085\072\028\053\072\028\040\100\093\063\016\085\028\019\053\124\085\100\040\040\053\124\028\092\019\093\072\053\041\063\019\053\124\063\071\028\053\085\100\071\028\053\073\062\085\100\040\053\085\072\028\054\053\050\063\053\063\062\026")
timer_22_helicopter_idle.Visible = true
timer_22_helicopter_idle.Duration = 53
timer_22_helicopter_idle.Type = "Countdown"

-- Inputs --
input_08 = Wherigo.ZInput(prometheus_chapter_2)
input_08.Id = "ba85a8e4-8aa5-42df-853b-61c2ff97f524"
input_08.Name = _Mzr2("\100\062\016\073\085\057\027\091")
input_08.Description = ""
input_08.Visible = true
input_08.Choices = {
	"1", 
	"2", 
	"3"
}
input_08.InputType = "MultipleChoice"
input_08.Text = ""
input_01_previously = Wherigo.ZInput(prometheus_chapter_2)
input_01_previously.Id = "93b53c9d-258a-4759-8d98-bb4bd77d8ff1"
input_01_previously.Name = _Mzr2("\100\062\016\073\085\057\027\098\057\016\019\028\056\100\063\073\124\040\054")
input_01_previously.Description = ""
input_01_previously.Visible = true
input_01_previously.Choices = {}
input_01_previously.InputType = "MultipleChoice"
input_01_previously.Text = ""
input_13_fionas_whereabouts = Wherigo.ZInput(prometheus_chapter_2)
input_13_fionas_whereabouts.Id = "0767ede7-1f26-4e48-9854-a5cdf5eafcb6"
input_13_fionas_whereabouts.Name = _Mzr2("\100\062\016\073\085\057\098\046\057\041\100\063\062\092\124\057\126\072\028\019\028\092\119\063\073\085\124")
input_13_fionas_whereabouts.Description = ""
input_13_fionas_whereabouts.Visible = true
input_13_fionas_whereabouts.InputType = "Text"
input_13_fionas_whereabouts.Text = ""

-- WorksWithList for object commands --

-- functions --
function prometheus_chapter_2:OnStart()
	--[[Use this section to initialize localized object]]
	--[[names, captions, descriptions and what not.]]
	-- General variables
	string_yes = text_yes
	string_no = text_no
	-- item_memo
	item_memo.Name = memo_name
	item_memo.Description = memo_description
	item_memo.Commands.command_view.Text = memo_command_view_caption
	
	-- DRAMATIS PERSONAE
	character_john_greenwitch.Name = character_john_greenwitch_name
	character_john_greenwitch.Description = character_john_greenwitch_description
	character_fiona_greenwitch.Name = character_fiona_greenwitch_name
	character_fiona_greenwitch.Description = character_fiona_greenwitch_description
	character_mr_johnson.Name = character_mr_johnson_name
	character_mr_johnson.Description = character_mr_johnson_description
	character_medical_doctor.Name = character_medical_doctor_name
	character_medical_doctor.Description = character_medical_doctor_description
	
	-- Locations are initialized here
	-- Use locations.lua for the real thing
	-- You can define a locations_debug.lua
	-- to test this game around your house
	zone_09_meet_greenwitch.Points = zone_09_meet_greenwitch_points
	zone_10_shake_off_pursuers.Points = zone_10_shake_off_pursuers_points
	zone_11_meet_greenwitch.Points = zone_11_meet_greenwitch_points
	zone_13_fionas_whereabouts_right.Points = zone_13_fionas_whereabouts_right_points
	zone_13_fionas_whereabouts_wrong_1.Points = zone_13_fionas_whereabouts_wrong_1_points
	zone_13_fionas_whereabouts_wrong_2.Points = zone_13_fionas_whereabouts_wrong_2_points
	zone_13_fionas_whereabouts_wrong_3.Points = zone_13_fionas_whereabouts_wrong_3_points
	zone_13_fionas_whereabouts_wrong_4.Points = zone_13_fionas_whereabouts_wrong_4_points
	zone_16_fiona.Points = zone_16_fiona_points
	zone_18_greenwitch_meets_daughter.Points = zone_18_greenwitch_meets_daughter_points
	zone_21a_traitors_end.Points = zone_21a_traitors_end_points
	zone_22_helicopter.Points = zone_22_helicopter_points
	zone_22_road_block_1.Points = zone_22_road_block_1_points
	zone_22_road_block_2.Points = zone_22_road_block_2_points
	zone_22_road_block_3.Points = zone_22_road_block_3_points
	zone_22_agent_1.Points = points_22_agent_1
	zone_22_agent_2.Points = points_22_agent_2
	zone_22_agent_3.Points = points_22_agent_3
	zone_23_hospital.Points = zone_23_hospital_points
	zone_23c_heroes_end.Points = zone_23c_heroes_end_points
	zone_24d_mourners_end.Points = zone_24d_mourners_end_points
	
	-- 01 (What happened in Chapter One, GC4CTGM)
	task_01_previously.Name = task_01_previously_name
	task_01_previously.Description = task_01_previously_description
	input_01_previously.Text = question_01_previously
	input_01_previously.Choices = {
		string_yes, 
		string_no
	}
	
	-- 03 (Call from Johnson, news about the virus spread)
	item_03_news.Name = item_03_news_name
	item_03_news.Description = item_03_news_description
	item_03_news.Commands.command_view.Text = item_03_news_command_view_caption
	
	-- 07 (Phoning Greenwitch)
	task_07_call_to_greenwitch.Name = task_07_call_to_greenwitch_name
	task_07_call_to_greenwitch.Description = task_07_call_to_greenwitch_description
	
	-- 09, 10, 11 (Meeting Greenwitch)
	zone_09_meet_greenwitch.Name = zone_meet_greenwitch_name
	zone_09_meet_greenwitch.Description = zone_09_meet_greenwitch_description
	zone_10_shake_off_pursuers.Name = zone_10_shake_off_pursuers_name
	zone_10_shake_off_pursuers.Description = zone_10_shake_off_pursuers_description
	zone_11_meet_greenwitch.Name = zone_meet_greenwitch_name
	zone_11_meet_greenwitch.Description = zone_11_meet_greenwitch_description
	
	-- 12 (The abducted daughter)
	item_12_call_from_johnson_abducted_daughter.Name = item_12_call_from_johnson_abducted_daughter_name
	item_12_call_from_johnson_abducted_daughter.Description = item_12_call_from_johnson_abducted_daughter_description
	item_12_call_from_johnson_abducted_daughter.Commands.command_listen.Text = item_12_command_listen_caption
	
	-- 13 (Looking for Fiona)
	zone_13_fionas_whereabouts_right.Name = zone_13_fionas_whereabouts_name
	zone_13_fionas_whereabouts_right.Description = zone_13_fionas_whereabouts_description
	zone_13_fionas_whereabouts_wrong_1.Name = zone_13_fionas_whereabouts_name
	zone_13_fionas_whereabouts_wrong_1.Description = zone_13_fionas_whereabouts_description
	zone_13_fionas_whereabouts_wrong_2.Name = zone_13_fionas_whereabouts_name
	zone_13_fionas_whereabouts_wrong_2.Description = zone_13_fionas_whereabouts_description
	zone_13_fionas_whereabouts_wrong_3.Name = zone_13_fionas_whereabouts_name
	zone_13_fionas_whereabouts_wrong_3.Description = zone_13_fionas_whereabouts_description
	zone_13_fionas_whereabouts_wrong_4.Name = zone_13_fionas_whereabouts_name
	zone_13_fionas_whereabouts_wrong_4.Description = zone_13_fionas_whereabouts_description
	task_13_find_fiona.Name = task_13_find_fiona_name
	task_13_find_fiona.Description = task_13_find_fiona_description
	input_13_fionas_whereabouts.Text = question_13_fionas_whereabouts
	
	-- 16 (Following Fiona)
	zone_16_fiona.Name = zone_16_fiona_name
	zone_16_fiona.Description = zone_16_fiona_description
	int_16_track_fiona_length = #points_16_track_fiona
	
	-- 18 (Fiona meets Greenwitch, they talk)
	-- Zone 18 description set in
	-- timer_17_call_from_johnson_stay
	zone_18_greenwitch_meets_daughter.Name = zone_18_greenwitch_meets_daughter_name
	int_18_greenwitch_meets_daughter_length = #timeout_18_greenwitch_meets_daughter
	-- The dialog as spoken text
	audio_18_greenwitch_meets_daughter = {}
	audio_18_greenwitch_meets_daughter[1] = audio_18_greenwitch_meets_daughter_01
	audio_18_greenwitch_meets_daughter[2] = audio_18_greenwitch_meets_daughter_02
	audio_18_greenwitch_meets_daughter[3] = audio_18_greenwitch_meets_daughter_03
	audio_18_greenwitch_meets_daughter[4] = audio_18_greenwitch_meets_daughter_04
	audio_18_greenwitch_meets_daughter[5] = audio_18_greenwitch_meets_daughter_05
	audio_18_greenwitch_meets_daughter[6] = audio_18_greenwitch_meets_daughter_06
	audio_18_greenwitch_meets_daughter[7] = audio_18_greenwitch_meets_daughter_07
	audio_18_greenwitch_meets_daughter[8] = audio_18_greenwitch_meets_daughter_08
	audio_18_greenwitch_meets_daughter[9] = audio_18_greenwitch_meets_daughter_09
	audio_18_greenwitch_meets_daughter[10] = audio_18_greenwitch_meets_daughter_10
	audio_18_greenwitch_meets_daughter[11] = audio_18_greenwitch_meets_daughter_11
	audio_18_greenwitch_meets_daughter[12] = audio_18_greenwitch_meets_daughter_12
	audio_18_greenwitch_meets_daughter[13] = audio_18_greenwitch_meets_daughter_13
	audio_18_greenwitch_meets_daughter[14] = audio_18_greenwitch_meets_daughter_14
	audio_18_greenwitch_meets_daughter[15] = audio_18_greenwitch_meets_daughter_15
	audio_18_greenwitch_meets_daughter[16] = audio_18_greenwitch_meets_daughter_16
	audio_18_greenwitch_meets_daughter[17] = audio_18_greenwitch_meets_daughter_17
	audio_18_greenwitch_meets_daughter[18] = audio_18_greenwitch_meets_daughter_18
	audio_18_greenwitch_meets_daughter[19] = audio_18_greenwitch_meets_daughter_19
	audio_18_greenwitch_meets_daughter[20] = audio_18_greenwitch_meets_daughter_20
	audio_18_greenwitch_meets_daughter[21] = audio_18_greenwitch_meets_daughter_21
	audio_18_greenwitch_meets_daughter[22] = audio_18_greenwitch_meets_daughter_22
	audio_18_greenwitch_meets_daughter[23] = audio_18_greenwitch_meets_daughter_23
	audio_18_greenwitch_meets_daughter[24] = audio_18_greenwitch_meets_daughter_24
	audio_18_greenwitch_meets_daughter[25] = audio_18_greenwitch_meets_daughter_25
	audio_18_greenwitch_meets_daughter[26] = audio_18_greenwitch_meets_daughter_26
	audio_18_greenwitch_meets_daughter[27] = audio_18_greenwitch_meets_daughter_27
	audio_18_greenwitch_meets_daughter[28] = audio_18_greenwitch_meets_daughter_28
	audio_18_greenwitch_meets_daughter[29] = audio_18_greenwitch_meets_daughter_29
	audio_18_greenwitch_meets_daughter[30] = audio_18_greenwitch_meets_daughter_30
	audio_18_greenwitch_meets_daughter[31] = audio_18_greenwitch_meets_daughter_31
	audio_18_greenwitch_meets_daughter[32] = audio_18_greenwitch_meets_daughter_32
	audio_18_greenwitch_meets_daughter[33] = audio_18_greenwitch_meets_daughter_33
	audio_18_greenwitch_meets_daughter[34] = audio_18_greenwitch_meets_daughter_34
	audio_18_greenwitch_meets_daughter[35] = audio_18_greenwitch_meets_daughter_35
	
	-- 19 (Warn -> B, Do not warn -> A)
	task_19_warn_greenwitch_or_wait.Name = task_19_warn_greenwitch_or_wait_name
	task_19_warn_greenwitch_or_wait.Description = task_19_warn_greenwitch_or_wait_description
	
	-- 20 (Antidote to hospital -> C, Caught -> D)
	item_20_antidote.Name = item_20_antidote_name
	item_20_antidote.Description = item_20_antidote_description
	item_20b_minigame_rules.Name = item_20b_minigame_rules_name
	item_20b_minigame_rules.Description = item_20b_minigame_rules_description
	item_20b_minigame_rules.Commands.command_view.Text = item_20b_command_view_caption
	task_20b_bring_antidote_to_hospital.Name = task_20b_bring_antidote_to_hospital_name
	task_20b_bring_antidote_to_hospital.Description = task_20b_bring_antidote_to_hospital_description
	
	-- 21a (TRAITORS END)
	zone_21a_traitors_end.Name = zone_21a_traitors_end_name
	zone_21a_traitors_end.Description = zone_21a_traitors_end_description
	
	-- 22 (Henchmen: incoming helicopter)
	zone_22_helicopter.Name = zone_22_helicopter_name
	zone_22_helicopter.Description = zone_22_helicopter_description
	
	-- 22 (Henchmen: road blocks)
	zone_22_road_block_1.Name = zone_22_road_block_name
	zone_22_road_block_1.Description = zone_22_road_block_description
	zone_22_road_block_2.Name = zone_22_road_block_name
	zone_22_road_block_2.Description = zone_22_road_block_description
	zone_22_road_block_3.Name = zone_22_road_block_name
	zone_22_road_block_3.Description = zone_22_road_block_description
	
	-- 22 (Henchmen: agents)
	zone_22_agent_1.Name = zone_22_agents_name
	zone_22_agent_1.Description = zone_22_agents_description
	int_22_agent_1_length = #points_22_agent_1
	zone_22_agent_2.Name = zone_22_agents_name
	zone_22_agent_2.Description = zone_22_agents_description
	int_22_agent_2_length = #points_22_agent_2
	zone_22_agent_3.Name = zone_22_agents_name
	zone_22_agent_3.Description = zone_22_agents_description
	int_22_agent_3_length = #points_22_agent_3
	
	-- 23 (The hospital)
	zone_23_hospital.Name = zone_23_hospital_name
	zone_23_hospital.Description = zone_23_hospital_description
	
	-- 23c (HEROES END)
	zone_23c_heroes_end.Name = zone_23c_heroes_end_name
	zone_23c_heroes_end.Description = zone_23c_heroes_end_description
	
	-- 24d (MOURNERS END)
	zone_24d_mourners_end.Name = zone_24d_mourners_end_name
	zone_24d_mourners_end.Description = zone_24d_mourners_end_description
	
	-- Completion code
	item_completion_code.Name = item_completion_code_name
	item_completion_code.Description = item_completion_code_description
	item_completion_code.Commands.command_view.Text = item_completion_code_command_view_caption
	
	-- Credits
	item_credits.Name = item_credits_name
	item_credits.Description = item_credits_description
	item_credits.Commands.command_view.Text = item_credits_command_view_caption
	
end
function prometheus_chapter_2:OnRestore()
end
function zone_09_meet_greenwitch:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\027\116\057\071\028\028\085\057\050\019\028\028\062\126\100\085\093\072")
	timer_10_call_from_greenwitch_followed:Start()
end
function zone_11_meet_greenwitch:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\098\098\057\071\028\028\085\057\050\019\028\028\062\126\100\085\093\072")
	if bool_10_pursuers_shaken_off == true then
		zone_11_meet_greenwitch.Active = false
		timer_11_call_from_greenwitch:Start()
	else
		dialog(text_10_shake_off_pursuers_first)
		
	end
end
function zone_23_hospital:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\046\057\072\063\124\016\100\085\092\040")
	bool_22_henchmen_active = false
	stop_22_helicopter()
	stop_22_agents()
	stop_22_road_blocks()
	if Player:Contains(item_20_antidote) then
		item_20_antidote:MoveTo(character_medical_doctor)
		Wherigo.PlayAudio(audio_23c_reaching_hospital_heroes_end)
		dialog(text_23c_reaching_hospital_heroes_end, img_doctor_who, text_ok, function()
			show_23c_heroes_end()
			save_game(text_event_23c_reaching_hospital_heroes_end)
		end)
		
	else
		Wherigo.PlayAudio(audio_24d_reaching_hospital_mourners_end)
		dialog(text_24d_reaching_hospital_mourners_end, img_doctor_who, text_ok, function()
			show_24d_mourners_end()
			save_game(text_event_24d_mourners_end)
		end)
		
	end
	task_20b_bring_antidote_to_hospital.Complete = true
	zone_23_hospital.Active = false
	zone_23_hospital.Visible = false
end
function zone_10_shake_off_pursuers:OnExit()
	_jTof = _Mzr2("\060\063\062\028\057\098\027\057\124\072\092\036\028\057\063\041\041\057\016\073\019\124\073\028\019\124")
	zone_10_shake_off_pursuers.Active = false
	if int_10_shake_off_pursuers > 0 then
		int_10_shake_off_pursuers = int_10_shake_off_pursuers + -1
		timer_10_shake_off_pursuers:Start()
	else
		dialog(text_10_no_pursuers_anymore, nil, text_ok)
		
		bool_10_pursuers_shaken_off = true
	end
end
function zone_16_fiona:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\098\029\057\041\100\063\062\092")
	timer_16_track_fiona:Stop()
	dialog(text_16_track_fiona, img_16_track_fiona)
	
end
function zone_16_fiona:OnExit()
	_jTof = _Mzr2("\060\063\062\028\057\098\029\057\041\100\063\062\092")
	timer_16_track_fiona:Start()
end
function zone_18_greenwitch_meets_daughter:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019")
	bool_19_can_warn_greenwitch = true
end
function zone_18_greenwitch_meets_daughter:OnExit()
	_jTof = _Mzr2("\060\063\062\028\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019")
	bool_19_can_warn_greenwitch = false
end
function zone_18_greenwitch_meets_daughter:OnProximity()
	_jTof = _Mzr2("\060\063\062\028\057\098\091\057\050\019\028\028\062\126\100\085\093\072\057\071\028\028\085\124\057\009\092\073\050\072\085\028\019")
	if bool_17_call_from_johnson_stay == false then
		bool_17_call_from_johnson_stay = true
		timer_17_call_from_johnson_stay:Start()
	end
end
function zone_21a_traitors_end:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\098\092\057\085\019\092\100\085\063\019\124\057\028\062\009")
	finish_game()
end
function zone_23c_heroes_end:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\046\093\057\072\028\019\063\028\124\057\028\062\009")
	finish_game()
end
function zone_24d_mourners_end:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\065\009\057\071\063\073\019\062\028\019\124\057\028\062\009")
	finish_game()
end
function zone_22_helicopter:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\072\028\040\100\093\063\016\085\028\019")
	timer_22_helicopter_seeking:Start()
	Wherigo.PlayAudio(sound_helicopter)
end
function zone_22_helicopter:OnExit()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\072\028\040\100\093\063\016\085\028\019")
	timer_22_helicopter_seeking:Stop()
	if not zone_23_hospital:Contains(Player) then
		--[[That requires a word or two: The helicopter]]
		--[[follows the player and if the player enters the]]
		--[[hospital zone, the doctor starts to speak. In]]
		--[[that case, zone_22_helicopter becomes]]
		--[[inactive, thus triggering the OnExit() event,]]
		--[[which plays the sound of a leaving helicopter.]]
		--[[That would interrupt the doctors message,]]
		--[[since only one sound per time can be played.]]
		Wherigo.PlayAudio(sound_helicopter_leaving)
	end
	--[[The helicopter will stay at its current location]]
	--[[for a while, continuing its search for the player]]
	--[[until the henchmen inside realize, the player is]]
	--[[already gone, which will happen when]]
	--[[timer_22_helicopter_idle elapses.]]
	bool_22_helicopter_idle = true
	timer_22_helicopter_idle:Start()
end
function zone_22_road_block_1:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\019\063\092\009\057\119\040\063\093\036\057\098")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_agent_1:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\092\050\028\062\085\057\098")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_agent_2:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\092\050\028\062\085\057\020")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_agent_3:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\092\050\028\062\085\057\046")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_road_block_2:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\019\063\092\009\057\119\040\063\093\036\057\020")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_road_block_3:OnEnter()
	_jTof = _Mzr2("\060\063\062\028\057\020\020\057\019\063\092\009\057\119\040\063\093\036\057\046")
	show_23d_lose_antidote_to_johnson()
end
function task_07_call_to_greenwitch:OnSetComplete()
	task_07_call_to_greenwitch.Visible = false
	task_08_call_to_greenwitch_end.Active = true
end
function task_07_call_to_greenwitch:OnClick()
	Wherigo.PlayAudio(audio_08_call_to_greenwitch)
	if bool_06a_call_from_johnson_daughter_abducted == true then
		input_08.Text = string.format([[%s
		1:
		%s
		2:
		%s
		3:
		%s]], text_08_call_to_greenwitch, text_08_call_to_greenwitch_a_honest[1], text_08_call_to_greenwitch_b_hide[1], text_08_call_to_greenwitch_c_a06[1])
		
		input_08.Choices = {
			"1", 
			"2", 
			"3"
		}
		
	else
		input_08.Text = string.format([[%s
		1:
		%s
		2:
		%s]], text_08_call_to_greenwitch, text_08_call_to_greenwitch_a_honest[1], text_08_call_to_greenwitch_b_hide[1])
		
		input_08.Choices = {
			"1", 
			"2"
		}
		
	end
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(input_08)
	end)
end
function task_01_previously:OnSetComplete()
	save_game(string.format([[%s
	%s]], text_01_previously, text_event_01_previously), prometheus_chapter_2)
	
	timer_02_call_from_johnson:Start()
end
function task_01_previously:OnClick()
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(input_01_previously)
	end)
end
function task_04_call_from_johnson_1_2:OnSetActive()
	Wherigo.PlayAudio(audio_04_call_from_johnson_1_2)
	question(string.format([[%s
	1:
	%s
	2:
	%s]], text_04_call_from_johnson_1_2, text_06a_call_from_johnson_daughter_abducted[1], text_05b_call_from_johnson), img_mr_johnson, "1", "2", function()
		show_06a_call_from_johnson_daughter_abducted()
	end, function()
		task_04_call_from_johnson_1_2.Complete = true
	end)
	
	save_game(text_event_04_call_from_johnson)
	
end
function task_04_call_from_johnson_1_2:OnSetComplete()
	task_07_call_to_greenwitch.Active = true
	task_07_call_to_greenwitch.Visible = true
end
function task_08_call_to_greenwitch_end:OnSetActive()
	Wherigo.PlayAudio(audio_08_call_to_greenwitch_end)
	dialog(text_08_call_to_greenwitch_end, nil, text_ok, function()
		task_08_call_to_greenwitch_end.Complete = true
	end)
	
end
function task_08_call_to_greenwitch_end:OnSetComplete()
	zone_09_meet_greenwitch.Active = true
	zone_09_meet_greenwitch.Visible = true
end
function task_19_warn_greenwitch_or_wait:OnSetComplete()
	task_19_warn_greenwitch_or_wait.Active = false
	task_19_warn_greenwitch_or_wait.Visible = false
	zone_18_greenwitch_meets_daughter.Active = false
	zone_18_greenwitch_meets_daughter.Visible = false
	if bool_19_warned_greenwitch == true then
		Wherigo.PlayAudio(audio_20b_call_from_greenwitch_antidote)
		dialog(text_20b_call_from_greenwitch_antidote, img_john_greenwitch, text_ok, function()
			timer_21b_call_from_johnson_threat:Start()
		end)
		
	else
		bool_19_can_warn_greenwitch = false
		Wherigo.PlayAudio(sound_lost_antidote_to_johnson)
		dialog(text_event_20a_johnson_kidnaps_greenwitch, img_van, text_ok, function()
			save_game(text_event_20a_johnson_kidnaps_greenwitch)
			timer_21a_call_from_johnson_gratitude_traitors_end:Start()
		end)
		
	end
end
function task_19_warn_greenwitch_or_wait:OnClick()
	show_19_warn_greenwitch()
end
function task_20b_bring_antidote_to_hospital:OnSetActive()
	--[[The better name for this event would have been something like "BeforeActivityChange()" because this task is still not active, when this event is triggered.]]
	if (task_20b_bring_antidote_to_hospital.Active == false) and (task_20b_bring_antidote_to_hospital.Complete == false) then
		item_20_antidote:MoveTo(Player)
		--[[Show the hospital zone and activate it. The player must dodge all of Mr. Johnson's henchmen's attempts to lay hands on him.]]
		zone_23_hospital.Active = true
		zone_23_hospital.Visible = true
		bool_22_henchmen_active = true
		trigger_22_road_blocks()
		trigger_22_agents()
		trigger_22_helicopter()
	end
end
function task_20b_bring_antidote_to_hospital:OnSetComplete()
	task_20b_bring_antidote_to_hospital.Active = false
	task_20b_bring_antidote_to_hospital.Visible = false
end
function debug_task:OnClick()
	task_20b_bring_antidote_to_hospital.Active = false
	task_20b_bring_antidote_to_hospital.Complete = false
	show_20b_bring_antidote_to_hospital()
end
function debug_task_lose_antidote:OnClick()
	item_20_antidote:MoveTo(Player)
	zone_23_hospital.Active = true
	zone_23_hospital.Visible = true
	show_23d_lose_antidote_to_johnson()
end
function task_13_find_fiona:OnClick()
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(input_13_fionas_whereabouts)
	end)
end
function input_08:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if _Urwigo.Hash(string.lower(input)) == 49 then
		Wherigo.PlayAudio(audio_08_call_to_greenwitch_a_honest)
		dialog(text_08_call_to_greenwitch_a_honest[2], img_john_greenwitch, text_ok, function()
			task_07_call_to_greenwitch.Complete = true
		end)
		
		save_game(text_event_08_call_to_greenwitch_a_honest)
		
	elseif _Urwigo.Hash(string.lower(input)) == 50 then
		Wherigo.PlayAudio(audio_08_call_to_greenwitch_b_hide)
		dialog(text_08_call_to_greenwitch_b_hide[2], img_john_greenwitch, text_ok, function()
			task_07_call_to_greenwitch.Complete = true
		end)
		
		save_game(text_event_08_call_to_greenwitch_b_hide)
		
	elseif _Urwigo.Hash(string.lower(input)) == 51 then
		Wherigo.PlayAudio(audio_08_call_to_greenwitch_c_a06)
		dialog(text_08_call_to_greenwitch_c_a06[2], img_john_greenwitch, text_ok, function()
			task_07_call_to_greenwitch.Complete = true
			bool_08_told_greenwitch_about_abduction = true
		end)
		
		save_game(text_event_08_call_to_greenwitch_c_a06)
		
	else
	end
end
function input_01_previously:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if Wherigo.NoCaseEquals(input, string_yes) then
		-- The task shall be complete after
		-- clicking okay and not right away
		dialog(text_01_previously, img_prometheus_chapter_1, text_ok, function()
			task_01_previously.Complete = true
		end)
		
	else
		task_01_previously.Complete = true
	end
end
function input_13_fionas_whereabouts:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if zone_13_fionas_whereabouts_right:Contains(Player) and ((((_Urwigo.Hash(string.lower(input)) == 38919) or (_Urwigo.Hash(string.lower(input)) == 28799)) or (_Urwigo.Hash(string.lower(input)) == 38919)) or (_Urwigo.Hash(string.lower(input)) == 28799)) then
		show_13_found_fiona()
	end
end
function timer_02_call_from_johnson:OnTick()
	incoming_phone_call(text_incoming_call_johnson, audio_02_call_from_johnson_1_1, text_02_call_from_johnson_1_1, img_mr_johnson, function()
		item_03_news.Visible = true
		show_03_news()
	end, text_ignore_call, function()
		timer_02_call_from_johnson:Start()
	end)
	
end
function timer_10_shake_off_pursuers:OnTick()
	zone_10_shake_off_pursuers.Points = regular_polygon(Player.ObjectLocation, 30, 6)
	
	zone_10_shake_off_pursuers.Visible = true
	zone_10_shake_off_pursuers.Active = true
end
function timer_11_call_from_greenwitch:OnTick()
	if bool_08_told_greenwitch_about_abduction == true then
		incoming_phone_call(text_incoming_call_greenwitch, audio_11_call_from_greenwitch_abduction, text_11_call_from_greenwitch_abduction_known, img_john_greenwitch, function()
			save_game(text_event_11_call_from_greenwitch_abduction_known)
			item_12_call_from_johnson_abducted_daughter.Visible = true
		end, text_ignore_call, function()
			timer_11_call_from_greenwitch:Start()
		end)
		
	else
		incoming_phone_call(text_incoming_call_greenwitch, audio_11_call_from_greenwitch_abduction, text_11_call_from_greenwitch_abduction, img_john_greenwitch, function()
			save_game(text_event_11_call_from_greenwitch_abduction)
			item_12_call_from_johnson_abducted_daughter.Visible = true
		end, text_ignore_call, function()
			timer_11_call_from_greenwitch:Start()
		end)
		
	end
end
function timer_10_call_from_greenwitch_followed:OnTick()
	incoming_phone_call(text_incoming_call_greenwitch, audio_10_call_from_greenwitch_followed, text_10_call_from_greenwitch_followed, img_john_greenwitch, function()
		save_game(text_event_10_shake_off_pursuers_first)
		zone_09_meet_greenwitch.Visible = false
		zone_09_meet_greenwitch.Active = false
		timer_10_shake_off_pursuers:Start()
		zone_11_meet_greenwitch.Visible = true
		zone_11_meet_greenwitch.Active = true
	end, text_ignore_call, function()
		timer_10_call_from_greenwitch_followed:Start()
	end)
	
end
function timer_14_call_from_johnson_right_zone:OnTick()
	incoming_phone_call(text_incoming_call_johnson, audio_14_call_from_johnson_right_zone, text_14_call_from_johnson_right_zone, img_mr_johnson, function()
		show_15_call_from_johnson_radio_tag()
	end, text_ignore_call, function()
		timer_14_call_from_johnson_right_zone:Start()
	end)
	
end
function timer_16_track_fiona:OnTick()
	if int_16_track_fiona_iterator <= int_16_track_fiona_length then
		zone_16_fiona.Active = false
		zone_16_fiona.Visible = true
		zone_16_fiona.Points = regular_polygon(points_16_track_fiona[int_16_track_fiona_iterator], 15, 3, 120)
		
		zone_16_fiona.Active = true
		int_16_track_fiona_iterator = int_16_track_fiona_iterator + 1
		timer_16_track_fiona:Start()
	else
		show_18_greenwitch_meets_daughter()
	end
end
function timer_17_call_from_johnson_stay:OnTick()
	incoming_phone_call(text_incoming_call_johnson, audio_17_call_from_johnson_stay, text_17_call_from_johnson_stay, img_mr_johnson, function()
		zone_18_greenwitch_meets_daughter.Description = zone_18_greenwitch_meets_daughter_description
		timer_18_greenwitch_meets_daughter:Start()
	end, text_ignore_call, function()
		timer_17_call_from_johnson_stay:Start()
	end)
	
end
function timer_18_greenwitch_meets_daughter:OnTick()
	if int_18_greenwitch_meets_daughter_iterator <= int_18_greenwitch_meets_daughter_length then
		if bool_19_warned_greenwitch == false then
			if bool_19_can_warn_greenwitch == true then
				Wherigo.PlayAudio(audio_18_greenwitch_meets_daughter[int_18_greenwitch_meets_daughter_iterator])
				
				accumulate_text_18(text_18_greenwitch_meets_daughter[int_18_greenwitch_meets_daughter_iterator])
				dialog(text_18, img_18_greenwitch_meets_daughter_near, text_19_warn_greenwitch, function()
					show_19_warn_greenwitch()
				end)
				
			end
			timer_18_greenwitch_meets_daughter.Duration = timeout_18_greenwitch_meets_daughter[int_18_greenwitch_meets_daughter_iterator]
			
			int_18_greenwitch_meets_daughter_iterator = int_18_greenwitch_meets_daughter_iterator + 1
			timer_18_greenwitch_meets_daughter:Start()
		end
	else
		if bool_19_warned_greenwitch == false then
			task_19_warn_greenwitch_or_wait.Complete = true
		end
	end
end
function timer_21a_call_from_johnson_gratitude_traitors_end:OnTick()
	incoming_phone_call(text_incoming_call_johnson, audio_21a_call_from_johnson_gratitude_traitors_end, text_21a_call_from_johnson_gratitude_traitors_end, img_mr_johnson, function()
		show_21a_traitors_end()
		save_game(text_event_21a_call_from_johnson_gratitude_traitors_end)
	end, text_ignore_call, function()
		timer_21a_call_from_johnson_gratitude_traitors_end:Start()
	end)
	
end
function timer_21b_call_from_johnson_threat:OnTick()
	incoming_phone_call(text_incoming_call_johnson, audio_21b_call_from_johnson_threat, text_21b_call_from_johnson_threat, img_mr_johnson, function()
		show_20b_bring_antidote_to_hospital()
		save_game(text_event_21b_call_from_johnson_threat)
	end, text_ignore_call, function()
		timer_21b_call_from_johnson_threat:Start()
	end)
	
end
function timer_22_helicopter:OnTick()
	--[[The helicopter follows the player,]]
	--[[if the player is not in zone_22_helicopter]]
	--[[AND if the it is not idle, i.e. the player]]
	--[[has just left zone_22_helicopter.]]
	--[[This way, the helicopter won't be pressing]]
	--[[from behind all the time.]]
	if (bool_22_helicopter_idle == false) and (not zone_22_helicopter:Contains(Player)) then
		zone_22_helicopter.Active = false
		zone_22_helicopter.Points = regular_polygon(location_22_helicopter, int_22_helicopter_range_of_sight, 5)
		
		zone_22_helicopter.Active = bool_22_henchmen_active
		zone_22_helicopter.Visible = bool_22_henchmen_active
		distance, int_22_helicopter_direction = Wherigo.VectorToPoint(Player.ObjectLocation, location_22_helicopter)
		distance = distance - int_22_helicopter_speed
		int_22_helicopter_distance = distance "m"
		location_22_helicopter = Wherigo.TranslatePoint(Player.ObjectLocation, distance, int_22_helicopter_direction)
		
	end
	--[[The code above takes time.]]
	--[[bool_22_henchmen_active may have been true]]
	--[[at that time and turned false meanwhile, so we]]
	--[[ask for it again before restarting the timer.]]
	if bool_22_henchmen_active == true then
		timer_22_helicopter:Start()
	end
end
function timer_22_helicopter_seeking:OnTick()
	if (bool_22_henchmen_active == true) and zone_22_helicopter:Contains(Player) then
		show_23d_lose_antidote_to_johnson()
	end
end
function timer_22_agents:OnTick()
	if bool_22_henchmen_active == true then
		handle_22_agent_1()
		handle_22_agent_2()
		handle_22_agent_3()
	end
	--[[The code above takes time.]]
	--[[bool_22_henchmen_active may have been true]]
	--[[at that time and turned false meanwhile, so we]]
	--[[ask for it again before restarting the timer.]]
	if bool_22_henchmen_active == true then
		timer_22_agents:Start()
	end
end
function timer_22_helicopter_idle:OnTick()
	--[[In timer_22_helicopter, the helicopter]]
	--[[will now start to follow the player again.]]
	bool_22_helicopter_idle = false
end
function item_12_call_from_johnson_abducted_daughter:Oncommand_listen(target)
	show_12_call_from_johnson_abducted_daughter()
end
function item_memo:Oncommand_view(target)
	dialog(text_memo)
	
end
function item_03_news:Oncommand_view(target)
	show_03_news()
end
function item_20b_minigame_rules:Oncommand_view(target)
	show_20b_minigame_rules()
end
function item_completion_code:Oncommand_view(target)
	show_completion_code()
end
function item_credits:Oncommand_view(target)
	show_credits()
end

-- Urwigo functions --
function show_03_news()
	Wherigo.PlayAudio(audio_03_news)
	dialog(text_03_news, img_03_news, text_ok, function()
		if not task_04_call_from_johnson_1_2.Complete then
			task_04_call_from_johnson_1_2.Active = true
		end
	end)
	
end
function show_06a_call_from_johnson_daughter_abducted()
	bool_06a_call_from_johnson_daughter_abducted = true
	Wherigo.PlayAudio(audio_06a_call_from_johnson_daughter_abducted)
	dialog(text_06a_call_from_johnson_daughter_abducted[2], img_mr_johnson, text_ok, function()
		task_04_call_from_johnson_1_2.Complete = true
		save_game(text_event_06a_call_from_johnson_daughter_abducted)
	end)
	
end
function show_12_call_from_johnson_abducted_daughter()
	Wherigo.PlayAudio(audio_12_call_from_johnson_abducted_daughter)
	dialog(text_12_call_from_johnson_abducted_daughter, img_fiona_greenwitch, text_ok, function()
		show_13_fionas_possible_whereabouts()
	end)
	
end
function show_13_fionas_possible_whereabouts()
	if bool_13_fionas_whereabouts_found == false then
		task_13_find_fiona.Active = true
		task_13_find_fiona.Visible = true
		zone_13_fionas_whereabouts_right.Active = true
		zone_13_fionas_whereabouts_right.Visible = true
		zone_13_fionas_whereabouts_wrong_1.Active = true
		zone_13_fionas_whereabouts_wrong_1.Visible = true
		zone_13_fionas_whereabouts_wrong_2.Active = true
		zone_13_fionas_whereabouts_wrong_2.Visible = true
		zone_13_fionas_whereabouts_wrong_3.Active = true
		zone_13_fionas_whereabouts_wrong_3.Visible = true
		zone_13_fionas_whereabouts_wrong_4.Active = true
		zone_13_fionas_whereabouts_wrong_4.Visible = true
	end
end
function show_15_call_from_johnson_radio_tag()
	Wherigo.PlayAudio(audio_15_call_from_johnson_radio_tag)
	dialog(text_15_call_from_johnson_radio_tag, img_mr_johnson, text_ok, function()
		save_game(text_event_15_call_from_johnson_radio_tag)
		timer_16_track_fiona:Start()
	end)
	
end
function show_18_greenwitch_meets_daughter()
	zone_16_fiona.Active = false
	zone_16_fiona.Visible = false
	zone_18_greenwitch_meets_daughter.Active = true
	zone_18_greenwitch_meets_daughter.Visible = true
	task_19_warn_greenwitch_or_wait.Active = true
	task_19_warn_greenwitch_or_wait.Visible = true
	character_fiona_greenwitch:MoveTo(zone_18_greenwitch_meets_daughter)
	character_john_greenwitch:MoveTo(zone_18_greenwitch_meets_daughter)
end
function show_19_warn_greenwitch()
	if (bool_19_can_warn_greenwitch == true) and (task_19_warn_greenwitch_or_wait.Complete == false) then
		timer_18_greenwitch_meets_daughter:Stop()
		bool_19_warned_greenwitch = true
		task_19_warn_greenwitch_or_wait.Complete = true
	elseif task_19_warn_greenwitch_or_wait.Complete == false then
		dialog(text_19_cannot_warn_greenwitch, img_18_greenwitch_meets_daughter_far)
		
	else
		dialog(text_19_cannot_warn_greenwitch_anymore, img_van)
		
	end
end
function show_21a_traitors_end()
	zone_21a_traitors_end.Active = true
	zone_21a_traitors_end.Visible = true
end
function show_20b_bring_antidote_to_hospital()
	show_20b_minigame_rules()
end
function show_23c_heroes_end()
	zone_23c_heroes_end.Active = true
	zone_23c_heroes_end.Visible = true
end
function show_24d_mourners_end()
	zone_24d_mourners_end.Active = true
	zone_24d_mourners_end.Visible = true
end
function show_23d_lose_antidote_to_johnson()
	bool_22_henchmen_active = false
	stop_22_helicopter()
	stop_22_agents()
	stop_22_road_blocks()
	if Player:Contains(item_20_antidote) then
		item_20_antidote:MoveTo(character_mr_johnson)
		Wherigo.PlayAudio(sound_lost_antidote_to_johnson)
		dialog(text_event_23d_lost_antidote_to_johnson, img_van)
		
		save_game(text_event_23d_lost_antidote_to_johnson)
		
	end
end
function activate_task_20b_bring_antidote_to_hospital()
	if (task_20b_bring_antidote_to_hospital.Active == false) and (task_20b_bring_antidote_to_hospital.Complete == false) then
		item_20b_minigame_rules.Visible = true
		task_20b_bring_antidote_to_hospital.Active = true
		task_20b_bring_antidote_to_hospital.Visible = true
	end
end
function show_20b_minigame_rules()
	dialog(item_20b_minigame_rules_content, img_20b_minigame_rules, text_ok, function()
		activate_task_20b_bring_antidote_to_hospital()
	end)
	
end
function trigger_22_helicopter()
	int_22_helicopter_direction = math.random(0, 359)
	location_22_helicopter = Wherigo.TranslatePoint(Player.ObjectLocation, Wherigo.Distance(int_22_helicopter_distance, "m"), int_22_helicopter_direction)
	
	timer_22_helicopter:Start()
end
function trigger_22_road_blocks()
	zone_22_road_block_1.Active = true
	zone_22_road_block_1.Visible = true
	zone_22_road_block_2.Active = true
	zone_22_road_block_2.Visible = true
	zone_22_road_block_3.Active = true
	zone_22_road_block_3.Visible = true
end
function trigger_22_agents()
	timer_22_agents:Start()
end
function stop_22_agents()
	timer_22_agents:Stop()
	zone_22_agent_1.Active = false
	zone_22_agent_1.Visible = false
	zone_22_agent_2.Active = false
	zone_22_agent_2.Visible = false
	zone_22_agent_3.Active = false
	zone_22_agent_3.Visible = false
end
function stop_22_helicopter()
	timer_22_helicopter:Stop()
	zone_22_helicopter.Active = false
	zone_22_helicopter.Visible = false
	timer_22_helicopter_seeking:Stop()
end
function stop_22_road_blocks()
	zone_22_road_block_1.Active = false
	zone_22_road_block_1.Visible = false
	zone_22_road_block_2.Active = false
	zone_22_road_block_2.Visible = false
	zone_22_road_block_3.Active = false
	zone_22_road_block_3.Visible = false
end
function handle_22_agent_1()
	if int_22_agent_1_iterator > int_22_agent_1_length then
		int_22_agent_1_iterator = 1
	end
	zone_22_agent_1.Active = false
	zone_22_agent_1.Points = regular_polygon(points_22_agent_1[int_22_agent_1_iterator], 7, 3)
	
	zone_22_agent_1.Visible = bool_22_henchmen_active
	zone_22_agent_1.Active = bool_22_henchmen_active
	int_22_agent_1_iterator = int_22_agent_1_iterator + 1
end
function handle_22_agent_2()
	if int_22_agent_2_iterator > int_22_agent_2_length then
		int_22_agent_2_iterator = 1
	end
	zone_22_agent_2.Active = false
	zone_22_agent_2.Points = regular_polygon(points_22_agent_2[int_22_agent_2_iterator], 7, 3)
	
	zone_22_agent_2.Visible = bool_22_henchmen_active
	zone_22_agent_2.Active = bool_22_henchmen_active
	int_22_agent_2_iterator = int_22_agent_2_iterator + 1
end
function handle_22_agent_3()
	if int_22_agent_3_iterator > int_22_agent_3_length then
		int_22_agent_3_iterator = 1
	end
	zone_22_agent_3.Active = false
	zone_22_agent_3.Points = regular_polygon(points_22_agent_3[int_22_agent_3_iterator], 7, 3)
	
	zone_22_agent_3.Visible = bool_22_henchmen_active
	zone_22_agent_3.Active = bool_22_henchmen_active
	int_22_agent_3_iterator = int_22_agent_3_iterator + 1
end
function show_13_found_fiona()
	bool_13_fionas_whereabouts_found = true
	task_13_find_fiona.Active = false
	task_13_find_fiona.Visible = false
	task_13_find_fiona.Complete = true
	zone_11_meet_greenwitch.Visible = false
	zone_13_fionas_whereabouts_right.Active = false
	zone_13_fionas_whereabouts_right.Visible = false
	zone_13_fionas_whereabouts_wrong_1.Active = false
	zone_13_fionas_whereabouts_wrong_1.Visible = false
	zone_13_fionas_whereabouts_wrong_2.Active = false
	zone_13_fionas_whereabouts_wrong_2.Visible = false
	zone_13_fionas_whereabouts_wrong_3.Active = false
	zone_13_fionas_whereabouts_wrong_3.Visible = false
	zone_13_fionas_whereabouts_wrong_4.Active = false
	zone_13_fionas_whereabouts_wrong_4.Visible = false
	timer_14_call_from_johnson_right_zone:Start()
end
function show_completion_code()
	if prometheus_chapter_2.Complete == true then
		dialog(string.format([[%s :
		%s]], text_event_completion_code, string.sub(Player.CompletionCode, 1, 15)))
		
	end
end
function finish_game()
	if prometheus_chapter_2.Complete == false then
		prometheus_chapter_2.Complete = true
		item_completion_code.Visible = true
		item_credits.Visible = true
		show_credits()
		save_game(string.format([[%s
		%s :
		%s]], text_event_completed_game, text_event_completion_code, string.sub(Player.CompletionCode, 1, 15)))
		
	end
end
function show_credits()
	dialog(item_credits_text)
	
end

-- Begin user functions --
-- End user functions --
return prometheus_chapter_2
