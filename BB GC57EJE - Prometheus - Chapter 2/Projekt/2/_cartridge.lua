require "Wherigo"
ZonePoint = Wherigo.ZonePoint
Distance = Wherigo.Distance
Player = Wherigo.Player

-- String decode --
function _u1Y0J(str)
	local res = ""
    local dtable = "\093\079\053\045\096\121\016\032\021\100\057\025\027\001\086\087\046\071\106\004\017\039\009\108\023\103\085\064\068\037\073\119\089\034\055\116\069\077\005\078\012\059\091\041\044\051\088\101\123\115\036\020\029\056\006\118\015\117\050\090\013\081\070\066\074\111\033\031\060\125\104\048\035\112\062\038\076\026\042\114\007\113\022\098\107\067\028\018\043\097\094\058\040\092\019\124\072\052\095\010\102\120\080\054\061\122\014\109\110\049\065\000\082\126\083\075\063\047\003\024\011\008\084\099\002\105\030"
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
		text_event_24d_mourner_end = "Ich konnte Greenwitchs Kontakt, einer Aerztin, kaum in die Augen schauen als ich ihr sagte, dass ich versagt habe. Sie meinte, dass Frau Onekana damit die Nacht nicht ueberleben wird. Ich sollte zumindest zum Friedhof und mich ins Kondolenzbuch eintragen. Ein paar Worte sollte ich ihr zumindest hinterlassen ..."
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
		-- Anrufbeantwortertext des Gesundheitsministeriums:
		-- DEACTIVATED in cartridge
		item_03_health_office_answering_machine_name = "0176 / 81 90 83 61"
		item_03_health_office_answering_machine_description = "Unter 0176 / 81 90 83 61 hat das Gesundheitsministerium eine Hotline geschaltet"
		item_03_health_office_answering_machine_command_call_caption = "Anrufen"
		-- Auf Mailbox sprechen: 0176 33 81 90 83 61, dann 3 (oder 9) (Geheimzahl 1033)
		text_03_health_office_answering_machine = "Willkommen beim Gesundheitsministerium. Bitte bewahren Sie Ruhe und verlassen Sie nach Moeglichkeit nicht Ihre Wohnung. Falls Sie unerklaerliche Symptome von Uebelkeit verspueren, kontaktieren Sie bitte umgehend den Rettungsdienst. Zur effizienteren Bearbeitung Ihres Vorganges, geben Sie dort bitte Ihre persoenliche Bearbeitungsreferenz an. Diese lautet: R6T5J2. Ich wiederhole: R6T5J2. Vielen Dank!"
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
		text_10_call_from_greenwitch_followed = "Augen auf! Sie werden verfolgt. Es ist hier zu unsicher und ich brauche Sie ohnehin an einem anderen Ort. Kommen Sie so schnell wie moeglich zu ..."
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
		text_11_call_from_greenwitch_abduction_known = [[Sehr gut. Ich glaube, es ist Ihnen niemand mehr gefolgt. Ich muss immer noch sehr vorsichtig sein. Vielleicht mehr denn je!
Aber ich habe den Punkt, an dem Sie sich befinden auch nicht zufaellig gewaehlt. Es es geht um Fiona... Meine Tochter. Sie wurde gestern von hier entfuehrt. Und Johnson steckt dahinter.
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
		question_13_fionas_whereabouts = "Ich muss herausfinden, wer sie festhaelt."
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
Aber Johnson wird nicht weit sein. Ich vermute, die wissen bereits von meinem Plan. Aber mit Ihrer Hilfe bin ich zuversichtlich.
Sie muessen dieses Gegenmittel zum Krankenhaus bringen. Passen Sie auf Johnsons Schergen auf. Wenn die Sie in die Finger kriegen, haben wir alles verloren.
Aber bedenken Sie, was es zu gewinnen gibt, wenn Sie das Gegenmittel unserer Kontaktperson im Krankenhaus bringen. Wir werden Menschen retten!
Also los, verlieren wir keine Zeit. Beeilen Sie sich!]]
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
Oh, verflucht! Das war ihre einzige Chance! Sie wird die Nacht nicht ueberleben... Ich habe noch noch eine Bitte an Sie: Beten Sie fuer Frau Onekana.
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
		item_credits_text = ((((((([[Dramatis Personae

]]..[[John Greenwitch
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
]])..[[Kamera
     Dave
]])..[[Programmierung
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
		zone_21a_traitors_end_description = "Hier irgendwo befindet sich ein toter Briefkasten, bei dem ich mich als neuer Mitarbeiter fuer die Zeus Incorporated eintragen kann."
		zone_22_secure_name = "Sicherer Bereich"
		zone_22_secure_description = "In diesem Bereich bin ich fuer ein paar Sekunden sicher vor Johnson's Haeschern."
		zone_22_helicopter_name = "Zeus Inc. Helikopter"
		zone_22_helicopter_description = "Der Hubschrauber der Zeus Inc. sucht nach mir, wenn er mich ueberfliegt, muss ich seinem Sichtbereich so schnell wie moeglich wieder entkommen."
		zone_22_road_block_name = "Strassensperre"
		zone_22_road_block_description = "Mr. Johnson hat dort ein paar Vans zur Beobachtung der Strasse abgestellt. Ich muss einen anderen Weg finden und darf den Vans auf keinen Fall zu nahe kommen."
		zone_22_agents_name = "Zeus Inc. Agent"
		zone_22_agents_description = "Einer von Mr. Johnsons Agenten. Ich muss an ihm vorbei schleichen. Ich darf ihm nicht zu nahe kommen."
		zone_23_hospital_name = "Krankenhaus"
		zone_23_hospital_description = "Hier wird John Greenwitch's Kontaktperson, ein Arzt, auf mich warten. Ihm muss ich das Gegenmittel geben."
		zone_23c_heroes_end_name = "Toter Briefkasten"
		zone_23c_heroes_end_description = "Hier irgendwo befindet sich ein toter Briefkasten, bei dem ich mich eintragen kann."
		zone_24d_mourners_end_name = "Kondolenzbuch"
		zone_24d_mourners_end_description = "Hier befindet sich das Kondolenzbuch fuer Patient 0. Ich sollte mich einschreiben und mich wenigstens an seinen richtigen Namen erinnern."
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
img_zone_hospital.Id = "37f24121-d72c-459f-830f-d6c06a95679d"
img_zone_hospital.Name = _u1Y0J("\126\108\026\099\106\066\109\048\099\071\066\050\074\126\036\090\024")
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
img_footprints.Id = "ce815922-c66a-4239-9c98-689df6069e7b"
img_footprints.Name = _u1Y0J("\126\108\026\099\101\066\066\036\074\080\126\109\036\050")
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
img_memo.Id = "41932cc6-30d7-499d-8b4e-75793a5e69df"
img_memo.Name = _u1Y0J("\126\108\026\099\108\048\108\066")
img_memo.Description = ""
img_memo.AltText = _u1Y0J("\038\048\108\066")
img_memo.Resources = {
	{
		Type = "jpg", 
		Filename = "memo.jpg", 
		Directives = {}
	}
}
icon_memo = Wherigo.ZMedia(prometheus_chapter_2)
icon_memo.Id = "6925138e-4e27-4d0e-9855-13a2f9cfcb9e"
icon_memo.Name = _u1Y0J("\126\124\066\109\099\108\048\108\066")
icon_memo.Description = ""
icon_memo.AltText = _u1Y0J("\038\048\108\066")
icon_memo.Resources = {
	{
		Type = "png", 
		Filename = "icon_memo.png", 
		Directives = {}
	}
}
img_incoming_call = Wherigo.ZMedia(prometheus_chapter_2)
img_incoming_call.Id = "31b08387-fc86-4874-a013-c3155129db6d"
img_incoming_call.Name = _u1Y0J("\126\108\026\099\126\109\124\066\108\126\109\026\099\124\090\024\024")
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
sound_phone_ring.Id = "88d77af5-08f3-4ddb-899d-1bb0bb6197be"
sound_phone_ring.Name = _u1Y0J("\050\066\058\109\010\099\074\071\066\109\048\099\080\126\109\026")
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
sound_phone_ring_garmin.Id = "0da68b48-6f76-4fe4-b8ca-f473b4fab1cd"
sound_phone_ring_garmin.Name = _u1Y0J("\050\066\058\109\010\099\074\071\066\109\048\099\080\126\109\026\099\026\090\080\108\126\109")
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
img_mr_johnson.Id = "68ce02d2-8b86-417a-b553-af4d5f57f51b"
img_mr_johnson.Name = _u1Y0J("\126\108\026\099\108\080\099\019\066\071\109\050\066\109")
img_mr_johnson.Description = ""
img_mr_johnson.AltText = _u1Y0J("\038\080\017\008\065\066\071\109\050\066\109")
img_mr_johnson.Resources = {
	{
		Type = "jpg", 
		Filename = "mr_johnson.jpg", 
		Directives = {}
	}
}
audio_02_call_from_johnson_1_1 = Wherigo.ZMedia(prometheus_chapter_2)
audio_02_call_from_johnson_1_1.Id = "2eac794c-4f76-45c0-8a34-9cdc5f09262b"
audio_02_call_from_johnson_1_1.Name = _u1Y0J("\090\058\010\126\066\099\072\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\110\099\110")
audio_02_call_from_johnson_1_1.Description = ""
audio_02_call_from_johnson_1_1.AltText = ""
audio_02_call_from_johnson_1_1.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_02_call_from_johnson_1_1.mp3", 
		Directives = {}
	}
}
audio_03_health_office_answering_machine = Wherigo.ZMedia(prometheus_chapter_2)
audio_03_health_office_answering_machine.Id = "0585f99d-c1b9-486b-a203-a7a15fc8757c"
audio_03_health_office_answering_machine.Name = _u1Y0J("\090\058\010\126\066\099\072\046\099\071\048\090\024\036\071\099\066\101\101\126\124\048\099\090\109\050\032\048\080\126\109\026\099\108\090\124\071\126\109\048")
audio_03_health_office_answering_machine.Description = ""
audio_03_health_office_answering_machine.AltText = ""
audio_03_health_office_answering_machine.Resources = {
	{
		Type = "mp3", 
		Filename = "audio_03_health_office_answering_machine.mp3", 
		Directives = {}
	}
}
audio_04_call_from_johnson_1_2 = Wherigo.ZMedia(prometheus_chapter_2)
audio_04_call_from_johnson_1_2.Id = "3874ef93-75c4-414f-89be-c5a7b1abadd7"
audio_04_call_from_johnson_1_2.Name = _u1Y0J("\090\058\010\126\066\099\072\098\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\110\099\059")
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
audio_06a_call_from_johnson_daughter_abducted.Id = "e3bebec1-42c3-4dd5-93e6-dd8fd61894c9"
audio_06a_call_from_johnson_daughter_abducted.Name = _u1Y0J("\090\058\010\126\066\099\072\104\090\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\010\090\058\026\071\036\048\080\099\090\084\010\058\124\036\048\010")
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
audio_14_call_from_johnson_right_zone.Id = "df4c874e-7f63-40ad-bdb1-3f282cfe8b84"
audio_14_call_from_johnson_right_zone.Name = _u1Y0J("\090\058\010\126\066\099\110\098\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\080\126\026\071\036\099\106\066\109\048")
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
audio_15_call_from_johnson_radio_tag.Id = "bc19608b-3cab-40e3-ae1f-89b87f3bc772"
audio_15_call_from_johnson_radio_tag.Name = _u1Y0J("\090\058\010\126\066\099\110\003\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\080\090\010\126\066\099\036\090\026")
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
audio_17_call_from_johnson_stay.Id = "3078415a-e3ca-4412-b70c-a57d8aae3a88"
audio_17_call_from_johnson_stay.Name = _u1Y0J("\090\058\010\126\066\099\110\035\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\050\036\090\006")
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
audio_18_greenwitch_meets_daughter_01.Id = "8cd4bf93-2147-467b-9cdf-7b5f754a66d7"
audio_18_greenwitch_meets_daughter_01.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\110")
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
audio_18_greenwitch_meets_daughter_02.Id = "d5c7d969-322e-40a8-bd6a-651ab7955f84"
audio_18_greenwitch_meets_daughter_02.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\059")
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
audio_18_greenwitch_meets_daughter_03.Id = "91a964d6-4f06-4a71-b985-ce443f817d11"
audio_18_greenwitch_meets_daughter_03.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\046")
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
audio_18_greenwitch_meets_daughter_04.Id = "b66736d8-7f02-4235-804d-12b40532128b"
audio_18_greenwitch_meets_daughter_04.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\098")
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
audio_18_greenwitch_meets_daughter_05.Id = "a47a5148-265c-42fa-91cc-40005c8bbe1d"
audio_18_greenwitch_meets_daughter_05.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\003")
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
audio_18_greenwitch_meets_daughter_06.Id = "0c8e01ff-e526-4b31-bf78-b30b26db1f42"
audio_18_greenwitch_meets_daughter_06.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\104")
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
audio_18_greenwitch_meets_daughter_07.Id = "0a22afe3-cd0e-46b2-9c98-8a8f06d68a78"
audio_18_greenwitch_meets_daughter_07.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\035")
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
audio_18_greenwitch_meets_daughter_08.Id = "5e8bc251-74d8-4385-8578-4ed9c4384efc"
audio_18_greenwitch_meets_daughter_08.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\054")
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
audio_18_greenwitch_meets_daughter_09.Id = "41758773-277b-4a3a-85f3-4c2711a2a6fc"
audio_18_greenwitch_meets_daughter_09.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\072\011")
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
audio_18_greenwitch_meets_daughter_10.Id = "017ae4eb-759b-4963-85d8-cee395bbea9d"
audio_18_greenwitch_meets_daughter_10.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\072")
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
audio_18_greenwitch_meets_daughter_11.Id = "f82eaf08-001a-4bf4-b4e9-d994023512bb"
audio_18_greenwitch_meets_daughter_11.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\110")
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
audio_18_greenwitch_meets_daughter_12.Id = "7a13b199-f627-4f07-a243-60be5117d68a"
audio_18_greenwitch_meets_daughter_12.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\059")
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
audio_18_greenwitch_meets_daughter_13.Id = "cb5b8243-fe7b-4cb6-a8a4-7d22a4b5b0de"
audio_18_greenwitch_meets_daughter_13.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\046")
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
audio_18_greenwitch_meets_daughter_14.Id = "861f9c32-5dd1-4f26-9484-e73169d6d042"
audio_18_greenwitch_meets_daughter_14.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\098")
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
audio_18_greenwitch_meets_daughter_15.Id = "0b412b34-96d7-4825-bb11-a98516487532"
audio_18_greenwitch_meets_daughter_15.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\003")
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
audio_18_greenwitch_meets_daughter_16.Id = "6865895f-1141-49dc-9200-1554f229e5f3"
audio_18_greenwitch_meets_daughter_16.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\104")
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
audio_18_greenwitch_meets_daughter_17.Id = "3b29a1f4-c694-43c0-be32-d91cb582d4c1"
audio_18_greenwitch_meets_daughter_17.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\035")
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
audio_18_greenwitch_meets_daughter_18.Id = "dbff73ec-1554-459e-b2cb-6ef4eb4c4a47"
audio_18_greenwitch_meets_daughter_18.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\054")
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
audio_18_greenwitch_meets_daughter_19.Id = "0d189247-0fcb-40c4-a5b8-42b28549288e"
audio_18_greenwitch_meets_daughter_19.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\110\011")
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
audio_18_greenwitch_meets_daughter_20.Id = "8d80fe64-2ac3-47c5-a016-bfe5eac5357f"
audio_18_greenwitch_meets_daughter_20.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\072")
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
audio_18_greenwitch_meets_daughter_21.Id = "b64d3b2f-ee04-4ff1-9bd6-2ecf73473066"
audio_18_greenwitch_meets_daughter_21.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\110")
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
audio_18_greenwitch_meets_daughter_22.Id = "d51631f8-6a4e-40be-8c3e-cf2ee3113ade"
audio_18_greenwitch_meets_daughter_22.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\059")
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
audio_18_greenwitch_meets_daughter_23.Id = "5a65313a-7e55-4486-8114-6274b787891e"
audio_18_greenwitch_meets_daughter_23.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\046")
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
audio_18_greenwitch_meets_daughter_24.Id = "370ef352-39cb-437d-81d4-ad6e3ea46c11"
audio_18_greenwitch_meets_daughter_24.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\098")
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
audio_18_greenwitch_meets_daughter_25.Id = "2f6b0ee0-fc3f-4b9a-bcb0-0920608c2deb"
audio_18_greenwitch_meets_daughter_25.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\003")
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
audio_18_greenwitch_meets_daughter_26.Id = "d295ff31-7683-4b2c-ad56-c9964bf7729c"
audio_18_greenwitch_meets_daughter_26.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\104")
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
audio_18_greenwitch_meets_daughter_27.Id = "a4cb7187-af4c-47ce-9981-d5e9ba01dc96"
audio_18_greenwitch_meets_daughter_27.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\035")
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
audio_18_greenwitch_meets_daughter_28.Id = "a3db88c4-f691-46b4-b40f-fcd55e722f18"
audio_18_greenwitch_meets_daughter_28.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\054")
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
audio_18_greenwitch_meets_daughter_29.Id = "94df82d1-8a81-4601-8e2b-0c4d5f8bdd8c"
audio_18_greenwitch_meets_daughter_29.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\059\011")
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
audio_18_greenwitch_meets_daughter_30.Id = "49f72ab2-37e9-4d74-ad76-bb533dc3620c"
audio_18_greenwitch_meets_daughter_30.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\046\072")
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
audio_18_greenwitch_meets_daughter_31.Id = "d9e2b94a-113a-4f85-a59b-e33445f3e2d9"
audio_18_greenwitch_meets_daughter_31.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\046\110")
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
audio_18_greenwitch_meets_daughter_32.Id = "93a6adbc-9be2-4260-8f4b-d2ddc7725b23"
audio_18_greenwitch_meets_daughter_32.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\046\059")
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
audio_18_greenwitch_meets_daughter_33.Id = "b755aacd-e9b5-4a22-aa3c-f1df92288176"
audio_18_greenwitch_meets_daughter_33.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\046\046")
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
audio_18_greenwitch_meets_daughter_34.Id = "81f16fc5-2258-4288-9fab-d340278b405d"
audio_18_greenwitch_meets_daughter_34.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\046\098")
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
audio_18_greenwitch_meets_daughter_35.Id = "348636d2-5e6e-4772-a65c-b8e8a9ea86eb"
audio_18_greenwitch_meets_daughter_35.Name = _u1Y0J("\090\058\010\126\066\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\046\003")
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
audio_21a_call_from_johnson_gratitude_traitors_end.Id = "ccfab39e-3dd1-4f63-ac51-4a9182a8efe7"
audio_21a_call_from_johnson_gratitude_traitors_end.Name = _u1Y0J("\090\058\010\126\066\099\059\110\090\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\026\080\090\036\126\036\058\010\048\099\036\080\090\126\036\066\080\050\099\048\109\010")
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
audio_21b_call_from_johnson_threat.Id = "d7053e02-2a11-4dfa-b410-f6843154ba74"
audio_21b_call_from_johnson_threat.Name = _u1Y0J("\090\058\010\126\066\099\059\110\084\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\036\071\080\048\090\036")
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
img_john_greenwitch.Id = "f0e7686c-eff8-43a1-9efa-d7ad5348c632"
img_john_greenwitch.Name = _u1Y0J("\126\108\026\099\019\066\071\109\099\026\080\048\048\109\032\126\036\124\071")
img_john_greenwitch.Description = ""
img_john_greenwitch.AltText = _u1Y0J("\065\066\071\109\008\018\080\048\048\109\032\126\036\124\071")
img_john_greenwitch.Resources = {
	{
		Type = "jpg", 
		Filename = "john_greenwitch.jpg", 
		Directives = {}
	}
}
img_telephone = Wherigo.ZMedia(prometheus_chapter_2)
img_telephone.Id = "34b4ddf2-1990-445a-9f91-fb0893083684"
img_telephone.Name = _u1Y0J("\126\108\026\099\036\048\024\048\074\071\066\109\048")
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
icon_telephone.Id = "c1b60cae-a142-433e-bcae-be3db3ded997"
icon_telephone.Name = _u1Y0J("\126\124\066\109\099\036\048\024\048\074\071\066\109\048")
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
audio_10_call_from_greenwitch_followed.Id = "73dc3669-b68f-4db9-ac41-108825fbdacd"
audio_10_call_from_greenwitch_followed.Name = _u1Y0J("\090\058\010\126\066\099\110\072\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071\099\101\066\024\024\066\032\048\010")
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
audio_11_call_from_greenwitch_abduction.Id = "bf3336b2-a528-4254-8941-3f22e41b907d"
audio_11_call_from_greenwitch_abduction.Name = _u1Y0J("\090\058\010\126\066\099\110\110\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071\099\090\084\010\058\124\036\126\066\109")
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
audio_11_call_from_greenwitch_abduction_known.Id = "0b42694e-9a5e-4d5a-bc44-e50cbf67c6d7"
audio_11_call_from_greenwitch_abduction_known.Name = _u1Y0J("\090\058\010\126\066\099\110\110\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071\099\090\084\010\058\124\036\126\066\109\099\085\109\066\032\109")
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
img_zeus.Id = "09582292-1d9f-4a1a-b686-ae46c8d05ddc"
img_zeus.Name = _u1Y0J("\126\108\026\099\106\048\058\050")
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
img_antidote.Id = "cf5a6164-d4d5-4a5a-81d0-7d529c7b2160"
img_antidote.Name = _u1Y0J("\126\108\026\099\090\109\036\126\010\066\036\048")
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
img_fiona_greenwitch.Id = "21517a5f-b3aa-4ae4-94fb-4284fc6cde72"
img_fiona_greenwitch.Name = _u1Y0J("\126\108\026\099\101\126\066\109\090\099\026\080\048\048\109\032\126\036\124\071")
img_fiona_greenwitch.Description = ""
img_fiona_greenwitch.AltText = _u1Y0J("\063\126\066\109\090\008\018\080\048\048\109\032\126\036\124\071")
img_fiona_greenwitch.Resources = {
	{
		Type = "jpg", 
		Filename = "fiona_greenwitch.jpg", 
		Directives = {}
	}
}
img_prometheus_chapter_1 = Wherigo.ZMedia(prometheus_chapter_2)
img_prometheus_chapter_1.Id = "db7cda1f-a1f8-4833-8725-ddebc7595542"
img_prometheus_chapter_1.Name = _u1Y0J("\126\108\026\099\074\080\066\108\048\036\071\048\058\050\099\124\071\090\074\036\048\080\099\110")
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
img_20b_minigame_rules.Id = "fca5e5ce-64ae-48a3-a7c0-21336b7b3b5e"
img_20b_minigame_rules.Name = _u1Y0J("\126\108\026\099\059\072\084\099\108\126\109\126\026\090\108\048\099\080\058\024\048\050")
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
img_van.Id = "7183efaf-4a9f-4f8a-9d19-4f2dd090a418"
img_van.Name = _u1Y0J("\126\108\026\099\056\090\109")
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
sound_lost_antidote_to_johnson.Id = "b8c14855-e752-4626-a655-80cbfb7454cf"
sound_lost_antidote_to_johnson.Name = _u1Y0J("\050\066\058\109\010\099\024\066\050\036\099\090\109\036\126\010\066\036\048\099\036\066\099\019\066\071\109\050\066\109")
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
sound_helicopter.Id = "1b03fa1e-defe-4916-a4f9-1c3bd3945a31"
sound_helicopter.Name = _u1Y0J("\050\066\058\109\010\099\071\048\024\126\124\066\074\036\048\080")
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
audio_23c_reaching_hospital_heroes_end.Id = "15a66220-9506-43e7-b1ab-e58207388853"
audio_23c_reaching_hospital_heroes_end.Name = _u1Y0J("\090\058\010\126\066\099\059\046\124\099\080\048\090\124\071\126\109\026\099\071\066\050\074\126\036\090\024\099\071\048\080\066\048\050\099\048\109\010")
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
audio_24d_reaching_hospital_mourners_end.Id = "6f616257-1439-4eba-9a4a-ab364fd7a002"
audio_24d_reaching_hospital_mourners_end.Name = _u1Y0J("\090\058\010\126\066\099\059\098\010\099\080\048\090\124\071\126\109\026\099\071\066\050\074\126\036\090\024\099\108\066\058\080\109\048\080\050\099\048\109\010")
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
img_16_track_fiona.Id = "7c24e8bf-35a6-4420-b858-73faf55e1fae"
img_16_track_fiona.Name = _u1Y0J("\126\108\026\099\110\104\099\036\080\090\124\085\099\101\126\066\109\090")
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
img_18_greenwitch_meets_daughter_far.Id = "29b40674-d3e5-40a8-ae27-a35e787734b7"
img_18_greenwitch_meets_daughter_far.Name = _u1Y0J("\126\108\026\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\101\090\080")
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
img_18_greenwitch_meets_daughter_near.Id = "f9936d4c-f3c6-43fa-ac0b-2db2dca23bef"
img_18_greenwitch_meets_daughter_near.Name = _u1Y0J("\126\108\026\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\099\109\048\090\080")
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
audio_12_call_from_johnson_abducted_daughter.Id = "82e47ac7-9deb-4b20-b89d-b55a4c0424f5"
audio_12_call_from_johnson_abducted_daughter.Name = _u1Y0J("\090\058\010\126\066\099\110\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\090\084\010\058\124\036\048\010\099\010\090\058\026\071\036\048\080")
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
audio_08_call_to_greenwitch.Id = "d93a32e1-fadf-4e5d-af38-e59bb69ae99a"
audio_08_call_to_greenwitch.Name = _u1Y0J("\090\058\010\126\066\099\072\054\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071")
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
audio_08_call_to_greenwitch_a_honest.Id = "ffa65050-a361-431f-b00c-09ddfed22a66"
audio_08_call_to_greenwitch_a_honest.Name = _u1Y0J("\090\058\010\126\066\099\072\054\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071\099\090\099\071\066\109\048\050\036")
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
audio_08_call_to_greenwitch_b_hide.Id = "ff638cc1-2643-4621-a0a0-cc698a52f9e4"
audio_08_call_to_greenwitch_b_hide.Name = _u1Y0J("\090\058\010\126\066\099\072\054\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071\099\084\099\071\126\010\048")
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
audio_08_call_to_greenwitch_c_a06.Id = "4462ee51-db20-4f78-8b7d-dca226316d57"
audio_08_call_to_greenwitch_c_a06.Name = _u1Y0J("\090\058\010\126\066\099\072\054\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071\099\124\099\090\072\104")
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
audio_08_call_to_greenwitch_end.Id = "4a67adc3-15c2-465c-a1ae-44b93e8d056f"
audio_08_call_to_greenwitch_end.Name = _u1Y0J("\090\058\010\126\066\099\072\054\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071\099\048\109\010")
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
icon_title.Id = "dea485d9-a9b6-44be-b24c-d6f1f9770be3"
icon_title.Name = _u1Y0J("\126\124\066\109\099\036\126\036\024\048")
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
img_title.Id = "16541c46-6afd-4984-816c-bf3653fa158d"
img_title.Name = _u1Y0J("\126\108\026\099\036\126\036\024\048")
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
sound_helicopter_leaving.Id = "678129dd-80f6-4749-8c33-d93a6b0c2644"
sound_helicopter_leaving.Name = _u1Y0J("\050\066\058\109\010\099\071\048\024\126\124\066\074\036\048\080\099\024\048\090\056\126\109\026")
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
img_doctor_who.Id = "f0aa32d0-b8e9-48fb-b890-1bf8be739b7b"
img_doctor_who.Name = _u1Y0J("\126\108\026\099\010\066\124\036\066\080\099\032\071\066")
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
img_03_news.Id = "bcad871d-f931-4239-b5ac-7f5b7fe0990d"
img_03_news.Name = _u1Y0J("\126\108\026\099\072\046\099\109\048\032\050")
img_03_news.Description = ""
img_03_news.AltText = ""
img_03_news.Resources = {
	{
		Type = "jpg", 
		Filename = "news_image.jpg", 
		Directives = {}
	}
}
-- Cartridge Info --
prometheus_chapter_2.Id="e7d006af-515d-4d77-bf38-afbcdd2bf35f"
prometheus_chapter_2.Name="Prometheus DE - Chapter 2: Konsequenzen"
prometheus_chapter_2.Description=[[Nachdem du dich in Kapitel 1 Projekt Pandora (coord.info/gc4ctgm) gegen Mr. Johnson entschieden hast, muss die Welt und auch du nun die Konsequenzen dafuer tragen, dass das Gegenmittel nicht in Masse produziert wurde. Mr. Johnson gibt dir aber noch einmal eine Chance.]]
prometheus_chapter_2.Visible=true
prometheus_chapter_2.Activity="Fiction"
prometheus_chapter_2.StartingLocationDescription=[[Fuer weitere Informationen geh bitte zum zugehoerigen Geocache GC57EJE (coord.info/gc57eje)]]
prometheus_chapter_2.StartingLocation = ZonePoint(52.50991,13.46219,0)
prometheus_chapter_2.Version="3.0"
prometheus_chapter_2.Company=""
prometheus_chapter_2.Author="David Greenwitch and Mahanako"
prometheus_chapter_2.BuilderVersion="URWIGO 1.20.5218.24064"
prometheus_chapter_2.CreateDate="09/12/2013 19:14:05"
prometheus_chapter_2.PublishDate="1/1/0001 12:00:00 AM"
prometheus_chapter_2.UpdateDate="08/10/2014 11:30:02"
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
zone_09_meet_greenwitch.Id = "e39e1dd4-c89a-41f0-8cbb-a1ef248fb99f"
zone_09_meet_greenwitch.Name = _u1Y0J("\106\066\109\048\099\072\011\099\108\048\048\036\099\026\080\048\048\109\032\126\036\124\071")
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
zone_11_meet_greenwitch.Id = "49a7c41a-4a42-4b74-bd06-81dac90dbb9a"
zone_11_meet_greenwitch.Name = _u1Y0J("\106\066\109\048\099\110\110\099\108\048\048\036\099\026\080\048\048\109\032\126\036\124\071")
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
zone_23_hospital.Id = "29bdf92d-7dea-4da3-8c6f-6fd8c8a558e1"
zone_23_hospital.Name = _u1Y0J("\106\066\109\048\099\059\046\099\071\066\050\074\126\036\090\024")
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
zone_10_shake_off_pursuers.Id = "b6933860-80ab-4b54-9f9d-583503b33c07"
zone_10_shake_off_pursuers.Name = _u1Y0J("\106\066\109\048\099\110\072\099\050\071\090\085\048\099\066\101\101\099\074\058\080\050\058\048\080\050")
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
zone_13_fionas_whereabouts_right.Id = "904de13f-fe1d-42e2-b921-199f9bde4f6f"
zone_13_fionas_whereabouts_right.Name = _u1Y0J("\106\066\109\048\099\110\046\099\101\126\066\109\090\050\099\032\071\048\080\048\090\084\066\058\036\050\099\080\126\026\071\036")
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
zone_13_fionas_whereabouts_wrong_4.Id = "ece21ecf-920d-473f-837a-8ed2190014f8"
zone_13_fionas_whereabouts_wrong_4.Name = _u1Y0J("\106\066\109\048\099\110\046\099\101\126\066\109\090\050\099\032\071\048\080\048\090\084\066\058\036\050\099\032\080\066\109\026\099\098")
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
zone_13_fionas_whereabouts_wrong_2.Id = "1f66ab86-e5a0-48d2-adc1-7bf2012f6ae4"
zone_13_fionas_whereabouts_wrong_2.Name = _u1Y0J("\106\066\109\048\099\110\046\099\101\126\066\109\090\050\099\032\071\048\080\048\090\084\066\058\036\050\099\032\080\066\109\026\099\059")
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
zone_16_fiona.Id = "e50d6136-c92f-429f-a837-80385d2d2547"
zone_16_fiona.Name = _u1Y0J("\106\066\109\048\099\110\104\099\101\126\066\109\090")
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
zone_18_greenwitch_meets_daughter.Id = "23050dc3-cee2-40db-971a-53332d7faa48"
zone_18_greenwitch_meets_daughter.Name = _u1Y0J("\106\066\109\048\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080")
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
zone_21a_traitors_end.Id = "49806a49-8862-481f-81c2-ab9dcdde2a12"
zone_21a_traitors_end.Name = _u1Y0J("\106\066\109\048\099\059\110\090\099\036\080\090\126\036\066\080\050\099\048\109\010")
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
zone_23c_heroes_end.Id = "23b1b907-a59c-4694-ad1a-d80609e95c21"
zone_23c_heroes_end.Name = _u1Y0J("\106\066\109\048\099\059\046\124\099\071\048\080\066\048\050\099\048\109\010")
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
zone_24d_mourners_end.Id = "caca62fe-c336-4a82-8b30-acf885abeb2c"
zone_24d_mourners_end.Name = _u1Y0J("\106\066\109\048\099\059\098\010\099\108\066\058\080\109\048\080\050\099\048\109\010")
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
zone_22_helicopter.Id = "34bc0103-be3a-451f-ab11-dff4d19026be"
zone_22_helicopter.Name = _u1Y0J("\106\066\109\048\099\059\059\099\071\048\024\126\124\066\074\036\048\080")
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
zone_22_road_block_1.Id = "3fd4ba06-d671-43e2-97e1-814c0e2e658d"
zone_22_road_block_1.Name = _u1Y0J("\106\066\109\048\099\059\059\099\080\066\090\010\099\084\024\066\124\085\099\110")
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
zone_22_agent_1.Id = "5402951c-f6a0-45e7-9b32-bd277ffad76d"
zone_22_agent_1.Name = _u1Y0J("\106\066\109\048\099\059\059\099\090\026\048\109\036\099\110")
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
zone_22_agent_2.Id = "3cc891c4-e74f-431d-83ce-7f03583cce48"
zone_22_agent_2.Name = _u1Y0J("\106\066\109\048\099\059\059\099\090\026\048\109\036\099\059")
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
zone_13_fionas_whereabouts_wrong_3.Id = "1a669bb8-b5d8-468a-8844-354b4b4cb2b0"
zone_13_fionas_whereabouts_wrong_3.Name = _u1Y0J("\106\066\109\048\099\110\046\099\101\126\066\109\090\050\099\032\071\048\080\048\090\084\066\058\036\050\099\032\080\066\109\026\099\046")
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
zone_13_fionas_whereabouts_wrong_1.Id = "184b3e1e-0335-4ad4-aee9-fdc94756ac8e"
zone_13_fionas_whereabouts_wrong_1.Name = _u1Y0J("\106\066\109\048\099\110\046\099\101\126\066\109\090\050\099\032\071\048\080\048\090\084\066\058\036\050\099\032\080\066\109\026\099\110")
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
zone_22_agent_3.Id = "70b7adda-e8a5-40ac-8a29-6ea5f0cf63f1"
zone_22_agent_3.Name = _u1Y0J("\106\066\109\048\099\059\059\099\090\026\048\109\036\099\046")
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
zone_22_road_block_2.Id = "d172e5a1-84e5-4a90-833c-b45982a589f9"
zone_22_road_block_2.Name = _u1Y0J("\106\066\109\048\099\059\059\099\080\066\090\010\099\084\024\066\124\085\099\059")
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
zone_22_road_block_3.Id = "f22566ee-683b-463e-b028-7eaf45bbd373"
zone_22_road_block_3.Name = _u1Y0J("\106\066\109\048\099\059\059\099\080\066\090\010\099\084\024\066\124\085\099\046")
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
character_fiona_greenwitch.Id = "abd918cb-9754-42d8-8162-1990714c539e"
character_fiona_greenwitch.Name = _u1Y0J("\063\126\066\109\090\008\018\080\048\048\109\032\126\036\124\071")
character_fiona_greenwitch.Description = ""
character_fiona_greenwitch.Visible = true
character_fiona_greenwitch.Media = img_fiona_greenwitch
character_fiona_greenwitch.Commands = {}
character_fiona_greenwitch.ObjectLocation = Wherigo.INVALID_ZONEPOINT
character_fiona_greenwitch.Gender = "Female"
character_fiona_greenwitch.Type = "NPC"
character_john_greenwitch = Wherigo.ZCharacter(prometheus_chapter_2)
character_john_greenwitch.Id = "2d79d85b-d7bb-4c8e-978b-ba731e3dba0e"
character_john_greenwitch.Name = _u1Y0J("\065\066\071\109\008\018\080\048\048\109\032\126\036\124\071")
character_john_greenwitch.Description = ""
character_john_greenwitch.Visible = true
character_john_greenwitch.Media = img_john_greenwitch
character_john_greenwitch.Commands = {}
character_john_greenwitch.ObjectLocation = Wherigo.INVALID_ZONEPOINT
character_john_greenwitch.Gender = "Male"
character_john_greenwitch.Type = "NPC"
character_mr_johnson = Wherigo.ZCharacter(prometheus_chapter_2)
character_mr_johnson.Id = "c934da4d-07d1-4b4a-9bce-444261051770"
character_mr_johnson.Name = _u1Y0J("\038\080\017\008\065\066\071\109\050\066\109")
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
character_medical_doctor.Id = "178c71dd-7386-4db6-b807-a747b27f91ce"
character_medical_doctor.Name = _u1Y0J("\029\080\017\008\016\097\002")
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
item_12_call_from_johnson_abducted_daughter.Id = "fdc6592c-d834-4d74-86eb-82a7de77d79c"
item_12_call_from_johnson_abducted_daughter.Name = _u1Y0J("\126\036\048\108\099\110\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\090\084\010\058\124\036\048\010\099\010\090\058\026\071\036\048\080")
item_12_call_from_johnson_abducted_daughter.Description = ""
item_12_call_from_johnson_abducted_daughter.Visible = false
item_12_call_from_johnson_abducted_daughter.Commands = {
	command_listen = Wherigo.ZCommand{
		Text = _u1Y0J("\124\066\108\108\090\109\010\099\024\126\050\036\048\109"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _u1Y0J("\040\066\036\071\126\109\026\008\090\056\090\126\024\090\084\024\048")
	}
}
item_12_call_from_johnson_abducted_daughter.Commands.command_listen.Custom = true
item_12_call_from_johnson_abducted_daughter.Commands.command_listen.Id = "e046a527-1f73-42c4-b4cf-9f2844f21a1c"
item_12_call_from_johnson_abducted_daughter.Commands.command_listen.WorksWithAll = true
item_12_call_from_johnson_abducted_daughter.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_12_call_from_johnson_abducted_daughter.Locked = false
item_12_call_from_johnson_abducted_daughter.Opened = false
item_memo = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_memo.Id = "78a2a281-39b5-4761-ad99-80951bb0d338"
item_memo.Name = _u1Y0J("\126\036\048\108\099\108\048\108\066")
item_memo.Description = ""
item_memo.Visible = true
item_memo.Media = img_memo
item_memo.Icon = icon_memo
item_memo.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _u1Y0J("\124\066\108\108\090\109\010\099\056\126\048\032"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _u1Y0J("\040\066\036\071\126\109\026\008\090\056\090\126\024\090\084\024\048")
	}
}
item_memo.Commands.command_view.Custom = true
item_memo.Commands.command_view.Id = "e60a1ed3-c1eb-43bc-b2ed-d4f1a0c040aa"
item_memo.Commands.command_view.WorksWithAll = true
item_memo.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_memo.Locked = false
item_memo.Opened = false
item_03_health_office_answering_machine = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_03_health_office_answering_machine.Id = "b4df85f0-aab2-4efb-982f-9350c6984251"
item_03_health_office_answering_machine.Name = _u1Y0J("\126\036\048\108\099\072\046\099\071\048\090\024\036\071\099\066\101\101\126\124\048\099\090\109\050\032\048\080\126\109\026\099\108\090\124\071\126\109\048")
item_03_health_office_answering_machine.Description = ""
item_03_health_office_answering_machine.Visible = false
item_03_health_office_answering_machine.Media = img_telephone
item_03_health_office_answering_machine.Icon = icon_telephone
item_03_health_office_answering_machine.Commands = {
	command_call = Wherigo.ZCommand{
		Text = _u1Y0J("\124\066\108\108\090\109\010\099\124\090\024\024"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _u1Y0J("\040\066\036\071\126\109\026\008\090\056\090\126\024\090\084\024\048")
	}
}
item_03_health_office_answering_machine.Commands.command_call.Custom = true
item_03_health_office_answering_machine.Commands.command_call.Id = "62fe9e30-f11c-45a3-aa30-4dbae04a9db8"
item_03_health_office_answering_machine.Commands.command_call.WorksWithAll = true
item_03_health_office_answering_machine.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_03_health_office_answering_machine.Locked = false
item_03_health_office_answering_machine.Opened = false
item_03_news = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_03_news.Id = "6abc85b4-c546-484e-a010-78c15efde9dc"
item_03_news.Name = _u1Y0J("\126\036\048\108\099\072\046\099\109\048\032\050")
item_03_news.Description = ""
item_03_news.Visible = false
item_03_news.Media = img_03_news
item_03_news.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _u1Y0J("\124\066\108\108\090\109\010\099\056\126\048\032"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _u1Y0J("\040\066\036\071\126\109\026\008\090\056\090\126\024\090\084\024\048")
	}
}
item_03_news.Commands.command_view.Custom = true
item_03_news.Commands.command_view.Id = "0da953eb-d43a-4c38-835f-a98411fab7b1"
item_03_news.Commands.command_view.WorksWithAll = true
item_03_news.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_03_news.Locked = false
item_03_news.Opened = false
item_20_antidote = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = character_john_greenwitch
}
item_20_antidote.Id = "694b003d-97f7-4c99-b500-c2cfc6dffe8a"
item_20_antidote.Name = _u1Y0J("\126\036\048\108\099\059\072\099\090\109\036\126\010\066\036\048")
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
item_20b_minigame_rules.Id = "2bbc7f28-3a41-45ba-b528-9ccaa73f9089"
item_20b_minigame_rules.Name = _u1Y0J("\126\036\048\108\099\059\072\084\099\108\126\109\126\026\090\108\048\099\080\058\024\048\050")
item_20b_minigame_rules.Description = ""
item_20b_minigame_rules.Visible = false
item_20b_minigame_rules.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _u1Y0J("\124\066\108\108\090\109\010\099\056\126\048\032"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = ""
	}
}
item_20b_minigame_rules.Commands.command_view.Custom = true
item_20b_minigame_rules.Commands.command_view.Id = "a13a18e4-8011-4630-ab9f-461df3b56e20"
item_20b_minigame_rules.Commands.command_view.WorksWithAll = true
item_20b_minigame_rules.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_20b_minigame_rules.Locked = false
item_20b_minigame_rules.Opened = false
item_completion_code = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_completion_code.Id = "124f2061-7259-4a35-a60d-f86dc233493d"
item_completion_code.Name = _u1Y0J("\126\036\048\108\099\124\066\108\074\024\048\036\126\066\109\099\124\066\010\048")
item_completion_code.Description = ""
item_completion_code.Visible = false
item_completion_code.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _u1Y0J("\124\066\108\108\090\109\010\099\056\126\048\032"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = ""
	}
}
item_completion_code.Commands.command_view.Custom = true
item_completion_code.Commands.command_view.Id = "f5a2d8c5-1e95-4086-a852-fc6967490cc6"
item_completion_code.Commands.command_view.WorksWithAll = true
item_completion_code.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_completion_code.Locked = false
item_completion_code.Opened = false
item_credits = Wherigo.ZItem{
	Cartridge = prometheus_chapter_2, 
	Container = Player
}
item_credits.Id = "61ea82f3-9903-4920-96d0-a44904894c19"
item_credits.Name = _u1Y0J("\126\036\048\108\099\124\080\048\010\126\036\050")
item_credits.Description = ""
item_credits.Visible = false
item_credits.Commands = {
	command_view = Wherigo.ZCommand{
		Text = _u1Y0J("\124\066\108\108\090\109\010\099\056\126\048\032"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = ""
	}
}
item_credits.Commands.command_view.Custom = true
item_credits.Commands.command_view.Id = "3c6175c4-f9ee-41c5-8a04-6f732fb9bfb6"
item_credits.Commands.command_view.WorksWithAll = true
item_credits.ObjectLocation = Wherigo.INVALID_ZONEPOINT
item_credits.Locked = false
item_credits.Opened = false

-- Tasks --
task_07_call_to_greenwitch = Wherigo.ZTask(prometheus_chapter_2)
task_07_call_to_greenwitch.Id = "770d4083-ff2f-4ed7-b74a-4bb967bc1c17"
task_07_call_to_greenwitch.Name = _u1Y0J("\036\090\050\085\099\072\035\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071")
task_07_call_to_greenwitch.Description = ""
task_07_call_to_greenwitch.Visible = false
task_07_call_to_greenwitch.Active = false
task_07_call_to_greenwitch.Complete = false
task_07_call_to_greenwitch.CorrectState = "None"
task_01_previously = Wherigo.ZTask(prometheus_chapter_2)
task_01_previously.Id = "3fde63b0-670d-4848-85bd-18e7f8c3e01f"
task_01_previously.Name = _u1Y0J("\036\090\050\085\099\072\110\099\074\080\048\056\126\066\058\050\024\006")
task_01_previously.Description = ""
task_01_previously.Visible = true
task_01_previously.Active = true
task_01_previously.Complete = false
task_01_previously.CorrectState = "None"
task_04_call_from_johnson_1_2 = Wherigo.ZTask(prometheus_chapter_2)
task_04_call_from_johnson_1_2.Id = "4e25f17d-71d4-4c79-8946-461457e3a5a8"
task_04_call_from_johnson_1_2.Name = _u1Y0J("\036\090\050\085\099\072\098\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\110\099\059")
task_04_call_from_johnson_1_2.Description = ""
task_04_call_from_johnson_1_2.Visible = false
task_04_call_from_johnson_1_2.Active = false
task_04_call_from_johnson_1_2.Complete = false
task_04_call_from_johnson_1_2.CorrectState = "None"
task_08_call_to_greenwitch_end = Wherigo.ZTask(prometheus_chapter_2)
task_08_call_to_greenwitch_end.Id = "b3a2b797-4bf3-47ec-902b-7a9bea4bc692"
task_08_call_to_greenwitch_end.Name = _u1Y0J("\036\090\050\085\099\072\054\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071\099\048\109\010")
task_08_call_to_greenwitch_end.Description = ""
task_08_call_to_greenwitch_end.Visible = false
task_08_call_to_greenwitch_end.Active = false
task_08_call_to_greenwitch_end.Complete = false
task_08_call_to_greenwitch_end.CorrectState = "None"
task_19_warn_greenwitch_or_wait = Wherigo.ZTask(prometheus_chapter_2)
task_19_warn_greenwitch_or_wait.Id = "98fcdec0-ae13-4e47-aba9-8c7efa374a7c"
task_19_warn_greenwitch_or_wait.Name = _u1Y0J("\036\090\050\085\099\110\011\099\032\090\080\109\099\026\080\048\048\109\032\126\036\124\071\099\066\080\099\032\090\126\036")
task_19_warn_greenwitch_or_wait.Description = ""
task_19_warn_greenwitch_or_wait.Visible = false
task_19_warn_greenwitch_or_wait.Active = false
task_19_warn_greenwitch_or_wait.Complete = false
task_19_warn_greenwitch_or_wait.CorrectState = "None"
task_20b_bring_antidote_to_hospital = Wherigo.ZTask(prometheus_chapter_2)
task_20b_bring_antidote_to_hospital.Id = "5b55effa-d928-4ef1-966d-707e5b7e30a3"
task_20b_bring_antidote_to_hospital.Name = _u1Y0J("\036\090\050\085\099\059\072\084\099\084\080\126\109\026\099\090\109\036\126\010\066\036\048\099\036\066\099\071\066\050\074\126\036\090\024")
task_20b_bring_antidote_to_hospital.Description = ""
task_20b_bring_antidote_to_hospital.Visible = false
task_20b_bring_antidote_to_hospital.Active = false
task_20b_bring_antidote_to_hospital.Complete = false
task_20b_bring_antidote_to_hospital.CorrectState = "None"
debug_task = Wherigo.ZTask(prometheus_chapter_2)
debug_task.Id = "63aa1c0e-ea07-45d3-a44c-df800dc39acd"
debug_task.Name = _u1Y0J("\010\048\084\058\026\099\036\090\050\085")
debug_task.Description = ""
debug_task.Visible = false
debug_task.Active = false
debug_task.Complete = false
debug_task.CorrectState = "None"
debug_task_lose_antidote = Wherigo.ZTask(prometheus_chapter_2)
debug_task_lose_antidote.Id = "f0be0a6f-32ff-4d18-b29d-f3f0fe968777"
debug_task_lose_antidote.Name = _u1Y0J("\010\048\084\058\026\099\036\090\050\085\099\024\066\050\048\099\090\109\036\126\010\066\036\048")
debug_task_lose_antidote.Description = ""
debug_task_lose_antidote.Visible = false
debug_task_lose_antidote.Active = false
debug_task_lose_antidote.Complete = false
debug_task_lose_antidote.CorrectState = "None"
task_13_find_fiona = Wherigo.ZTask(prometheus_chapter_2)
task_13_find_fiona.Id = "d9bfe7dc-2d50-4f30-8e09-a0db46c379e4"
task_13_find_fiona.Name = _u1Y0J("\036\090\050\085\099\110\046\099\101\126\109\010\099\101\126\066\109\090")
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
_687 = _u1Y0J("\106\066\109\048\099\072\011\099\108\048\048\036\099\026\080\048\048\109\032\126\036\124\071")
_QZHnl = _u1Y0J("\124\071\090\080\090\124\036\048\080\099\101\126\066\109\090\099\026\080\048\048\109\032\126\036\124\071")
_UwA0V = _u1Y0J("\126\036\048\108\099\110\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\090\084\010\058\124\036\048\010\099\010\090\058\026\071\036\048\080")
_uC1 = _u1Y0J("\036\090\050\085\099\072\035\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071")
_DbwR = _u1Y0J("\126\109\074\058\036\099\072\054")
_RVS2 = _u1Y0J("\036\126\108\048\080\099\072\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109")
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
	_687 = _u1Y0J("\106\066\109\048\099\072\011\099\108\048\048\036\099\026\080\048\048\109\032\126\036\124\071"), 
	_QZHnl = _u1Y0J("\124\071\090\080\090\124\036\048\080\099\101\126\066\109\090\099\026\080\048\048\109\032\126\036\124\071"), 
	_UwA0V = _u1Y0J("\126\036\048\108\099\110\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\090\084\010\058\124\036\048\010\099\010\090\058\026\071\036\048\080"), 
	_uC1 = _u1Y0J("\036\090\050\085\099\072\035\099\124\090\024\024\099\036\066\099\026\080\048\048\109\032\126\036\124\071"), 
	_DbwR = _u1Y0J("\126\109\074\058\036\099\072\054"), 
	_RVS2 = _u1Y0J("\036\126\108\048\080\099\072\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109")
}

-- Timers --
timer_02_call_from_johnson = Wherigo.ZTimer(prometheus_chapter_2)
timer_02_call_from_johnson.Id = "7dd5396f-bcfb-4084-bf8c-a04830efde7a"
timer_02_call_from_johnson.Name = _u1Y0J("\036\126\108\048\080\099\072\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109")
timer_02_call_from_johnson.Description = _u1Y0J("\115\071\066\032\050\008\036\048\102\036\099\072\059\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\110\099\110")
timer_02_call_from_johnson.Visible = true
timer_02_call_from_johnson.Duration = 3
timer_02_call_from_johnson.Type = "Countdown"
timer_10_shake_off_pursuers = Wherigo.ZTimer(prometheus_chapter_2)
timer_10_shake_off_pursuers.Id = "3391adcc-2144-48aa-b2be-5e3207c1f764"
timer_10_shake_off_pursuers.Name = _u1Y0J("\036\126\108\048\080\099\110\072\099\050\071\090\085\048\099\066\101\101\099\074\058\080\050\058\048\080\050")
timer_10_shake_off_pursuers.Description = _u1Y0J("\103\024\090\124\048\050\008\106\066\109\048\099\110\072\099\050\071\090\085\048\099\066\101\101\099\074\058\080\050\058\048\080\050\069\064\113\075\090\080\066\058\109\010\008\036\071\048\008\074\024\090\006\048\080\022\050\008\074\066\050\126\036\126\066\109\008\090\109\010\008\090\124\036\126\056\090\036\048\050\069\064\113\075\036\071\090\036\008\106\066\109\048\017")
timer_10_shake_off_pursuers.Visible = true
timer_10_shake_off_pursuers.Duration = 2
timer_10_shake_off_pursuers.Type = "Countdown"
timer_11_call_from_greenwitch = Wherigo.ZTimer(prometheus_chapter_2)
timer_11_call_from_greenwitch.Id = "6c6ed906-9f10-4186-8ecf-059aa4351655"
timer_11_call_from_greenwitch.Name = _u1Y0J("\036\126\108\048\080\099\110\110\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071")
timer_11_call_from_greenwitch.Description = _u1Y0J("\115\071\066\032\050\069\064\113\075\036\048\102\036\099\110\110\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071\099\090\084\010\058\124\036\126\066\109\069\064\113\075\066\080\069\064\113\075\036\048\102\036\099\110\110\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071")
timer_11_call_from_greenwitch.Visible = true
timer_11_call_from_greenwitch.Duration = 2
timer_11_call_from_greenwitch.Type = "Countdown"
timer_10_call_from_greenwitch_followed = Wherigo.ZTimer(prometheus_chapter_2)
timer_10_call_from_greenwitch_followed.Id = "63155eed-de4c-4ed6-bfe3-3b6de72a6042"
timer_10_call_from_greenwitch_followed.Name = _u1Y0J("\036\126\108\048\080\099\110\072\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071\099\101\066\024\024\066\032\048\010")
timer_10_call_from_greenwitch_followed.Description = _u1Y0J("\115\071\066\032\050\008\036\126\108\048\080\099\110\072\099\124\090\024\024\099\101\080\066\108\099\026\080\048\048\109\032\126\036\124\071\099\101\066\024\024\066\032\048\010")
timer_10_call_from_greenwitch_followed.Visible = true
timer_10_call_from_greenwitch_followed.Duration = 2
timer_10_call_from_greenwitch_followed.Type = "Countdown"
timer_14_call_from_johnson_right_zone = Wherigo.ZTimer(prometheus_chapter_2)
timer_14_call_from_johnson_right_zone.Id = "4cc9181c-b8cd-4f42-8b1e-04d6018b0168"
timer_14_call_from_johnson_right_zone.Name = _u1Y0J("\036\126\108\048\080\099\110\098\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\080\126\026\071\036\099\106\066\109\048")
timer_14_call_from_johnson_right_zone.Description = _u1Y0J("\115\071\066\032\050\008\036\048\102\036\099\110\098\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\080\126\026\071\036\099\106\066\109\048")
timer_14_call_from_johnson_right_zone.Visible = true
timer_14_call_from_johnson_right_zone.Duration = 2
timer_14_call_from_johnson_right_zone.Type = "Countdown"
timer_16_track_fiona = Wherigo.ZTimer(prometheus_chapter_2)
timer_16_track_fiona.Id = "59d15367-dad5-4b01-a9e0-8c91a6984922"
timer_16_track_fiona.Name = _u1Y0J("\036\126\108\048\080\099\110\104\099\036\080\090\124\085\099\101\126\066\109\090")
timer_16_track_fiona.Description = _u1Y0J("\031\036\048\080\090\036\048\050\008\066\056\048\080\008\074\066\126\109\036\050\099\110\104\099\036\080\090\124\085\099\101\126\066\109\090\045\008\036\071\058\050\008\108\066\056\126\109\026\069\064\113\075\106\066\109\048\099\110\104\099\101\126\066\109\090\017\008\016\071\048\109\008\063\126\066\109\090\008\080\048\090\124\071\048\050\008\071\048\080\008\010\048\050\036\126\109\090\036\126\066\109\045\069\064\113\075\065\066\071\109\050\066\109\008\124\090\024\024\050\008\090\026\090\126\109\069\064\113\075\093\036\048\102\036\099\110\035\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\050\036\090\006\044\017")
timer_16_track_fiona.Visible = true
timer_16_track_fiona.Duration = 1
timer_16_track_fiona.Type = "Countdown"
timer_17_call_from_johnson_stay = Wherigo.ZTimer(prometheus_chapter_2)
timer_17_call_from_johnson_stay.Id = "085e152e-6b9f-49c9-b84f-99e63f9b389d"
timer_17_call_from_johnson_stay.Name = _u1Y0J("\036\126\108\048\080\099\110\035\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\050\036\090\006")
timer_17_call_from_johnson_stay.Description = _u1Y0J("\115\071\066\032\050\008\036\048\102\036\099\110\035\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\050\036\090\006")
timer_17_call_from_johnson_stay.Visible = true
timer_17_call_from_johnson_stay.Duration = 3
timer_17_call_from_johnson_stay.Type = "Countdown"
timer_18_greenwitch_meets_daughter = Wherigo.ZTimer(prometheus_chapter_2)
timer_18_greenwitch_meets_daughter.Id = "44cf631c-1a47-421b-941b-23cf055772d9"
timer_18_greenwitch_meets_daughter.Name = _u1Y0J("\036\126\108\048\080\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080")
timer_18_greenwitch_meets_daughter.Description = _u1Y0J("\031\036\048\080\090\036\048\050\008\066\056\048\080\069\064\113\075\036\126\108\048\066\058\036\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\069\064\113\075\090\109\010\069\064\113\075\036\048\102\036\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\045\069\064\113\075\036\071\058\050\008\124\066\109\010\058\124\036\126\109\026\008\036\071\048\008\010\126\090\024\066\026\008\084\048\036\032\048\048\109\069\064\113\075\065\066\071\109\008\018\080\048\048\109\032\126\036\124\071\008\090\109\010\008\071\126\050\008\010\090\058\026\071\036\048\080\017\008\016\071\126\024\048\069\064\113\075\036\048\102\036\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\069\064\113\075\071\066\024\010\050\008\036\071\048\008\036\048\102\036\008\101\066\080\008\036\071\048\008\010\126\090\024\066\026\045\069\064\113\075\036\126\108\048\066\058\036\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080\069\064\113\075\071\066\024\010\050\008\036\071\048\008\036\126\108\048\008\126\109\008\050\048\124\066\109\010\050\008\101\066\080\008\048\090\124\071\008\036\048\102\036\017\069\064\113\075\069\064\113\075\031\101\008\036\071\048\008\074\024\090\006\048\080\008\010\126\010\008\109\066\036\008\032\090\080\109\008\018\080\048\048\109\032\126\036\124\071\008\032\071\126\024\048\069\064\113\075\071\048\008\032\090\050\008\036\090\024\085\126\109\026\008\036\066\008\071\126\050\008\010\090\058\026\071\036\048\080\045\069\064\113\075\036\090\050\085\099\110\011\099\032\090\080\109\099\026\080\048\048\109\032\126\036\124\071\099\066\080\099\032\090\126\036\069\064\113\075\032\126\024\024\008\084\048\008\124\066\108\074\024\048\036\048\010\008\032\126\036\071\069\064\113\075\084\066\066\024\099\110\011\099\032\090\080\109\048\010\099\026\080\048\048\109\032\126\036\124\071\008\084\048\126\109\026\008\101\090\024\050\048\045\069\064\113\075\032\071\126\124\071\008\024\048\090\010\050\008\036\066\008\036\071\048\008\036\080\090\126\036\066\080\050\022\008\048\109\010\008\066\101\008\036\071\126\050\008\026\090\108\048\017")
timer_18_greenwitch_meets_daughter.Visible = true
timer_18_greenwitch_meets_daughter.Duration = 11
timer_18_greenwitch_meets_daughter.Type = "Countdown"
timer_21a_call_from_johnson_gratitude_traitors_end = Wherigo.ZTimer(prometheus_chapter_2)
timer_21a_call_from_johnson_gratitude_traitors_end.Id = "c89870ed-5d29-4455-afc9-7ac565010852"
timer_21a_call_from_johnson_gratitude_traitors_end.Name = _u1Y0J("\036\126\108\048\080\099\059\110\090\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\026\080\090\036\126\036\058\010\048\099\036\080\090\126\036\066\080\050\099\048\109\010")
timer_21a_call_from_johnson_gratitude_traitors_end.Description = _u1Y0J("\038\080\017\008\065\066\071\109\050\066\109\008\048\102\074\080\048\050\050\048\050\008\071\126\050\008\026\080\090\036\126\036\058\010\048\008\036\066\008\036\071\048\069\064\113\075\074\024\090\006\048\080\008\101\066\080\008\050\048\024\024\126\109\026\008\066\058\036\008\065\066\071\109\008\018\080\048\048\109\032\126\036\124\071\017\069\064\113\075\123\113\111\031\123\002\113\115\022\008\037\040\029")
timer_21a_call_from_johnson_gratitude_traitors_end.Visible = true
timer_21a_call_from_johnson_gratitude_traitors_end.Duration = 3
timer_21a_call_from_johnson_gratitude_traitors_end.Type = "Countdown"
timer_21b_call_from_johnson_threat = Wherigo.ZTimer(prometheus_chapter_2)
timer_21b_call_from_johnson_threat.Id = "fb9ed94f-ffc4-4f15-a06b-8c903cee3a39"
timer_21b_call_from_johnson_threat.Name = _u1Y0J("\036\126\108\048\080\099\059\110\084\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\036\071\080\048\090\036")
timer_21b_call_from_johnson_threat.Description = _u1Y0J("\115\071\066\032\050\008\036\048\102\036\099\059\110\084\099\124\090\024\024\099\101\080\066\108\099\019\066\071\109\050\066\109\099\036\071\080\048\090\036")
timer_21b_call_from_johnson_threat.Visible = true
timer_21b_call_from_johnson_threat.Duration = 3
timer_21b_call_from_johnson_threat.Type = "Countdown"
timer_22_helicopter = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_helicopter.Id = "db18639c-5968-45e9-9b51-b77ed74c6d05"
timer_22_helicopter.Name = _u1Y0J("\036\126\108\048\080\099\059\059\099\071\048\024\126\124\066\074\036\048\080")
timer_22_helicopter.Description = _u1Y0J("\115\126\108\058\024\090\036\048\050\008\090\109\008\126\109\124\066\108\126\109\026\008\071\048\024\126\124\066\074\036\048\080\017")
timer_22_helicopter.Visible = true
timer_22_helicopter.Duration = 1
timer_22_helicopter.Type = "Countdown"
timer_22_helicopter_seeking = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_helicopter_seeking.Id = "9e385f27-e22c-4a98-979a-5a8fcf4dfcb2"
timer_22_helicopter_seeking.Name = _u1Y0J("\036\126\108\048\080\099\059\059\099\071\048\024\126\124\066\074\036\048\080\099\050\048\048\085\126\109\026")
timer_22_helicopter_seeking.Description = _u1Y0J("\123\071\048\008\074\024\090\006\048\080\008\126\050\008\126\109\008\050\126\026\071\036\008\066\101\008\036\071\048\008\071\048\024\126\124\066\074\036\048\080\008\090\109\010\008\071\090\050\069\064\113\075\036\066\008\026\048\036\008\090\032\090\006\008\126\108\108\048\010\126\090\036\048\024\006\045\008\066\036\071\048\080\032\126\050\048\008\036\071\048\008\090\109\036\126\010\066\036\048\069\064\113\075\126\050\008\024\066\050\036\017\008\123\071\126\050\008\036\126\108\048\080\008\032\126\024\024\008\084\048\008\050\036\090\080\036\048\010\008\032\071\048\109\008\036\071\048\008\074\024\090\006\048\080\069\064\113\075\048\109\036\048\080\050\008\106\066\109\048\099\059\059\099\071\048\024\126\124\066\074\036\048\080\008\090\109\010\008\050\036\066\074\074\048\010\008\032\071\048\109\008\036\071\048\069\064\113\075\074\024\090\006\048\080\008\048\102\126\036\050\008\036\071\090\036\008\106\066\109\048\017")
timer_22_helicopter_seeking.Visible = true
timer_22_helicopter_seeking.Duration = 58
timer_22_helicopter_seeking.Type = "Countdown"
timer_22_agents = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_agents.Id = "59e69402-8fc8-41ed-b048-4138989bed59"
timer_22_agents.Name = _u1Y0J("\036\126\108\048\080\099\059\059\099\090\026\048\109\036\050")
timer_22_agents.Description = _u1Y0J("\031\036\048\080\090\036\048\050\008\066\056\048\080\069\064\113\075\074\066\126\109\036\050\099\059\059\099\090\026\048\109\036\099\110\008\090\109\010\008\074\066\126\109\036\050\099\059\059\099\090\026\048\109\036\099\059\045\069\064\113\075\036\071\058\050\008\108\066\056\126\109\026\069\064\113\075\106\066\109\048\099\059\059\099\090\026\048\109\036\099\110\008\090\109\010\008\106\066\109\048\099\059\059\099\090\026\048\109\036\099\059\017\069\064\113\075\123\071\048\050\048\008\106\066\109\048\050\008\080\048\074\080\048\050\048\109\036\008\036\032\066\008\090\026\048\109\036\050\008\074\090\036\080\066\024\024\126\109\026\008\036\071\048\069\064\113\075\090\080\048\090\017\008\123\071\048\008\074\024\090\006\048\080\008\024\066\050\048\050\008\036\071\048\008\090\109\036\126\010\066\036\048\008\066\109\008\048\109\036\048\080\126\109\026\069\064\113\075\066\109\048\008\066\101\008\036\071\048\050\048\008\106\066\109\048\050\017")
timer_22_agents.Visible = true
timer_22_agents.Duration = 1
timer_22_agents.Type = "Countdown"
timer_22_helicopter_idle = Wherigo.ZTimer(prometheus_chapter_2)
timer_22_helicopter_idle.Id = "abdfee2e-fd27-4d05-93c6-2d74ba21b0a6"
timer_22_helicopter_idle.Name = _u1Y0J("\036\126\108\048\080\099\059\059\099\071\048\024\126\124\066\074\036\048\080\099\126\010\024\048")
timer_22_helicopter_idle.Description = _u1Y0J("\123\071\048\008\074\024\090\006\048\080\008\024\048\101\036\008\106\066\109\048\099\059\059\099\071\048\024\126\124\066\074\036\048\080\017\008\123\071\048\008\071\048\109\124\071\108\048\109\008\126\109\008\036\071\048\008\071\048\024\126\124\066\074\036\048\080\008\050\036\126\024\024\008\050\048\090\080\124\071\008\101\066\080\008\050\066\108\048\008\036\126\108\048\008\058\109\036\126\024\008\036\071\048\006\008\026\066\008\066\109\017")
timer_22_helicopter_idle.Visible = true
timer_22_helicopter_idle.Duration = 53
timer_22_helicopter_idle.Type = "Countdown"

-- Inputs --
input_08 = Wherigo.ZInput(prometheus_chapter_2)
input_08.Id = "f2c8922f-82de-4c60-a446-2c58e9699a13"
input_08.Name = _u1Y0J("\126\109\074\058\036\099\072\054")
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
input_01_previously.Id = "139b368e-dec5-4409-92f8-416d0bd76876"
input_01_previously.Name = _u1Y0J("\126\109\074\058\036\099\072\110\099\074\080\048\056\126\066\058\050\024\006")
input_01_previously.Description = ""
input_01_previously.Visible = true
input_01_previously.Choices = {}
input_01_previously.InputType = "MultipleChoice"
input_01_previously.Text = ""
input_13_fionas_whereabouts = Wherigo.ZInput(prometheus_chapter_2)
input_13_fionas_whereabouts.Id = "3a5c9a03-0f52-4878-83fa-3b37bb3d2812"
input_13_fionas_whereabouts.Name = _u1Y0J("\126\109\074\058\036\099\110\046\099\101\126\066\109\090\050\099\032\071\048\080\048\090\084\066\058\036\050")
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
	item_03_health_office_answering_machine.Name = item_03_health_office_answering_machine_name
	item_03_health_office_answering_machine.Description = item_03_health_office_answering_machine_description
	item_03_health_office_answering_machine.Commands.command_call.Text = item_03_health_office_answering_machine_command_call_caption
	
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
	_687 = _u1Y0J("\106\066\109\048\099\072\011\099\108\048\048\036\099\026\080\048\048\109\032\126\036\124\071")
	timer_10_call_from_greenwitch_followed:Start()
end
function zone_11_meet_greenwitch:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\110\110\099\108\048\048\036\099\026\080\048\048\109\032\126\036\124\071")
	if bool_10_pursuers_shaken_off == true then
		zone_11_meet_greenwitch.Active = false
		timer_11_call_from_greenwitch:Start()
	else
		dialog(text_10_shake_off_pursuers_first)
		
	end
end
function zone_23_hospital:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\046\099\071\066\050\074\126\036\090\024")
	bool_22_henchmen_active = false
	stop_22_helicopter()
	stop_22_agents()
	stop_22_road_blocks()
	if Player:Contains(item_20_antidote) then
		item_20_antidote:MoveTo(character_medical_doctor)
		Wherigo.PlayAudio(audio_23c_reaching_hospital_heroes_end)
		dialog(text_23c_reaching_hospital_heroes_end, img_doctor_who, text_ok, function()
			save_game(text_event_23c_reaching_hospital_heroes_end)
			show_23c_heroes_end()
		end)
		
	else
		Wherigo.PlayAudio(audio_24d_reaching_hospital_mourners_end)
		dialog(text_24d_reaching_hospital_mourners_end, img_doctor_who, text_ok, function()
			save_game(text_event_24d_mourners_end)
			show_24d_mourners_end()
		end)
		
	end
	task_20b_bring_antidote_to_hospital.Complete = true
	zone_23_hospital.Active = false
	zone_23_hospital.Visible = false
end
function zone_10_shake_off_pursuers:OnExit()
	_687 = _u1Y0J("\106\066\109\048\099\110\072\099\050\071\090\085\048\099\066\101\101\099\074\058\080\050\058\048\080\050")
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
	_687 = _u1Y0J("\106\066\109\048\099\110\104\099\101\126\066\109\090")
	timer_16_track_fiona:Stop()
	dialog(text_16_track_fiona, img_16_track_fiona)
	
end
function zone_16_fiona:OnExit()
	_687 = _u1Y0J("\106\066\109\048\099\110\104\099\101\126\066\109\090")
	timer_16_track_fiona:Start()
end
function zone_18_greenwitch_meets_daughter:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080")
	bool_19_can_warn_greenwitch = true
end
function zone_18_greenwitch_meets_daughter:OnExit()
	_687 = _u1Y0J("\106\066\109\048\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080")
	bool_19_can_warn_greenwitch = false
end
function zone_18_greenwitch_meets_daughter:OnProximity()
	_687 = _u1Y0J("\106\066\109\048\099\110\054\099\026\080\048\048\109\032\126\036\124\071\099\108\048\048\036\050\099\010\090\058\026\071\036\048\080")
	if bool_17_call_from_johnson_stay == false then
		bool_17_call_from_johnson_stay = true
		timer_17_call_from_johnson_stay:Start()
	end
end
function zone_21a_traitors_end:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\110\090\099\036\080\090\126\036\066\080\050\099\048\109\010")
	finish_game()
end
function zone_23c_heroes_end:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\046\124\099\071\048\080\066\048\050\099\048\109\010")
	finish_game()
end
function zone_24d_mourners_end:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\098\010\099\108\066\058\080\109\048\080\050\099\048\109\010")
	finish_game()
end
function zone_22_helicopter:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\071\048\024\126\124\066\074\036\048\080")
	timer_22_helicopter_seeking:Start()
	Wherigo.PlayAudio(sound_helicopter)
end
function zone_22_helicopter:OnExit()
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\071\048\024\126\124\066\074\036\048\080")
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
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\080\066\090\010\099\084\024\066\124\085\099\110")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_agent_1:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\090\026\048\109\036\099\110")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_agent_2:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\090\026\048\109\036\099\059")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_agent_3:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\090\026\048\109\036\099\046")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_road_block_2:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\080\066\090\010\099\084\024\066\124\085\099\059")
	show_23d_lose_antidote_to_johnson()
end
function zone_22_road_block_3:OnEnter()
	_687 = _u1Y0J("\106\066\109\048\099\059\059\099\080\066\090\010\099\084\024\066\124\085\099\046")
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
	save_game(text_event_04_call_from_johnson)
	
	question(string.format([[%s
	1:
	%s
	2:
	%s]], text_04_call_from_johnson_1_2, text_06a_call_from_johnson_daughter_abducted[1], text_05b_call_from_johnson), nil, "1", "2", function()
		show_06a_call_from_johnson_daughter_abducted()
	end, function()
		task_04_call_from_johnson_1_2.Complete = true
	end)
	
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
		save_game(text_event_08_call_to_greenwitch_a_honest)
		
		Wherigo.PlayAudio(audio_08_call_to_greenwitch_a_honest)
		dialog(text_08_call_to_greenwitch_a_honest[2], nil, text_ok, function()
			task_07_call_to_greenwitch.Complete = true
		end)
		
	elseif _Urwigo.Hash(string.lower(input)) == 50 then
		save_game(text_event_08_call_to_greenwitch_b_hide)
		
		Wherigo.PlayAudio(audio_08_call_to_greenwitch_b_hide)
		dialog(text_08_call_to_greenwitch_b_hide[2], nil, text_ok, function()
			task_07_call_to_greenwitch.Complete = true
		end)
		
	elseif _Urwigo.Hash(string.lower(input)) == 51 then
		save_game(text_event_08_call_to_greenwitch_c_a06)
		
		Wherigo.PlayAudio(audio_08_call_to_greenwitch_c_a06)
		dialog(text_08_call_to_greenwitch_c_a06[2], nil, text_ok, function()
			task_07_call_to_greenwitch.Complete = true
			bool_08_told_greenwitch_about_abduction = true
		end)
		
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
		save_game(text_event_21a_call_from_johnson_gratitude_traitors_end)
		show_21a_traitors_end()
	end, text_ignore_call, function()
		timer_21a_call_from_johnson_gratitude_traitors_end:Start()
	end)
	
end
function timer_21b_call_from_johnson_threat:OnTick()
	incoming_phone_call(text_incoming_call_johnson, audio_21b_call_from_johnson_threat, text_21b_call_from_johnson_threat, img_mr_johnson, function()
		save_game(text_event_21b_call_from_johnson_threat)
		show_20b_bring_antidote_to_hospital()
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
function item_03_health_office_answering_machine:Oncommand_call(target)
	show_03_health_office_answering_machine()
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
	dialog(text_03_news, img_03_news, text_ok, function()
		--        item_03_health_office_answering_machine.Visible = true
		if not task_04_call_from_johnson_1_2.Complete then
			task_04_call_from_johnson_1_2.Active = true
		end
	end)
	
end
function show_03_health_office_answering_machine()
	Wherigo.PlayAudio(audio_03_health_office_answering_machine)
	dialog(text_03_health_office_answering_machine)
	
end
function show_06a_call_from_johnson_daughter_abducted()
	bool_06a_call_from_johnson_daughter_abducted = true
	Wherigo.PlayAudio(audio_06a_call_from_johnson_daughter_abducted)
	dialog(text_06a_call_from_johnson_daughter_abducted[2], nil, text_ok, function()
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
	dialog(text_15_call_from_johnson_radio_tag, nil, text_ok, function()
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
		save_game(string.format([[%s
		%s :
		%s]], text_event_completed_game, text_event_completion_code, string.sub(Player.CompletionCode, 1, 15)))
		
		item_completion_code.Visible = true
		item_credits.Visible = true
		show_credits()
	end
end
function show_credits()
	dialog(item_credits_text)
	
end

-- Begin user functions --
-- End user functions --
return prometheus_chapter_2
