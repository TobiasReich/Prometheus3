require "Wherigo"
ZonePoint = Wherigo.ZonePoint
Distance = Wherigo.Distance
Player = Wherigo.Player

-- String decode --
function _AHU(str)
	local res = ""
    local dtable = "\064\105\092\044\057\077\100\088\097\033\008\050\061\036\020\066\103\053\051\095\006\122\047\037\065\001\082\045\078\104\063\075\110\029\089\058\121\079\108\012\106\048\115\010\099\125\116\098\083\094\107\060\126\003\067\074\081\042\119\039\093\072\080\013\030\041\111\118\025\049\031\113\005\056\000\076\038\070\071\028\052\124\032\062\009\123\026\109\073\117\002\017\087\043\035\040\096\019\120\027\015\054\059\102\114\021\091\055\101\085\007\004\014\046\034\090\011\069\084\112\086\068\024\016\023\018\022"
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
_Urwigo.InlineModuleFunc = {}

_64T = Wherigo.ZCartridge()

-- Media --
_gUXD = Wherigo.ZMedia(_64T)
_gUXD.Id = "79b1858d-ff8f-456c-bcf3-f1f4cd9c6d91"
_gUXD.Name = _AHU("\119\002\047\039\109")
_gUXD.Description = _AHU("\122\009\043\083\119\002\047\109\039\048\002\039\007\083\090\033\007\083\089\045\067\033\083\007\109\105\083\055\009\105\047\105\002\007\017\109")
_gUXD.AltText = ""
_gUXD.Resources = {
	{
		Type = "jpg", 
		Filename = "Title_small.jpg", 
		Directives = {}
	}
}
_3do = Wherigo.ZMedia(_64T)
_3do.Id = "566592ac-01c3-4a76-9bb5-49b11478841d"
_3do.Name = _AHU("\121\002\105\090\043")
_3do.Description = _AHU("\118\002\033\083\016\002\067\062\009\022\009\105\007\083\022\109\002\045\030\109\033")
_3do.AltText = ""
_3do.Resources = {
	{
		Type = "jpg", 
		Filename = "Bio-Hazard.jpg", 
		Directives = {}
	}
}
_C0t = Wherigo.ZMedia(_64T)
_C0t.Id = "ece13782-03b0-403d-b1ee-28265379fd96"
_C0t.Name = _AHU("\079\109\017\109\033\088\002\047\047\109\039")
_C0t.Description = _AHU("\063\067\043\002\047\002\068\109\043\083\121\002\105\090\043\083\116\109\090\017\043")
_C0t.AltText = ""
_C0t.Resources = {
	{
		Type = "jpg", 
		Filename = "Gegenmittel.jpg", 
		Directives = {}
	}
}
_gk5B8 = Wherigo.ZMedia(_64T)
_gk5B8.Id = "8e9bf420-a337-424a-bf03-8d25a8207117"
_gk5B8.Name = _AHU("\016\009\030\033\030\067\104\083\089\045\067\033")
_gk5B8.Description = _AHU("\122\009\043\083\089\045\067\033\083\109\002\033\109\043\083\016\009\030\033\030\067\104\109\043\083\067\007\109\105\083\043\067")
_gk5B8.AltText = ""
_gk5B8.Resources = {
	{
		Type = "jpg", 
		Filename = "icon_train.jpg", 
		Directives = {}
	}
}
_yAc4 = Wherigo.ZMedia(_64T)
_yAc4.Id = "b980e282-986e-46a0-a179-ddf602fd74df"
_yAc4.Name = _AHU("\049\047\009\017\109\070\083\028\083\062\002\039\104\109\025\033\105\090\104")
_yAc4.Description = _AHU("\122\109\105\083\062\002\039\104\109\028\119\109\039\109\104\067\033\009\033\105\090\104\083\007\109\043\083\089\033\104\067\105\088\009\033\047\109\033")
_yAc4.AltText = _AHU("\089\045\030\083\048\105\009\090\045\030\109\083\089\030\105\109\083\062\002\039\104\109\114\083\079\109\030\109\033\083\049\002\109\083\022\090\083\007\109\033\083\032\067\067\105\007\002\033\009\047\109\033\083\090\033\007\083\048\109\043\067\105\017\109\033\083\049\002\109\083\007\002\109\083\110\033\047\109\105\039\009\017\109\033\010")
_yAc4.Resources = {
	{
		Type = "mp3", 
		Filename = "Text1-Hilfegesuch.mp3", 
		Directives = {}
	}
}
_Xas4 = Wherigo.ZMedia(_64T)
_Xas4.Id = "76f7beac-29af-4145-b27b-1d8b382917e4"
_Xas4.Name = _AHU("\089\033\104\067\105\088\009\033\047\016\002\039\007")
_Xas4.Description = _AHU("\122\009\043\083\016\002\039\007\083\007\109\043\083\078\067\105\043\045\030\109\105\043")
_Xas4.AltText = ""
_Xas4.Resources = {
	{
		Type = "jpg", 
		Filename = "Informant.jpg", 
		Directives = {}
	}
}
_kqG7 = Wherigo.ZMedia(_64T)
_kqG7.Id = "04e2879e-1ad6-4b7b-b56d-48418174fe37"
_kqG7.Name = _AHU("\089\033\104\067\105\088\009\033\047\083\089\045\067\033")
_kqG7.Description = _AHU("\089\045\067\033\083\007\109\043\083\089\033\104\067\105\088\009\033\047\109\033")
_kqG7.AltText = ""
_kqG7.Resources = {
	{
		Type = "jpg", 
		Filename = "Informant_icon.jpg", 
		Directives = {}
	}
}
_f5Fh = Wherigo.ZMedia(_64T)
_f5Fh.Id = "258adaea-9be0-467e-b3a8-3afcfb9868f5"
_f5Fh.Name = _AHU("\089\033\045\067\088\002\033\017\055\009\039\039\089\045\067\033")
_f5Fh.Description = _AHU("\118\002\033\083\090\033\048\109\051\009\033\033\047\109\105\083\025\033\105\090\104\109\105\083\105\090\104\047\083\009\033\083\028\083\002\045\067\033")
_f5Fh.AltText = ""
_f5Fh.Resources = {
	{
		Type = "jpg", 
		Filename = "Unbekannter-Anruf-icon.jpg", 
		Directives = {}
	}
}
_uQmi = Wherigo.ZMedia(_64T)
_uQmi.Id = "af79eb3d-81bd-4df6-a39a-008aeed4018c"
_uQmi.Name = _AHU("\109\033\045\105\037\120\047\109\007\083\122\009\047\009")
_uQmi.Description = _AHU("\121\109\105\043\045\030\039\031\043\043\109\039\047\109\083\122\009\047\109\033")
_uQmi.AltText = ""
_uQmi.Resources = {
	{
		Type = "jpg", 
		Filename = "Encrypted-Data_Icon.jpg", 
		Directives = {}
	}
}
_U2ru = Wherigo.ZMedia(_64T)
_U2ru.Id = "212476ab-2979-4ba6-b628-33b24870b807"
_U2ru.Name = _AHU("\118\033\045\105\037\120\047\109\007\122\009\047\009\089\045\067\033")
_U2ru.Description = _AHU("\122\009\043\083\049\037\088\048\067\039\083\104\031\105\083\068\109\105\043\045\030\039\031\043\043\109\039\047\109\083\122\009\047\109\033")
_U2ru.AltText = ""
_U2ru.Resources = {
	{
		Type = "jpg", 
		Filename = "Encrypted-Data_Icon1.jpg", 
		Directives = {}
	}
}
_250p = Wherigo.ZMedia(_64T)
_250p.Id = "cfaaedfe-6a1d-460b-9eb1-7f1f78bb83de"
_250p.Name = _AHU("\119\109\099\047\012\028\122\009\047\109\033\079\109\104\090\033\007\109\033\078\105\009\017\109")
_250p.Description = _AHU("\078\105\009\017\109\004\083\067\048\083\007\109\105\083\029\090\047\022\109\105\083\007\002\109\083\122\009\047\109\033\083\017\109\104\090\033\007\109\033\083\030\009\047")
_250p.AltText = ""
_250p.Resources = {
	{
		Type = "mp3", 
		Filename = "Text2-HabenSiedieDaten.mp3", 
		Directives = {}
	}
}
_md3 = Wherigo.ZMedia(_64T)
_md3.Id = "a309b328-005d-4c2a-a4f7-0e6fb8a249f6"
_md3.Name = _AHU("\119\109\099\047\019\028\027\002\045\030\047\002\017\109\122\009\047\109\033\079\109\104\090\033\007\109\033")
_md3.Description = _AHU("\025\090\007\002\067\083\104\031\105\083\007\002\109\083\027\002\045\030\047\002\017\109\033\083\078\067\105\043\045\030\090\033\017\043\007\009\047\109\033")
_md3.AltText = ""
_md3.Resources = {
	{
		Type = "mp3", 
		Filename = "Text3-Datengefunden.mp3", 
		Directives = {}
	}
}
_RbK = Wherigo.ZMedia(_64T)
_RbK.Id = "80dec3e7-ebbe-47d0-a101-2807a20eb1f4"
_RbK.Name = _AHU("\119\109\099\047\081\028\078\009\039\043\045\030\109\122\009\047\109\033\079\109\104\090\033\007\109\033")
_RbK.Description = _AHU("\122\109\105\083\029\090\047\022\109\105\083\030\009\047\083\007\002\109\083\104\009\039\043\045\030\109\033\083\122\009\047\109\033\083\030\067\045\030\017\109\039\009\007\109\033")
_RbK.AltText = ""
_RbK.Resources = {
	{
		Type = "mp3", 
		Filename = "Text4-FalscheDatengefunden.mp3", 
		Directives = {}
	}
}
_Xjl = Wherigo.ZMedia(_64T)
_Xjl.Id = "3135161b-9aac-4515-8d88-c9c3fba32c93"
_Xjl.Name = _AHU("\063\030\067\033\109\027\002\033\017")
_Xjl.Description = _AHU("\122\009\043\083\032\039\002\033\017\109\039\033\083\007\109\043\083\119\109\039\109\104\067\033\043")
_Xjl.AltText = ""
_Xjl.Resources = {
	{
		Type = "wav", 
		Filename = "CellPhoneRing13.wav", 
		Directives = {}
	}
}
_xvaq = Wherigo.ZMedia(_64T)
_xvaq.Id = "e18c6d96-ecc0-41ad-b670-f2491362ab1e"
_xvaq.Name = _AHU("\119\109\099\047\018\083\028\083\006\105\056\067\030\033\043\067\033\025\033\105\090\104\070")
_xvaq.Description = _AHU("\122\109\105\083\109\105\043\047\109\083\025\033\105\090\104\083\068\067\033\083\006\105\114\083\056\067\030\033\043\067\033\083\096\031\048\109\105\022\109\090\017\047\083\007\109\033\083\055\030\009\105\009\051\047\109\105\083\089\033\104\067\105\088\009\033\047\109\033\083\009\090\043\022\090\039\002\109\104\109\105\033\066")
_xvaq.AltText = ""
_xvaq.Resources = {
	{
		Type = "mp3", 
		Filename = "Text5-MrJohnsonauftrag.mp3", 
		Directives = {}
	}
}
_tLtT = Wherigo.ZMedia(_64T)
_tLtT.Id = "dcf9e4b6-c7ec-464f-850f-0eca2780f787"
_tLtT.Name = _AHU("\121\002\105\090\043\063\109\047\105\002\043\045\030\009\039\109")
_tLtT.Description = ""
_tLtT.AltText = ""
_tLtT.Resources = {
	{
		Type = "jpg", 
		Filename = "Virus-Petrischale.jpg", 
		Directives = {}
	}
}
_5v2 = Wherigo.ZMedia(_64T)
_5v2.Id = "3c6839ec-1929-4fc0-b293-0d24393af003"
_5v2.Name = _AHU("\062\009\033\007\037\079\078\008")
_5v2.Description = ""
_5v2.AltText = ""
_5v2.Resources = {
	{
		Type = "jpg", 
		Filename = "TelefonItem.jpg", 
		Directives = {}
	}
}
_U9HLq = Wherigo.ZMedia(_64T)
_U9HLq.Id = "152b365f-ded4-48fe-b077-3229bda68b39"
_U9HLq.Name = _AHU("\119\109\099\047\102\083\028\083\025\033\105\090\104\083\104\031\105\083\079\109\017\109\033\088\002\047\047\109\039")
_U9HLq.Description = _AHU("\122\109\105\083\025\033\105\090\104\083\007\109\105\083\051\067\088\088\047\004\083\059\109\033\033\083\007\109\105\083\089\033\104\067\105\088\009\033\047\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\030\009\047")
_U9HLq.AltText = ""
_U9HLq.Resources = {
	{
		Type = "mp3", 
		Filename = "Text6-AnrufvonInformantmitGegenmittel.mp3", 
		Directives = {}
	}
}
_qMp = Wherigo.ZMedia(_64T)
_qMp.Id = "3fe3ff3b-e7ae-46eb-a3b3-10e6b92379b0"
_qMp.Name = _AHU("\119\109\099\047\108\028\006\105\008\089\043\047\022\090\104\105\002\109\007\109\033")
_qMp.Description = _AHU("\122\109\105\083\122\009\033\051\109\043\047\109\099\047\083\068\067\033\083\006\105\114\008")
_qMp.AltText = ""
_qMp.Resources = {
	{
		Type = "mp3", 
		Filename = "Text7-MrJohnsonzufrieden.mp3", 
		Directives = {}
	}
}
_csB = Wherigo.ZMedia(_64T)
_csB.Id = "9ce87b89-f31f-4232-afea-2a3ffcc05cd9"
_csB.Name = _AHU("\016\109\039\067\030\033\090\033\017")
_csB.Description = _AHU("\122\009\043\083\089\045\067\033\083\007\109\105\083\016\109\039\067\030\033\090\033\017")
_csB.AltText = ""
_csB.Resources = {
	{
		Type = "jpg", 
		Filename = "Schatzkiste.jpg", 
		Directives = {}
	}
}
_UGA = Wherigo.ZMedia(_64T)
_UGA.Id = "0b4732e0-44ed-43ed-b9e2-be73e49e29ad"
_UGA.Name = _AHU("\119\109\099\047\074\028\025\033\047\002\068\002\105\090\043\083\043\090\045\030\109\033")
_UGA.Description = _AHU("\025\033\059\109\002\043\090\033\017\004\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\022\090\083\043\090\045\030\109\033")
_UGA.AltText = ""
_UGA.Resources = {
	{
		Type = "mp3", 
		Filename = "Text8-Antivirussuchen.mp3", 
		Directives = {}
	}
}
_wrD7u = Wherigo.ZMedia(_64T)
_wrD7u.Id = "07240f63-5ba0-448f-a205-e4b6cf6a39d4"
_wrD7u.Name = _AHU("\119\109\099\047\005\028\025\033\047\002\068\002\105\090\043\083\017\109\104\090\033\007\109\033")
_wrD7u.Description = _AHU("\122\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\096\007\109\105\083\055\067\007\109\066\083\059\090\105\007\109\083\017\109\104\090\033\007\109\033")
_wrD7u.AltText = ""
_wrD7u.Resources = {
	{
		Type = "mp3", 
		Filename = "Text9-Antivirusgefunden.mp3", 
		Directives = {}
	}
}
_CKx = Wherigo.ZMedia(_64T)
_CKx.Id = "48f1306d-5466-42e6-ad7a-b0595d88f8be"
_CKx.Name = _AHU("\119\109\099\047\070\042\028\025\033\047\002\068\002\105\090\043\083\033\002\045\030\047\083\017\109\104\090\033\007\109\033")
_CKx.Description = _AHU("\078\009\039\043\045\030\109\083\025\033\047\059\067\105\047\083\048\109\002\083\118\002\033\017\009\048\109\083\007\109\043\083\055\067\007\109\043")
_CKx.AltText = ""
_CKx.Resources = {
	{
		Type = "mp3", 
		Filename = "Text10-Antivirusnichtgefunden.mp3", 
		Directives = {}
	}
}
_M_jHw = Wherigo.ZMedia(_64T)
_M_jHw.Id = "039d49d5-2d7d-47e6-b385-fd16f1bd09ac"
_M_jHw.Name = _AHU("\119\109\099\047\070\070\028\121\002\105\090\043\022\067\033\109\016\109\047\105\109\047\109\033")
_M_jHw.Description = _AHU("\016\109\047\105\109\047\109\033\083\007\109\105\083\078\002\033\009\039\083\116\067\033\109")
_M_jHw.AltText = ""
_M_jHw.Resources = {
	{
		Type = "mp3", 
		Filename = "Text11-VirusTimerStartet2.mp3", 
		Directives = {}
	}
}
_rMOm5 = Wherigo.ZMedia(_64T)
_rMOm5.Id = "16188100-cf00-40fc-90b5-68a12c2a372a"
_rMOm5.Name = _AHU("\119\109\099\047\070\012\028\121\002\105\090\043\116\067\033\109\062\002\033\047")
_rMOm5.Description = _AHU("\062\002\033\047\083\104\031\105\083\055\009\045\030\109\083\002\033\083\007\109\105\083\078\002\033\009\039\083\116\067\033\109")
_rMOm5.AltText = ""
_rMOm5.Resources = {
	{
		Type = "mp3", 
		Filename = "Text12-VirusTimerHint.mp3", 
		Directives = {}
	}
}
_mWf0o = Wherigo.ZMedia(_64T)
_mWf0o.Id = "b9eacdda-adee-44af-8d7b-e4bbb2204c5e"
_mWf0o.Name = _AHU("\119\109\099\047\070\019\028\121\002\105\090\043\025\090\043\017\109\048\105\067\045\030\109\033")
_mWf0o.Description = _AHU("\121\002\105\090\043\083\002\043\047\083\009\090\043\017\109\048\105\067\045\030\109\033")
_mWf0o.AltText = ""
_mWf0o.Resources = {
	{
		Type = "mp3", 
		Filename = "Text13-VirusAusgebrochen.mp3", 
		Directives = {}
	}
}
_4rK = Wherigo.ZMedia(_64T)
_4rK.Id = "ef7399c8-cb31-4ab3-9b10-8aa4b6286fe9"
_4rK.Name = _AHU("\119\109\099\047\070\081\028\121\002\105\090\043\121\109\105\033\002\045\030\047\109\047")
_4rK.Description = _AHU("\122\009\043\083\121\002\105\090\043\083\059\090\105\007\109\083\068\109\105\033\002\045\030\047\109\047")
_4rK.AltText = ""
_4rK.Resources = {
	{
		Type = "mp3", 
		Filename = "Text14-VirusNeutralisiert.mp3", 
		Directives = {}
	}
}
_Y60 = Wherigo.ZMedia(_64T)
_Y60.Id = "c039b721-911e-4672-b218-6e657cfcf15d"
_Y60.Name = _AHU("\122\009\047\009")
_Y60.Description = ""
_Y60.AltText = ""
_Y60.Resources = {
	{
		Type = "jpg", 
		Filename = "encrypted-data.jpg", 
		Directives = {}
	}
}
_CZOB = Wherigo.ZMedia(_64T)
_CZOB.Id = "7428f711-257d-4889-b306-349888bf8f4d"
_CZOB.Name = _AHU("\056\067\030\033\043\067\033\012")
_CZOB.Description = ""
_CZOB.AltText = ""
_CZOB.Resources = {
	{
		Type = "jpg", 
		Filename = "JohnsonBogard.jpg", 
		Directives = {}
	}
}
_Q7u = Wherigo.ZMedia(_64T)
_Q7u.Id = "7d0b0e68-d731-4e86-8ac4-8c1b1194df71"
_Q7u.Name = _AHU("\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030")
_Q7u.Description = ""
_Q7u.AltText = ""
_Q7u.Resources = {
	{
		Type = "jpg", 
		Filename = "John-Greenwitch.jpg", 
		Directives = {}
	}
}
_p4F = Wherigo.ZMedia(_64T)
_p4F.Id = "94e15cb9-a074-45ec-b1c1-90da285d4881"
_p4F.Name = _AHU("\063\105\067\088\109\047\030\109\090\043\076\067\017\067")
_p4F.Description = ""
_p4F.AltText = ""
_p4F.Resources = {
	{
		Type = "jpg", 
		Filename = "Prometheus-Pharmaceutics-CorpLogo.jpg", 
		Directives = {}
	}
}
_Qch4n = Wherigo.ZMedia(_64T)
_Qch4n.Id = "71d5901f-0abc-4453-addc-8444b987d563"
_Qch4n.Name = _AHU("\029\067\047\002\022\048\039\067\045\051")
_Qch4n.Description = ""
_Qch4n.AltText = ""
_Qch4n.Resources = {
	{
		Type = "jpg", 
		Filename = "NotizblockIcon.jpg", 
		Directives = {}
	}
}
_EfS = Wherigo.ZMedia(_64T)
_EfS.Id = "2944ece5-80e4-48cd-9442-7ad450b938b3"
_EfS.Name = _AHU("\116\109\090\043\076\067\017\067")
_EfS.Description = ""
_EfS.AltText = ""
_EfS.Resources = {
	{
		Type = "jpg", 
		Filename = "ZeusPharmaceutics-Corp.jpg", 
		Directives = {}
	}
}
_v3xSf = Wherigo.ZMedia(_64T)
_v3xSf.Id = "c40b488a-3a93-45c4-bc89-21630b7c2202"
_v3xSf.Name = _AHU("\029\067\047\002\022\048\039\067\045\051\089\045\067\033")
_v3xSf.Description = ""
_v3xSf.AltText = ""
_v3xSf.Resources = {
	{
		Type = "png", 
		Filename = "NotizblockIcon.png", 
		Directives = {}
	}
}
_zmpI = Wherigo.ZMedia(_64T)
_zmpI.Id = "9aac9e14-b3ee-4022-8419-aa4d0d0ce6f6"
_zmpI.Name = _AHU("\079\109\017\109\033\088\002\047\047\109\039\089\045\067\033")
_zmpI.Description = ""
_zmpI.AltText = ""
_zmpI.Resources = {
	{
		Type = "png", 
		Filename = "Virus-Petrischale.png", 
		Directives = {}
	}
}
_sD0md = Wherigo.ZMedia(_64T)
_sD0md.Id = "b179cedd-3464-41d1-a4d2-e5106796d1f8"
_sD0md.Name = _AHU("\063\030\067\033\109\027\002\033\017\079\009\105\088\002\033")
_sD0md.Description = ""
_sD0md.AltText = ""
_sD0md.Resources = {
	{
		Type = "fdl", 
		Filename = "TelefonKlingeln.fdl", 
		Directives = {}
	}
}
-- Cartridge Info --
_64T.Id="be4531c2-1794-4f84-8ab5-bc99c821e400"
_64T.Name="Prometheus De - Chapter 1: Projekt Pandora"
_64T.Description=[[Prometheus DE - Chapter 1: Projekt Pandora ]]
_64T.Visible=true
_64T.Activity="Fiction"
_64T.StartingLocationDescription=[[Ich befinde mich an einem oeffentlichen Ort. Hier wollte sich der Informant mit mir treffen.]]
_64T.StartingLocation = ZonePoint(52.5057276824843,13.4489715099335,0)
_64T.Version="2.7"
_64T.Company=""
_64T.Author="Mahanako und David Greenwitch"
_64T.BuilderVersion="URWIGO 1.15.4973.39887"
_64T.CreateDate="05/13/2013 14:00:12"
_64T.PublishDate="1/1/0001 12:00:00 AM"
_64T.UpdateDate="10/08/2013 23:37:32"
_64T.LastPlayedDate="1/1/0001 12:00:00 AM"
_64T.TargetDevice="PocketPC"
_64T.TargetDeviceVersion="0"
_64T.StateId="1"
_64T.CountryId="2"
_64T.Complete=false
_64T.UseLogging=true

_64T.Media=_gUXD

_64T.Icon=_3do


-- Zones --
_83W = Wherigo.Zone(_64T)
_83W.Id = "0bd29fd4-4e21-4a13-87e4-a80dc5b0ea8d"
_83W.Name = _AHU("\118\002\033\083\038\109\104\104\109\033\047\039\002\045\030\109\105\083\063\039\009\047\022")
_83W.Description = _AHU("\118\002\033\083\067\109\104\104\109\033\047\039\002\045\030\109\105\083\063\039\009\047\022\114\083\122\109\105\083\110\033\048\109\051\009\033\033\047\109\083\030\009\047\083\088\002\045\030\083\030\002\109\105\083\030\109\105\083\017\109\048\109\047\109\033\010\083\118\105\083\088\109\002\033\047\109\004\083\109\043\083\043\109\002\083\068\067\033\083\017\105\067\109\043\043\047\109\105\083\093\002\045\030\047\002\017\051\109\002\047\114\083\032\109\002\033\109\083\025\030\033\090\033\017\004\083\059\009\043\083\002\045\030\083\030\002\109\105\083\047\090\033\083\043\067\039\039\114\083\089\045\030\083\030\067\104\104\109\083\109\002\033\104\009\045\030\004\083\109\105\083\022\009\030\039\047\083\017\090\047\083\104\090\109\105\083\007\109\033\083\056\067\048\114")
_83W.Visible = true
_83W.Media = _gk5B8
_83W.Icon = _gk5B8
_83W.Commands = {}
_83W.DistanceRange = Distance(-1, "feet")
_83W.ShowObjects = "OnEnter"
_83W.ProximityRange = Distance(60, "meters")
_83W.AllowSetPositionTo = false
_83W.Active = true
_83W.Points = {
	ZonePoint(52.5074500550954, 13.4499317407608, 0), 
	ZonePoint(52.5060705298061, 13.4489071369171, 0), 
	ZonePoint(52.5059007390858, 13.449422121048, 0), 
	ZonePoint(52.5073765903432, 13.4504681825638, 0)
}
_83W.OriginalPoint = ZonePoint(52.5066994785826, 13.4496822953224, 0)
_83W.DistanceRangeUOM = "Feet"
_83W.ProximityRangeUOM = "Meters"
_83W.OutOfRangeName = ""
_83W.InRangeName = ""
_gTjnp = Wherigo.Zone(_64T)
_gTjnp.Id = "4069d148-507e-40c6-9db7-0e566bab9e7e"
_gTjnp.Name = _AHU("\078\067\105\043\045\030\090\033\017\043\007\009\047\109\033")
_gTjnp.Description = _AHU("\062\002\109\105\083\002\105\017\109\033\007\059\067\083\088\090\109\043\043\109\033\083\007\002\109\043\109\083\078\067\105\043\045\030\090\033\017\043\007\009\047\109\033\083\043\109\002\033\114\083\089\045\030\083\043\067\039\039\047\109\083\033\009\045\030\083\109\002\033\109\105\083\049\120\109\002\045\030\109\105\051\009\105\047\109\083\043\090\045\030\109\033\114")
_gTjnp.Visible = false
_gTjnp.Media = _uQmi
_gTjnp.Icon = _uQmi
_gTjnp.Commands = {}
_gTjnp.DistanceRange = Distance(-1, "feet")
_gTjnp.ShowObjects = "OnEnter"
_gTjnp.ProximityRange = Distance(60, "meters")
_gTjnp.AllowSetPositionTo = false
_gTjnp.Active = false
_gTjnp.Points = {
	ZonePoint(52.5092343945903, 13.4561705589294, 0), 
	ZonePoint(52.5094384544178, 13.4562563896179, 0), 
	ZonePoint(52.5095151806679, 13.4559801220894, 0), 
	ZonePoint(52.5092964288781, 13.4558701515198, 0)
}
_gTjnp.OriginalPoint = ZonePoint(52.5093711146385, 13.4560693055391, 0)
_gTjnp.DistanceRangeUOM = "Feet"
_gTjnp.ProximityRangeUOM = "Meters"
_gTjnp.OutOfRangeName = ""
_gTjnp.InRangeName = ""
_uK1F = Wherigo.Zone(_64T)
_uK1F.Id = "9d57ba01-cd3b-4116-94db-b804cf061856"
_uK1F.Name = _AHU("\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\043\083\093\067\030\033\090\033\017")
_uK1F.Description = _AHU("\121\067\033\083\030\002\109\105\083\002\105\017\109\033\007\059\067\083\051\009\088\083\007\109\105\083\025\033\105\090\104\083\007\109\043\083\089\033\104\067\105\088\009\033\047\109\033\114\052\016\027\084\110\033\007\083\030\002\109\105\083\059\002\105\007\083\109\105\083\009\090\045\030\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\090\109\048\109\105\017\109\048\109\033\114\083\089\045\030\083\030\067\104\104\109\083\033\090\105\004\083\109\105\083\088\109\039\007\109\047\083\043\002\045\030\083\048\009\039\007\114\114\114")
_uK1F.Visible = false
_uK1F.Media = _C0t
_uK1F.Icon = _C0t
_uK1F.Commands = {}
_uK1F.DistanceRange = Distance(-1, "feet")
_uK1F.ShowObjects = "OnEnter"
_uK1F.ProximityRange = Distance(60, "meters")
_uK1F.AllowSetPositionTo = false
_uK1F.Active = false
_uK1F.Points = {
	ZonePoint(52.5112700530105, 13.4589359164238, 0), 
	ZonePoint(52.5109827484752, 13.460775911808, 0), 
	ZonePoint(52.5104146635246, 13.4605425596237, 0), 
	ZonePoint(52.5107248257585, 13.4586730599403, 0)
}
_uK1F.OriginalPoint = ZonePoint(52.5108480726922, 13.459731861949, 0)
_uK1F.DistanceRangeUOM = "Feet"
_uK1F.ProximityRangeUOM = "Meters"
_uK1F.OutOfRangeName = ""
_uK1F.InRangeName = ""
_V0sK = Wherigo.Zone(_64T)
_V0sK.Id = "8b3c8e30-03fd-475d-98b2-755699ae3d10"
_V0sK.Name = _AHU("\122\009\043\083\079\109\017\109\033\088\002\047\047\109\039")
_V0sK.Description = _AHU("\062\002\109\105\083\002\105\017\109\033\007\059\067\083\088\090\043\043\083\043\002\045\030\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\048\109\104\002\033\007\109\033\010\083\089\045\030\083\088\090\043\043\083\088\002\045\030\083\017\109\033\009\090\109\105\083\090\088\043\109\030\109\033\114\083\122\009\043\083\025\033\047\002\068\002\105\090\043\083\105\109\009\017\002\109\105\047\083\043\047\009\105\051\083\009\090\104\083\110\121\028\076\002\045\030\047\114")
_V0sK.Visible = false
_V0sK.Media = _C0t
_V0sK.Icon = _C0t
_V0sK.Commands = {}
_V0sK.DistanceRange = Distance(-1, "feet")
_V0sK.ShowObjects = "OnEnter"
_V0sK.ProximityRange = Distance(60, "meters")
_V0sK.AllowSetPositionTo = false
_V0sK.Active = false
_V0sK.Points = {
	ZonePoint(52.5107444148786, 13.4635734558105, 0), 
	ZonePoint(52.5113182089846, 13.4630316495895, 0), 
	ZonePoint(52.5108611332055, 13.4627808630466, 0)
}
_V0sK.OriginalPoint = ZonePoint(52.5109745856896, 13.4631286561489, 0)
_V0sK.DistanceRangeUOM = "Feet"
_V0sK.ProximityRangeUOM = "Meters"
_V0sK.OutOfRangeName = ""
_V0sK.InRangeName = ""
_010Ld = Wherigo.Zone(_64T)
_010Ld.Id = "5a559ced-afa5-4a7b-80c7-dbd8fbae8489"
_010Ld.Name = _AHU("\119\067\047\109\105\083\016\105\002\109\104\051\009\043\047\109\033\083\116\109\090\043\083\089\033\045\114")
_010Ld.Description = _AHU("\062\002\109\105\083\002\105\017\109\033\007\059\067\083\088\090\043\043\083\109\043\083\007\002\109\083\016\109\039\067\030\033\090\033\017\083\017\109\048\109\033\114\083\089\045\030\083\030\067\104\104\109\083\033\090\105\004\083\043\002\109\083\002\043\047\083\109\043\083\059\109\105\047\114")
_010Ld.Visible = false
_010Ld.Media = _EfS
_010Ld.Icon = _EfS
_010Ld.Commands = {}
_010Ld.DistanceRange = Distance(-1, "feet")
_010Ld.ShowObjects = "OnEnter"
_010Ld.ProximityRange = Distance(60, "meters")
_010Ld.AllowSetPositionTo = false
_010Ld.Active = false
_010Ld.Points = {
	ZonePoint(52.5049154501811, 13.4638296067715, 0), 
	ZonePoint(52.504839532224, 13.4637343883514, 0), 
	ZonePoint(52.5047668794326, 13.4639583528042, 0), 
	ZonePoint(52.5048517770646, 13.4639811515808, 0)
}
_010Ld.OriginalPoint = ZonePoint(52.5048434097256, 13.463875874877, 0)
_010Ld.DistanceRangeUOM = "Feet"
_010Ld.ProximityRangeUOM = "Meters"
_010Ld.OutOfRangeName = ""
_010Ld.InRangeName = ""
_9jxK = Wherigo.Zone(_64T)
_9jxK.Id = "7760c124-b534-430f-92ad-73913734ea08"
_9jxK.Name = _AHU("\122\009\043\083\121\002\105\090\043")
_9jxK.Description = _AHU("\089\045\030\083\088\090\043\043\083\088\002\045\030\083\048\109\109\002\039\109\033\114\083\089\105\017\109\033\007\059\067\083\030\002\109\105\083\048\109\104\002\033\007\109\047\083\043\002\045\030\083\007\009\043\083\121\002\105\090\043\010")
_9jxK.Visible = false
_9jxK.Media = _3do
_9jxK.Icon = _3do
_9jxK.Commands = {}
_9jxK.DistanceRange = Distance(-1, "feet")
_9jxK.ShowObjects = "OnEnter"
_9jxK.ProximityRange = Distance(60, "meters")
_9jxK.AllowSetPositionTo = false
_9jxK.Active = false
_9jxK.Points = {
	ZonePoint(52.51064973405, 13.4589882194996, 0), 
	ZonePoint(52.510484042109, 13.4599806368351, 0), 
	ZonePoint(52.5102644789196, 13.4598921239376, 0), 
	ZonePoint(52.5104318041262, 13.4588903188705, 0)
}
_9jxK.OriginalPoint = ZonePoint(52.5104575148012, 13.4594378247857, 0)
_9jxK.DistanceRangeUOM = "Feet"
_9jxK.ProximityRangeUOM = "Meters"
_9jxK.OutOfRangeName = ""
_9jxK.InRangeName = ""
_Qj3 = Wherigo.Zone(_64T)
_Qj3.Id = "2b10afd7-4387-441f-aec5-99c60a614337"
_Qj3.Name = _AHU("\119\067\047\109\105\083\016\105\002\109\104\051\009\043\047\109\033\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105")
_Qj3.Description = _AHU("\089\045\030\083\043\090\045\030\109\083\109\002\033\109\033\083\047\067\047\109\033\083\016\105\002\109\104\051\009\043\047\109\033\114\083\118\105\083\088\090\043\043\083\030\002\109\105\083\002\105\017\109\033\007\059\067\083\043\109\002\033\114\083\077\033\048\043\120\103\079\109\105\009\007\109\083\041\109\047\022\047\083\059\109\105\007\109\033\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\083\017\109\048\105\009\090\045\030\047\114\083\122\002\109\083\093\109\039\047\083\048\105\009\090\045\030\047\083\088\002\045\030\114\114\114")
_Qj3.Visible = false
_Qj3.Media = _3do
_Qj3.Icon = _3do
_Qj3.Commands = {}
_Qj3.DistanceRange = Distance(-1, "feet")
_Qj3.ShowObjects = "OnEnter"
_Qj3.ProximityRange = Distance(60, "meters")
_Qj3.AllowSetPositionTo = false
_Qj3.Active = false
_Qj3.Points = {
	ZonePoint(52.5069341666827, 13.4588165581226, 0), 
	ZonePoint(52.5068909036135, 13.4589613974094, 0), 
	ZonePoint(52.5071529302302, 13.4590847790241, 0), 
	ZonePoint(52.5071855814124, 13.4589520096779, 0)
}
_Qj3.OriginalPoint = ZonePoint(52.5070408954847, 13.4589536860585, 0)
_Qj3.DistanceRangeUOM = "Feet"
_Qj3.ProximityRangeUOM = "Meters"
_Qj3.OutOfRangeName = ""
_Qj3.InRangeName = ""
_n8_p = Wherigo.Zone(_64T)
_n8_p.Id = "09a8c833-d550-4dbc-b7f6-b9eb917f9191"
_n8_p.Name = _AHU("\119\067\047\109\105\083\016\105\002\109\104\051\009\043\047\109\033\083\062\109\039\007\109\033")
_n8_p.Description = _AHU("\089\045\030\083\043\090\045\030\109\083\109\002\033\109\033\083\047\067\047\109\033\083\016\105\002\109\104\051\009\043\047\109\033\114\083\118\105\083\088\090\043\043\083\030\002\109\105\083\002\105\017\109\033\007\059\067\083\043\109\002\033\114\083\077\033\048\043\120\103\118\002\033\083\051\039\109\002\033\109\043\083\121\109\105\043\047\109\045\051\083\088\002\047\083\032\067\033\047\009\051\047\007\009\047\109\033\114\083\121\109\105\088\090\047\039\002\045\030\083\017\090\047\083\030\002\033\047\109\105\083\109\047\059\009\043\083\068\109\105\043\047\109\045\051\047\114\083\049\002\045\030\109\105\083\033\002\045\030\047\083\002\088\083\079\109\048\090\109\043\045\030\083\067\007\109\105\083\009\088\083\016\067\007\109\033\010\083\122\002\109\083\093\109\039\047\083\048\105\009\090\045\030\047\083\088\002\045\030\114\114\114")
_n8_p.Visible = false
_n8_p.Media = _C0t
_n8_p.Icon = _C0t
_n8_p.Commands = {}
_n8_p.DistanceRange = Distance(-1, "feet")
_n8_p.ShowObjects = "OnEnter"
_n8_p.ProximityRange = Distance(60, "meters")
_n8_p.AllowSetPositionTo = false
_n8_p.Active = false
_n8_p.Points = {
	ZonePoint(52.5062941954269, 13.4599390625954, 0), 
	ZonePoint(52.5064631683348, 13.4600141644478, 0), 
	ZonePoint(52.5064468424783, 13.4601683914661, 0), 
	ZonePoint(52.5062427687608, 13.460057079792, 0)
}
_n8_p.OriginalPoint = ZonePoint(52.5063617437502, 13.4600446745753, 0)
_n8_p.DistanceRangeUOM = "Feet"
_n8_p.ProximityRangeUOM = "Meters"
_n8_p.OutOfRangeName = ""
_n8_p.InRangeName = ""

-- Characters --
_oF2 = Wherigo.ZCharacter{
	Cartridge = _64T, 
	Container = _83W
}
_oF2.Id = "1e3a6f80-e250-49b6-a814-b1a7de817f45"
_oF2.Name = _AHU("\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030")
_oF2.Description = _AHU("\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\083\028\083\109\030\109\088\009\039\002\017\109\105\083\078\067\105\043\045\030\090\033\017\043\088\002\047\009\105\048\109\002\047\109\105\083\007\109\105\083\063\105\067\088\109\047\030\109\090\043\083\055\067\105\120\114\083\118\105\083\048\009\047\083\088\002\045\030\083\090\088\083\062\002\039\104\109\114")
_oF2.Visible = true
_oF2.Media = _Xas4
_oF2.Icon = _kqG7
_oF2.Commands = {}
_oF2.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_oF2.Gender = "Male"
_oF2.Type = "NPC"
_eMzcu = Wherigo.ZCharacter(_64T)
_eMzcu.Id = "0a8d6d66-6993-44ff-a0e7-28db03914dc1"
_eMzcu.Name = _AHU("\006\105\114\056\067\030\033\043\067\033")
_eMzcu.Description = _AHU("\025\105\048\109\002\047\109\047\083\104\031\105\083\007\002\109\083\116\109\090\043\083\089\033\045\114\083\090\033\007\083\105\009\109\047\083\088\002\105\004\083\088\002\047\083\002\030\088\083\022\090\043\009\088\088\109\033\083\022\090\083\009\105\048\109\002\047\109\033\114")
_eMzcu.Visible = false
_eMzcu.Media = _CZOB
_eMzcu.Icon = _CZOB
_eMzcu.Commands = {}
_eMzcu.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_eMzcu.Gender = "Male"
_eMzcu.Type = "NPC"

-- Items --
_FQNs = Wherigo.ZItem{
	Cartridge = _64T, 
	Container = Player
}
_FQNs.Id = "41281d8c-74a2-4106-b287-ffac46c25f84"
_FQNs.Name = _AHU("\079\109\017\109\033\088\002\047\047\109\039")
_FQNs.Description = _AHU("\122\009\043\083\025\033\047\002\068\002\105\090\043\114")
_FQNs.Visible = false
_FQNs.Media = _tLtT
_FQNs.Icon = _zmpI
_FQNs.Commands = {}
_FQNs.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_FQNs.Locked = false
_FQNs.Opened = false
_h5k = Wherigo.ZItem{
	Cartridge = _64T, 
	Container = Player
}
_h5k.Id = "d52ce01b-91d9-4dc3-af10-8a216c1ce54f"
_h5k.Name = _AHU("\029\067\047\002\022\048\039\067\045\051")
_h5k.Description = _AHU("\062\002\109\105\083\043\045\030\105\109\002\048\109\083\002\045\030\083\088\002\105\083\007\002\109\083\059\002\045\030\047\002\017\043\047\109\033\083\122\002\033\017\109\083\009\090\104\114")
_h5k.Visible = true
_h5k.Media = _Qch4n
_h5k.Icon = _v3xSf
_h5k.Commands = {
	_DWa1Q = Wherigo.ZCommand{
		Text = _AHU("\025\033\043\109\030\109\033"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _AHU("\029\067\047\030\002\033\017\083\009\068\009\002\039\009\048\039\109")
	}
}
_h5k.Commands._DWa1Q.Custom = true
_h5k.Commands._DWa1Q.Id = "48d7fc9a-a145-4b88-8c3d-5f4f58da1146"
_h5k.Commands._DWa1Q.WorksWithAll = true
_h5k.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_h5k.Locked = false
_h5k.Opened = false
_PA9 = Wherigo.ZItem{
	Cartridge = _64T, 
	Container = Player
}
_PA9.Id = "232ec191-aed4-4307-b629-ab85eac20e9e"
_PA9.Name = _AHU("\110\033\039\067\045\051\055\067\007\109")
_PA9.Description = ""
_PA9.Visible = false
_PA9.Media = _Y60
_PA9.Icon = _Y60
_PA9.Commands = {
	_qZ0dC = Wherigo.ZCommand{
		Text = _AHU("\110\033\039\067\045\051\055\067\007\109\083\022\109\002\017\109\033"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _AHU("\029\067\047\030\002\033\017\083\009\068\009\002\039\009\048\039\109")
	}
}
_PA9.Commands._qZ0dC.Custom = true
_PA9.Commands._qZ0dC.Id = "b94ad2f5-1ed9-424f-b181-72b9e357b75f"
_PA9.Commands._qZ0dC.WorksWithAll = true
_PA9.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_PA9.Locked = false
_PA9.Opened = false

-- Tasks --
_D_eH = Wherigo.ZTask(_64T)
_D_eH.Id = "8f3bad2d-d473-483a-b740-f71c64fc9bb7"
_D_eH.Name = _AHU("\119\105\109\104\104\109\033\083\088\002\047\083\089\033\104\067\105\088\009\033\047\109\033")
_D_eH.Description = _AHU("\089\045\030\083\088\090\043\043\083\088\002\045\030\083\088\002\047\083\007\109\088\083\110\033\048\109\051\009\033\033\047\109\033\083\047\105\109\104\104\109\033\114\083\118\105\083\059\002\039\039\083\043\002\045\030\083\088\002\047\083\088\002\105\083\009\033\083\109\002\033\109\088\083\067\109\104\104\109\033\047\039\002\045\030\109\033\083\063\039\009\047\022\083\047\105\109\104\104\109\033\114\052\016\027\084\118\105\083\030\009\047\083\009\039\043\083\119\105\109\104\104\120\090\033\051\047\083\007\109\033\083\033\009\109\045\030\043\047\017\109\039\109\017\109\033\109\033\083\016\009\030\033\030\067\104\083\068\067\105\017\109\043\045\030\039\009\017\109\033\114")
_D_eH.Visible = true
_D_eH.Media = _kqG7
_D_eH.Icon = _kqG7
_D_eH.Active = true
_D_eH.Complete = false
_D_eH.CorrectState = "None"
_n7ZZ = Wherigo.ZTask(_64T)
_n7ZZ.Id = "076da1ec-8868-445b-b6e4-cf469e77776b"
_n7ZZ.Name = _AHU("\025\090\104\022\109\002\045\030\033\090\033\017\109\033\083\104\002\033\007\109\033")
_n7ZZ.Description = _AHU("\089\045\030\083\088\090\043\043\083\007\002\109\083\088\002\045\105\067\049\122\083\032\009\105\047\109\083\088\002\047\083\007\109\033\083\025\090\104\022\109\002\045\030\033\090\033\017\109\033\083\104\002\033\007\109\033\114\083\049\002\109\083\088\090\043\043\083\030\002\109\105\083\002\105\017\109\033\007\059\067\083\002\033\083\007\109\105\083\029\031\030\109\083\007\109\043\083\049\120\002\109\039\120\039\009\047\022\109\043\083\043\109\002\033\114\052\016\027\084\029\090\105\083\043\067\083\051\009\033\033\083\002\045\030\083\025\033\047\059\067\105\047\109\033\083\109\105\030\009\039\047\109\033\010\083")
_n7ZZ.Visible = false
_n7ZZ.Media = _Y60
_n7ZZ.Icon = _Y60
_n7ZZ.Active = false
_n7ZZ.Complete = false
_n7ZZ.CorrectState = "None"
_Ec3 = Wherigo.ZTask(_64T)
_Ec3.Id = "428eb245-85c0-44ae-9b78-55854620b9c8"
_Ec3.Name = _AHU("\116\090\088\083\110\105\043\120\105\090\033\017\083\007\109\043\083\089\033\104\067\105\088\009\033\047\109\033")
_Ec3.Description = _AHU("\089\045\030\083\088\090\043\043\083\002\033\083\007\002\109\083\029\031\030\109\083\007\109\043\083\089\033\104\067\105\088\009\033\047\109\033\083\051\067\088\088\109\033\114\083\118\105\083\059\002\105\007\083\043\002\045\030\083\048\109\002\083\088\002\105\083\088\109\039\007\109\033\004\083\007\009\033\033\083\088\090\043\043\083\002\045\030\083\109\033\047\043\045\030\109\002\007\109\033\004\083\067\048\083\002\045\030\083\006\105\114\083\056\067\030\033\043\067\033\083\048\109\043\045\030\109\002\007\083\017\109\048\109\083\067\007\109\105\083\109\043\083\009\090\104\083\109\002\017\109\033\109\083\078\009\090\043\047\083\120\105\067\048\002\109\105\109\114")
_Ec3.Visible = false
_Ec3.Media = _Q7u
_Ec3.Icon = _Q7u
_Ec3.Active = false
_Ec3.Complete = false
_Ec3.CorrectState = "None"
_zuWn = Wherigo.ZTask(_64T)
_zuWn.Id = "95fcf0da-0cbd-4e32-b96d-fc5fb1249053"
_zuWn.Name = _AHU("\089\033\104\067\105\088\009\033\047\109\033\025\090\043\039\002\109\104\109\105\033")
_zuWn.Description = _AHU("\006\105\114\083\056\067\030\033\043\067\033\083\088\067\109\045\030\047\109\004\083\007\009\043\043\083\002\045\030\083\002\030\033\083\009\033\105\090\104\109\004\083\043\067\048\009\039\007\083\002\045\030\083\007\109\033\083\089\033\104\067\105\088\009\033\047\109\033\083\047\105\109\104\104\109\033\083\051\009\033\033\114")
_zuWn.Visible = false
_zuWn.Media = _EfS
_zuWn.Icon = _EfS
_zuWn.Active = false
_zuWn.Complete = false
_zuWn.CorrectState = "None"
_woPlL = Wherigo.ZTask(_64T)
_woPlL.Id = "3c8600b9-4e4b-438f-8b46-bc12d693ce6f"
_woPlL.Name = _AHU("\016\109\039\067\030\033\090\033\017\083\025\048\030\067\039\109\033")
_woPlL.Description = _AHU("\006\105\114\083\056\067\030\033\043\067\033\083\002\043\047\083\043\109\030\105\083\022\090\104\105\002\109\007\109\033\083\088\002\047\083\088\109\002\033\109\105\083\025\105\048\109\002\047\114\083\089\045\030\083\104\002\033\007\109\083\088\109\002\033\109\083\115\016\109\039\067\030\033\090\033\017\115\083\009\033\083\007\109\033\083\032\067\067\105\007\002\033\009\047\109\033")
_woPlL.Visible = false
_woPlL.Media = _CZOB
_woPlL.Icon = _CZOB
_woPlL.Active = false
_woPlL.Complete = false
_woPlL.CorrectState = "None"
_mCde = Wherigo.ZTask(_64T)
_mCde.Id = "508bbfed-710c-4e88-8f73-104cb82b401a"
_mCde.Name = _AHU("\121\002\105\090\043\083\068\109\105\033\002\045\030\047\109\033")
_mCde.Description = _AHU("\089\045\030\083\088\090\043\043\083\007\009\043\083\121\002\105\090\043\083\068\109\105\033\002\045\030\047\109\033\114\083\025\048\109\105\083\007\002\109\083\116\109\002\047\083\002\043\047\083\051\033\009\120\120\114\114\114")
_mCde.Visible = false
_mCde.Media = _C0t
_mCde.Icon = _C0t
_mCde.Active = false
_mCde.Complete = false
_mCde.CorrectState = "None"
_HMlVW = Wherigo.ZTask(_64T)
_HMlVW.Id = "6ca50cfe-a2d7-42f8-884e-4c39f66a9a42"
_HMlVW.Name = _AHU("\025\033\047\002\068\002\105\090\043\083\104\002\033\007\109\033")
_HMlVW.Description = _AHU("\089\045\030\083\048\105\009\090\045\030\109\083\022\090\109\105\043\047\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\114\083\122\002\109\083\116\109\002\047\083\002\043\047\083\051\033\009\120\120\114\083\079\067\047\047\083\043\109\002\083\007\009\033\051\083\105\109\009\017\002\109\105\047\083\109\043\083\043\047\009\105\051\083\009\090\104\083\110\121\028\076\002\045\030\047\114")
_HMlVW.Visible = false
_HMlVW.Media = _C0t
_HMlVW.Icon = _C0t
_HMlVW.Active = false
_HMlVW.Complete = false
_HMlVW.CorrectState = "None"
_1Ow = Wherigo.ZTask(_64T)
_1Ow.Id = "40fdcd99-619d-4274-b6df-e048bbcf39e7"
_1Ow.Name = _AHU("\119\105\109\104\104\109\033\083\088\002\047\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\043")
_1Ow.Description = _AHU("\089\045\030\083\088\090\043\043\083\088\002\045\030\083\088\002\047\083\009\033\007\109\105\109\033\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\033\083\047\105\109\104\104\109\033\114\083\118\043\083\002\043\047\083\033\067\045\030\083\033\002\045\030\047\083\068\067\105\048\109\002\114\114\114")
_1Ow.Visible = false
_1Ow.Media = _kqG7
_1Ow.Icon = _kqG7
_1Ow.Active = false
_1Ow.Complete = false
_1Ow.CorrectState = "None"
_1la = Wherigo.ZTask(_64T)
_1la.Id = "27fd11c1-13c8-4199-94aa-da800321787b"
_1la.Name = _AHU("\006\002\047\083\062\109\039\007\109\033\083\047\105\109\104\104\109\033")
_1la.Description = _AHU("\089\045\030\083\088\090\043\043\083\088\002\045\030\083\088\002\047\083\009\033\007\109\105\109\033\083\062\109\039\007\109\033\083\047\105\109\104\104\109\033\114\083\118\043\083\002\043\047\083\033\067\045\030\083\033\002\045\030\047\083\068\067\105\048\109\002\114\114\114")
_1la.Visible = false
_1la.Media = _kqG7
_1la.Icon = _kqG7
_1la.Active = false
_1la.Complete = false
_1la.CorrectState = "None"
_1MJv = Wherigo.ZTask(_64T)
_1MJv.Id = "4319b745-216b-4917-8e70-1a0c2948f2c4"
_1MJv.Name = _AHU("\056\067\030\033\043\067\033\043\025\033\105\090\104\025\033\033\109\030\088\109\033")
_1MJv.Description = ""
_1MJv.Visible = false
_1MJv.Active = false
_1MJv.Complete = false
_1MJv.CorrectState = "None"

-- Cartridge Variables --
_7cVr = _AHU("\118\043\083\002\043\047\083\043\045\030\067\033\083\043\109\039\047\043\009\088\083\028\083\009\090\045\030\083\104\090\109\105\083\109\002\033\109\033\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\083\028\083\109\002\033\109\033\083\009\033\067\033\037\088\109\033\083\025\033\105\090\104\083\022\090\083\048\109\051\067\088\088\109\033\114\052\016\027\084\122\109\105\083\025\033\105\090\104\109\105\083\088\109\002\033\047\109\004\083\002\045\030\083\043\067\039\039\109\083\002\030\033\083\009\033\083\109\002\033\109\088\083\067\109\104\104\109\033\047\039\002\045\030\109\033\083\038\105\047\083\047\105\109\104\104\109\033\114\083\118\043\083\109\002\039\047\083\090\033\007\083\043\109\002\083\068\067\033\083\030\067\109\045\030\043\047\109\105\083\122\105\002\033\017\039\002\045\030\051\109\002\047\114\052\016\027\084\052\016\027\084\025\048\109\105\083\114\114\114\083\059\009\043\083\059\002\039\039\083\007\109\105\083\006\009\033\033\083\068\067\033\083\088\002\105\031\083\118\105\083\043\047\009\088\088\109\039\047\109\083\033\090\105\083\109\002\033\083\120\009\009\105\083\090\033\022\090\043\009\088\088\109\033\030\009\109\033\017\109\033\007\109\083\016\105\067\045\051\109\033\114\083\118\043\083\043\109\002\083\017\109\104\009\109\030\105\039\002\045\030\114\083\029\002\109\088\009\033\007\109\088\083\059\009\109\105\109\083\022\090\083\047\105\009\090\109\033\114\114\114\083\049\067\033\007\109\105\048\009\105\004\083\109\002\033\104\009\045\030\083\033\090\105\083\043\067\033\007\109\105\048\009\105\114")
_tZZ = _AHU("\118\033\007\039\002\045\030\083\109\105\104\009\030\105\109\083\002\045\030\004\083\059\067\105\090\088\083\109\043\083\030\002\109\105\083\017\109\030\047\114\083\118\002\033\083\121\002\105\090\043\004\083\007\009\043\083\104\105\109\002\017\109\043\109\047\022\047\083\059\002\105\007\031\083\025\048\109\105\083\059\009\105\090\088\083\033\090\105\031\083\089\045\030\083\088\090\043\043\083\088\109\030\105\083\109\105\104\009\030\105\109\033\114\083\121\002\109\039\039\109\002\045\030\047\083\059\002\105\007\083\088\002\105\083\109\002\033\002\017\109\043\083\051\039\009\105\109\105\004\083\059\109\033\033\083\002\045\030\083\007\002\109\083\078\067\105\043\045\030\090\033\017\043\007\009\047\109\033\083\017\109\104\090\033\007\109\033\083\030\009\048\109\114")
_gpW3 = ""
_gI33g = _AHU("\118\033\007\039\002\045\030\083\030\009\048\109\083\002\045\030\083\007\002\109\083\110\033\047\109\105\039\009\017\109\033\083\017\109\104\090\033\007\109\033\114\083\118\105\043\045\030\105\109\045\051\109\033\007\114\083\118\105\083\043\045\030\109\002\033\047\083\027\109\045\030\047\083\022\090\083\030\009\048\109\033\114\083\038\104\104\109\033\048\009\105\083\059\002\105\007\083\030\002\109\105\083\088\002\047\083\007\109\088\083\076\109\048\109\033\083\068\067\033\083\090\033\043\045\030\090\039\007\002\017\109\033\083\017\109\043\120\002\109\039\047\114\083\089\045\030\083\088\090\043\043\083\109\047\059\009\043\083\090\033\047\109\105\033\109\030\088\109\033\114\114\114")
_sFi3H = _AHU("\006\105\114\083\056\067\030\033\043\067\033\083\030\009\047\083\088\002\045\030\083\009\033\017\109\105\090\104\109\033\114\083\049\109\002\033\109\105\083\006\109\002\033\090\033\017\083\033\009\045\030\083\051\009\033\033\083\033\090\105\083\043\109\002\033\083\110\033\047\109\105\033\109\030\088\109\033\083\090\033\043\083\009\039\039\109\033\083\030\109\039\104\109\033\114\083\089\045\030\083\088\090\043\043\083\088\002\105\083\090\109\048\109\105\039\109\017\109\033\004\083\067\048\083\002\045\030\083\002\030\088\083\030\109\039\104\109\033\083\059\002\039\039\083\090\033\007\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\083\009\090\043\039\002\109\104\109\105\109\083\067\007\109\105\083\088\002\045\030\083\009\039\039\109\002\033\083\007\009\105\090\088\083\051\090\109\088\088\109\105\033\083\059\002\039\039\114\052\016\027\084\121\109\105\104\039\090\045\030\047\004\083\059\109\033\033\083\002\045\030\083\007\067\045\030\083\033\090\105\083\059\090\109\043\043\047\109\004\083\059\009\043\083\007\009\043\083\016\109\043\047\109\083\002\043\047\114\114\114")
_dOKW = false
_NhEiR = _AHU("\006\109\002\033\083\089\033\104\067\105\088\009\033\047\083\030\009\047\083\043\002\045\030\083\017\109\088\109\039\007\109\047\114\083\089\045\030\083\059\109\105\007\109\083\002\030\033\083\047\105\109\104\104\109\033\114\083\089\045\030\083\088\090\043\043\083\088\002\105\083\033\090\105\083\031\048\109\105\039\109\017\109\033\004\083\067\048\083\002\045\030\083\007\002\109\043\109\083\089\033\104\067\105\088\009\047\002\067\033\083\033\002\045\030\047\083\007\067\045\030\083\009\033\083\006\105\114\083\056\067\030\033\043\067\033\083\059\109\002\047\109\105\017\109\048\109\114\083\121\002\109\039\039\109\002\045\030\047\083\051\009\033\033\083\109\105\083\090\033\043\083\009\039\039\109\033\083\059\002\105\051\039\002\045\030\083\033\067\045\030\083\009\088\083\016\109\043\047\109\033\083\030\109\039\104\109\033\114\083\038\007\109\105\083\043\067\039\039\047\109\083\002\045\030\083\109\043\083\007\067\045\030\083\009\039\039\109\002\033\083\120\105\067\048\002\109\105\109\033\031\083\089\045\030\083\051\009\033\033\083\033\002\109\088\009\033\007\109\088\083\047\105\009\090\109\033\114\114\114")
_vgC9t = _AHU("\089\045\030\083\030\009\048\109\083\088\002\045\030\083\109\033\047\043\045\030\002\109\007\109\033\114\083\029\090\105\083\007\002\109\083\116\109\090\043\083\089\033\045\114\083\051\009\033\033\083\090\033\043\083\033\067\045\030\083\030\109\039\104\109\033\114\083\089\045\030\083\030\067\104\104\109\083\033\090\105\004\083\002\045\030\083\048\109\105\109\090\109\083\088\109\002\033\109\033\083\118\033\047\043\045\030\039\090\043\043\083\043\120\009\109\047\109\105\083\033\002\045\030\047\010\083\006\067\109\017\109\083\079\067\047\047\083\090\033\043\083\009\039\039\109\033\083\048\109\002\043\047\109\030\109\033\010\083\089\045\030\083\088\090\043\043\083\033\090\033\083\007\109\033\083\047\067\047\109\033\083\016\105\002\109\104\051\009\043\047\109\033\083\007\109\105\083\116\109\090\043\083\089\033\045\114\083\104\002\033\007\109\033\114\083\049\002\109\083\059\109\105\007\109\033\083\006\109\033\043\045\030\109\033\083\059\002\109\083\088\002\045\030\083\048\105\009\090\045\030\109\033\114")
_HgE0 = _AHU("\089\045\030\083\017\039\009\090\048\109\004\083\002\045\030\083\051\009\033\033\083\007\109\033\109\033\083\033\002\045\030\047\083\047\105\009\090\109\033\114\083\089\045\030\083\051\009\033\033\083\033\002\109\088\009\033\007\109\088\083\047\105\009\090\109\033\010\083\078\090\109\105\083\088\009\033\045\030\109\083\006\109\033\043\045\030\109\033\083\043\047\109\030\047\083\063\105\067\104\002\047\083\090\109\048\109\105\083\007\109\088\083\076\109\048\109\033\114\083\118\043\083\059\002\105\007\083\116\109\002\047\004\083\007\009\043\043\083\002\045\030\083\007\009\043\083\009\090\104\083\088\109\002\033\109\083\093\109\002\043\109\083\039\067\109\043\109\114")
_6d9V = _AHU("\089\045\030\083\088\090\043\043\083\007\009\043\083\025\033\047\002\068\002\105\090\043\083\104\002\033\007\109\033\114\083\122\002\109\083\116\109\002\047\083\007\105\009\109\033\017\047\114\083\118\043\083\088\090\043\043\083\030\002\109\105\083\002\105\017\109\033\007\059\067\083\043\109\002\033\114\083\116\090\088\083\079\039\090\109\045\051\083\105\109\009\017\002\109\105\047\083\109\043\083\043\047\009\105\051\083\009\090\104\083\110\121\028\076\002\045\030\047\114\083\049\067\083\051\009\033\033\083\002\045\030\083\109\043\083\043\045\030\033\109\039\039\083\104\002\033\007\109\033\083\090\033\007\083\007\002\109\083\122\029\025\083\049\109\072\090\109\033\022\083\109\105\030\009\039\047\109\033\114")
_ErB5 = _AHU("\089\045\030\083\030\009\048\109\083\007\009\043\083\025\033\047\002\068\002\105\090\043\114\083\056\109\047\022\047\083\088\090\043\043\083\002\045\030\083\033\090\105\083\033\067\045\030\083\007\009\043\083\121\002\105\090\043\083\104\002\033\007\109\033\083\090\033\007\083\068\109\105\033\002\045\030\047\109\033\010\083\122\002\109\083\116\109\002\047\083\007\105\009\109\033\017\047\114\083\016\009\039\007\083\059\002\105\007\083\109\043\083\022\090\083\043\120\009\109\047\083\043\109\002\033\114\114\114")
_UJqko = _AHU("\089\045\030\083\030\009\048\109\083\007\009\043\083\121\002\105\090\043\083\033\002\045\030\047\083\068\109\105\033\002\045\030\047\109\033\083\051\067\109\033\033\109\033\114\083\025\039\039\109\043\083\059\009\105\083\090\088\043\067\033\043\047\114\114\114\083\025\048\109\105\083\007\109\105\083\089\033\104\067\105\088\009\033\047\083\043\009\017\047\004\083\109\043\083\048\109\043\047\109\030\047\083\033\067\045\030\083\062\067\104\104\033\090\033\017\114\083\089\045\030\083\088\090\043\043\083\088\002\047\083\002\030\088\083\002\033\083\032\067\033\047\009\051\047\083\047\105\109\047\109\033\114\083\079\109\105\009\007\109\083\041\109\047\022\047\083\059\109\105\007\109\033\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\083\017\109\048\105\009\090\045\030\047\114\083\121\002\109\039\039\109\002\045\030\047\083\030\002\039\104\047\083\007\109\105\083\047\067\047\109\083\016\105\002\109\104\051\009\043\047\109\033\114")
_sMOxN = _AHU("\118\043\083\002\043\047\083\017\109\043\045\030\009\104\104\047\010\083\025\048\109\105\083\007\109\105\083\089\033\104\067\105\088\009\033\047\083\059\009\105\033\047\083\088\002\045\030\114\083\049\045\030\067\033\083\088\067\105\017\109\033\083\051\031\033\033\047\109\083\007\002\109\083\033\031\045\030\043\047\109\083\016\109\007\105\067\030\090\033\017\083\051\067\088\088\109\033\114\083\089\045\030\083\088\090\043\043\083\062\002\039\104\109\083\030\067\039\109\033\114\083\118\043\083\059\002\105\007\083\116\109\002\047\004\083\088\002\047\083\009\033\007\109\105\109\033\083\059\002\109\083\088\002\105\083\002\033\083\032\067\033\047\009\051\047\083\022\090\083\047\105\109\047\109\033\114\083\121\002\109\039\039\109\002\045\030\047\083\030\002\039\104\047\083\007\109\105\083\047\067\047\109\083\016\105\002\109\104\051\009\043\047\109\033\083\088\109\002\033\109\043\083\089\033\104\067\105\088\009\033\047\109\033\083\059\109\002\047\109\105\114\114\114")
_WGVO = ""
_0iMVd = _AHU("\020\074\019\093")
_NTHY = _AHU("\020\067\078\012")
_kNm = _AHU("\020\078\057\029\043")
_X3LIl = _AHU("\020\122\020\109\062")
_eQpE1 = _AHU("\020\008\079\105\055")
_ZMs = _AHU("\020\043\041\027")
_64T.ZVariables = {
	_7cVr = _AHU("\118\043\083\002\043\047\083\043\045\030\067\033\083\043\109\039\047\043\009\088\083\028\083\009\090\045\030\083\104\090\109\105\083\109\002\033\109\033\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\083\028\083\109\002\033\109\033\083\009\033\067\033\037\088\109\033\083\025\033\105\090\104\083\022\090\083\048\109\051\067\088\088\109\033\114\052\016\027\084\122\109\105\083\025\033\105\090\104\109\105\083\088\109\002\033\047\109\004\083\002\045\030\083\043\067\039\039\109\083\002\030\033\083\009\033\083\109\002\033\109\088\083\067\109\104\104\109\033\047\039\002\045\030\109\033\083\038\105\047\083\047\105\109\104\104\109\033\114\083\118\043\083\109\002\039\047\083\090\033\007\083\043\109\002\083\068\067\033\083\030\067\109\045\030\043\047\109\105\083\122\105\002\033\017\039\002\045\030\051\109\002\047\114\052\016\027\084\052\016\027\084\025\048\109\105\083\114\114\114\083\059\009\043\083\059\002\039\039\083\007\109\105\083\006\009\033\033\083\068\067\033\083\088\002\105\031\083\118\105\083\043\047\009\088\088\109\039\047\109\083\033\090\105\083\109\002\033\083\120\009\009\105\083\090\033\022\090\043\009\088\088\109\033\030\009\109\033\017\109\033\007\109\083\016\105\067\045\051\109\033\114\083\118\043\083\043\109\002\083\017\109\104\009\109\030\105\039\002\045\030\114\083\029\002\109\088\009\033\007\109\088\083\059\009\109\105\109\083\022\090\083\047\105\009\090\109\033\114\114\114\083\049\067\033\007\109\105\048\009\105\004\083\109\002\033\104\009\045\030\083\033\090\105\083\043\067\033\007\109\105\048\009\105\114"), 
	_tZZ = _AHU("\118\033\007\039\002\045\030\083\109\105\104\009\030\105\109\083\002\045\030\004\083\059\067\105\090\088\083\109\043\083\030\002\109\105\083\017\109\030\047\114\083\118\002\033\083\121\002\105\090\043\004\083\007\009\043\083\104\105\109\002\017\109\043\109\047\022\047\083\059\002\105\007\031\083\025\048\109\105\083\059\009\105\090\088\083\033\090\105\031\083\089\045\030\083\088\090\043\043\083\088\109\030\105\083\109\105\104\009\030\105\109\033\114\083\121\002\109\039\039\109\002\045\030\047\083\059\002\105\007\083\088\002\105\083\109\002\033\002\017\109\043\083\051\039\009\105\109\105\004\083\059\109\033\033\083\002\045\030\083\007\002\109\083\078\067\105\043\045\030\090\033\017\043\007\009\047\109\033\083\017\109\104\090\033\007\109\033\083\030\009\048\109\114"), 
	_gpW3 = "", 
	_gI33g = _AHU("\118\033\007\039\002\045\030\083\030\009\048\109\083\002\045\030\083\007\002\109\083\110\033\047\109\105\039\009\017\109\033\083\017\109\104\090\033\007\109\033\114\083\118\105\043\045\030\105\109\045\051\109\033\007\114\083\118\105\083\043\045\030\109\002\033\047\083\027\109\045\030\047\083\022\090\083\030\009\048\109\033\114\083\038\104\104\109\033\048\009\105\083\059\002\105\007\083\030\002\109\105\083\088\002\047\083\007\109\088\083\076\109\048\109\033\083\068\067\033\083\090\033\043\045\030\090\039\007\002\017\109\033\083\017\109\043\120\002\109\039\047\114\083\089\045\030\083\088\090\043\043\083\109\047\059\009\043\083\090\033\047\109\105\033\109\030\088\109\033\114\114\114"), 
	_sFi3H = _AHU("\006\105\114\083\056\067\030\033\043\067\033\083\030\009\047\083\088\002\045\030\083\009\033\017\109\105\090\104\109\033\114\083\049\109\002\033\109\105\083\006\109\002\033\090\033\017\083\033\009\045\030\083\051\009\033\033\083\033\090\105\083\043\109\002\033\083\110\033\047\109\105\033\109\030\088\109\033\083\090\033\043\083\009\039\039\109\033\083\030\109\039\104\109\033\114\083\089\045\030\083\088\090\043\043\083\088\002\105\083\090\109\048\109\105\039\109\017\109\033\004\083\067\048\083\002\045\030\083\002\030\088\083\030\109\039\104\109\033\083\059\002\039\039\083\090\033\007\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\083\009\090\043\039\002\109\104\109\105\109\083\067\007\109\105\083\088\002\045\030\083\009\039\039\109\002\033\083\007\009\105\090\088\083\051\090\109\088\088\109\105\033\083\059\002\039\039\114\052\016\027\084\121\109\105\104\039\090\045\030\047\004\083\059\109\033\033\083\002\045\030\083\007\067\045\030\083\033\090\105\083\059\090\109\043\043\047\109\004\083\059\009\043\083\007\009\043\083\016\109\043\047\109\083\002\043\047\114\114\114"), 
	_dOKW = false, 
	_NhEiR = _AHU("\006\109\002\033\083\089\033\104\067\105\088\009\033\047\083\030\009\047\083\043\002\045\030\083\017\109\088\109\039\007\109\047\114\083\089\045\030\083\059\109\105\007\109\083\002\030\033\083\047\105\109\104\104\109\033\114\083\089\045\030\083\088\090\043\043\083\088\002\105\083\033\090\105\083\031\048\109\105\039\109\017\109\033\004\083\067\048\083\002\045\030\083\007\002\109\043\109\083\089\033\104\067\105\088\009\047\002\067\033\083\033\002\045\030\047\083\007\067\045\030\083\009\033\083\006\105\114\083\056\067\030\033\043\067\033\083\059\109\002\047\109\105\017\109\048\109\114\083\121\002\109\039\039\109\002\045\030\047\083\051\009\033\033\083\109\105\083\090\033\043\083\009\039\039\109\033\083\059\002\105\051\039\002\045\030\083\033\067\045\030\083\009\088\083\016\109\043\047\109\033\083\030\109\039\104\109\033\114\083\038\007\109\105\083\043\067\039\039\047\109\083\002\045\030\083\109\043\083\007\067\045\030\083\009\039\039\109\002\033\083\120\105\067\048\002\109\105\109\033\031\083\089\045\030\083\051\009\033\033\083\033\002\109\088\009\033\007\109\088\083\047\105\009\090\109\033\114\114\114"), 
	_vgC9t = _AHU("\089\045\030\083\030\009\048\109\083\088\002\045\030\083\109\033\047\043\045\030\002\109\007\109\033\114\083\029\090\105\083\007\002\109\083\116\109\090\043\083\089\033\045\114\083\051\009\033\033\083\090\033\043\083\033\067\045\030\083\030\109\039\104\109\033\114\083\089\045\030\083\030\067\104\104\109\083\033\090\105\004\083\002\045\030\083\048\109\105\109\090\109\083\088\109\002\033\109\033\083\118\033\047\043\045\030\039\090\043\043\083\043\120\009\109\047\109\105\083\033\002\045\030\047\010\083\006\067\109\017\109\083\079\067\047\047\083\090\033\043\083\009\039\039\109\033\083\048\109\002\043\047\109\030\109\033\010\083\089\045\030\083\088\090\043\043\083\033\090\033\083\007\109\033\083\047\067\047\109\033\083\016\105\002\109\104\051\009\043\047\109\033\083\007\109\105\083\116\109\090\043\083\089\033\045\114\083\104\002\033\007\109\033\114\083\049\002\109\083\059\109\105\007\109\033\083\006\109\033\043\045\030\109\033\083\059\002\109\083\088\002\045\030\083\048\105\009\090\045\030\109\033\114"), 
	_HgE0 = _AHU("\089\045\030\083\017\039\009\090\048\109\004\083\002\045\030\083\051\009\033\033\083\007\109\033\109\033\083\033\002\045\030\047\083\047\105\009\090\109\033\114\083\089\045\030\083\051\009\033\033\083\033\002\109\088\009\033\007\109\088\083\047\105\009\090\109\033\010\083\078\090\109\105\083\088\009\033\045\030\109\083\006\109\033\043\045\030\109\033\083\043\047\109\030\047\083\063\105\067\104\002\047\083\090\109\048\109\105\083\007\109\088\083\076\109\048\109\033\114\083\118\043\083\059\002\105\007\083\116\109\002\047\004\083\007\009\043\043\083\002\045\030\083\007\009\043\083\009\090\104\083\088\109\002\033\109\083\093\109\002\043\109\083\039\067\109\043\109\114"), 
	_6d9V = _AHU("\089\045\030\083\088\090\043\043\083\007\009\043\083\025\033\047\002\068\002\105\090\043\083\104\002\033\007\109\033\114\083\122\002\109\083\116\109\002\047\083\007\105\009\109\033\017\047\114\083\118\043\083\088\090\043\043\083\030\002\109\105\083\002\105\017\109\033\007\059\067\083\043\109\002\033\114\083\116\090\088\083\079\039\090\109\045\051\083\105\109\009\017\002\109\105\047\083\109\043\083\043\047\009\105\051\083\009\090\104\083\110\121\028\076\002\045\030\047\114\083\049\067\083\051\009\033\033\083\002\045\030\083\109\043\083\043\045\030\033\109\039\039\083\104\002\033\007\109\033\083\090\033\007\083\007\002\109\083\122\029\025\083\049\109\072\090\109\033\022\083\109\105\030\009\039\047\109\033\114"), 
	_ErB5 = _AHU("\089\045\030\083\030\009\048\109\083\007\009\043\083\025\033\047\002\068\002\105\090\043\114\083\056\109\047\022\047\083\088\090\043\043\083\002\045\030\083\033\090\105\083\033\067\045\030\083\007\009\043\083\121\002\105\090\043\083\104\002\033\007\109\033\083\090\033\007\083\068\109\105\033\002\045\030\047\109\033\010\083\122\002\109\083\116\109\002\047\083\007\105\009\109\033\017\047\114\083\016\009\039\007\083\059\002\105\007\083\109\043\083\022\090\083\043\120\009\109\047\083\043\109\002\033\114\114\114"), 
	_UJqko = _AHU("\089\045\030\083\030\009\048\109\083\007\009\043\083\121\002\105\090\043\083\033\002\045\030\047\083\068\109\105\033\002\045\030\047\109\033\083\051\067\109\033\033\109\033\114\083\025\039\039\109\043\083\059\009\105\083\090\088\043\067\033\043\047\114\114\114\083\025\048\109\105\083\007\109\105\083\089\033\104\067\105\088\009\033\047\083\043\009\017\047\004\083\109\043\083\048\109\043\047\109\030\047\083\033\067\045\030\083\062\067\104\104\033\090\033\017\114\083\089\045\030\083\088\090\043\043\083\088\002\047\083\002\030\088\083\002\033\083\032\067\033\047\009\051\047\083\047\105\109\047\109\033\114\083\079\109\105\009\007\109\083\041\109\047\022\047\083\059\109\105\007\109\033\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\083\017\109\048\105\009\090\045\030\047\114\083\121\002\109\039\039\109\002\045\030\047\083\030\002\039\104\047\083\007\109\105\083\047\067\047\109\083\016\105\002\109\104\051\009\043\047\109\033\114"), 
	_sMOxN = _AHU("\118\043\083\002\043\047\083\017\109\043\045\030\009\104\104\047\010\083\025\048\109\105\083\007\109\105\083\089\033\104\067\105\088\009\033\047\083\059\009\105\033\047\083\088\002\045\030\114\083\049\045\030\067\033\083\088\067\105\017\109\033\083\051\031\033\033\047\109\083\007\002\109\083\033\031\045\030\043\047\109\083\016\109\007\105\067\030\090\033\017\083\051\067\088\088\109\033\114\083\089\045\030\083\088\090\043\043\083\062\002\039\104\109\083\030\067\039\109\033\114\083\118\043\083\059\002\105\007\083\116\109\002\047\004\083\088\002\047\083\009\033\007\109\105\109\033\083\059\002\109\083\088\002\105\083\002\033\083\032\067\033\047\009\051\047\083\022\090\083\047\105\109\047\109\033\114\083\121\002\109\039\039\109\002\045\030\047\083\030\002\039\104\047\083\007\109\105\083\047\067\047\109\083\016\105\002\109\104\051\009\043\047\109\033\083\088\109\002\033\109\043\083\089\033\104\067\105\088\009\033\047\109\033\083\059\109\002\047\109\105\114\114\114"), 
	_WGVO = "", 
	_0iMVd = _AHU("\020\074\019\093"), 
	_NTHY = _AHU("\020\067\078\012"), 
	_kNm = _AHU("\020\078\057\029\043"), 
	_X3LIl = _AHU("\020\122\020\109\062"), 
	_eQpE1 = _AHU("\020\008\079\105\055"), 
	_ZMs = _AHU("\020\043\041\027")
}

-- Timers --
_sjR = Wherigo.ZTimer(_64T)
_sjR.Id = "705467b5-2c69-4cf4-8994-ca950ce7d3ba"
_sjR.Name = _AHU("\006\105\056\067\030\033\043\067\033\119\002\088\109\105")
_sjR.Description = _AHU("\007\109\105\083\027\090\109\045\051\105\090\104\047\002\088\109\105\083\104\090\109\105\083\068\109\105\120\009\043\043\047\109\033\083\056\067\030\033\043\067\033\009\033\105\090\104")
_sjR.Visible = true
_sjR.Duration = 5
_sjR.Type = "Countdown"
_NCS = Wherigo.ZTimer(_64T)
_NCS.Id = "33bdccb6-ea06-4f74-bb0b-5a496822dcf0"
_NCS.Name = _AHU("\089\033\104\067\105\088\009\033\047\109\033\025\033\105\090\104\118\033\047\043\045\030\039\031\043\043\109\039\047")
_NCS.Description = _AHU("\122\109\105\083\119\002\088\109\105\004\083\059\109\033\033\083\007\109\105\083\002\033\104\067\105\088\009\033\047\083\043\002\045\030\083\088\109\039\007\109\047\083\088\002\047\083\007\109\033\083\122\009\047\109\033")
_NCS.Visible = true
_NCS.Duration = 5
_NCS.Type = "Countdown"
_pCal7 = Wherigo.ZTimer(_64T)
_pCal7.Id = "031e5ad2-c5cd-4901-996c-ae2a47065aa2"
_pCal7.Name = _AHU("\121\002\105\090\043\119\002\088\109\105")
_pCal7.Description = ""
_pCal7.Visible = true
_pCal7.Duration = 300
_pCal7.Type = "Countdown"
_66mD = Wherigo.ZTimer(_64T)
_66mD.Id = "fd244774-8f7d-4a47-8b87-38e0195bbad6"
_66mD.Name = _AHU("\121\002\105\090\043\062\002\033\047\119\002\088\109\105")
_66mD.Description = ""
_66mD.Visible = true
_66mD.Duration = 120
_66mD.Type = "Countdown"
_6Cw = Wherigo.ZTimer(_64T)
_6Cw.Id = "3276a683-f33a-4b4b-b286-84ff28932754"
_6Cw.Name = _AHU("\029\067\047\109\120\009\007\119\002\088\109\105")
_6Cw.Description = _AHU("\122\109\105\083\119\002\088\109\083\090\088\083\007\009\043\083\029\067\047\109\120\009\007\083\022\090\083\031\104\104\033\109\033\114\083\016\109\002\083\105\109\002\033\109\088\083\055\039\002\045\051\083\120\067\120\120\047\083\007\009\043\083\122\002\009\039\067\017\104\109\033\043\047\109\105\083\030\002\033\047\109\105\083\009\039\039\109\088\083\025\090\104\083\090\033\007\083\051\009\033\033\083\033\002\045\030\047\083\017\109\043\109\030\109\033\083\023\083\017\109\033\090\047\022\047\083\059\109\105\007\109\033\010\083\122\009\043\083\090\088\017\109\030\047\083\007\109\033\083\016\090\017\010")
_6Cw.Visible = true
_6Cw.Duration = 1
_6Cw.Type = "Countdown"
_n92 = Wherigo.ZTimer(_64T)
_n92.Id = "f2bbbac0-352b-45bc-9957-55ced32b9fb2"
_n92.Name = _AHU("\118\105\043\047\109\043\119\105\109\104\104\109\033\006\002\047\089\033\104\067\105\088\009\033\047\119\002\088\109\105")
_n92.Description = _AHU("\119\002\088\109\105\083\104\031\105\083\109\105\033\109\090\047\109\033\083\025\033\105\090\104\083\007\109\043\083\089\033\104\067\105\088\009\033\047\109\033\083\002\033\083\070\114\083\116\067\033\109")
_n92.Visible = true
_n92.Duration = 4
_n92.Type = "Countdown"
_pwd = Wherigo.ZTimer(_64T)
_pwd.Id = "91db62b1-54b8-4f2c-ba0c-68f3f0027d86"
_pwd.Name = _AHU("\089\033\104\067\105\088\009\033\047\079\109\017\109\033\088\002\047\047\109\039\055\009\039\039")
_pwd.Description = _AHU("\122\109\105\083\119\002\088\109\105\004\083\007\009\043\043\083\007\109\105\083\089\033\104\067\105\088\009\033\047\083\109\105\033\109\090\047\083\009\033\105\090\104\047\004\083\104\009\039\039\043\083\025\033\105\090\104\083\009\048\017\109\039\109\030\033\047\083\002\033\083\079\109\017\109\033\088\002\047\047\109\039\022\067\033\109")
_pwd.Visible = true
_pwd.Duration = 5
_pwd.Type = "Countdown"
_b6yE = Wherigo.ZTimer(_64T)
_b6yE.Id = "7711c30c-3a20-4efd-8e5a-5d0c30a2325c"
_b6yE.Name = _AHU("\110\033\039\067\045\051\055\067\007\109\119\002\088\109\105")
_b6yE.Description = _AHU("\122\109\105\083\119\002\088\109\105\083\090\088\083\007\109\033\083\110\033\039\067\045\051\055\067\007\109\083\009\033\022\090\022\109\002\017\109\033")
_b6yE.Visible = true
_b6yE.Duration = 1
_b6yE.Type = "Countdown"
_6HJvw = Wherigo.ZTimer(_64T)
_6HJvw.Id = "7f2c6e78-1364-4afb-84c7-ae4ba6afa84b"
_6HJvw.Name = _AHU("\056\067\030\033\043\067\033\025\033\105\090\104\119\002\088\109\105")
_6HJvw.Description = _AHU("\122\109\105\083\109\105\043\047\109\083\025\033\105\090\104\083\068\067\033\083\056\067\030\033\043\067\033")
_6HJvw.Visible = true
_6HJvw.Duration = 17
_6HJvw.Type = "Countdown"

-- Inputs --
_XGrC = Wherigo.ZInput(_64T)
_XGrC.Id = "cc4a1f0e-8c43-4fa5-85a9-0ba2dd2b7018"
_XGrC.Name = _AHU("\122\009\047\109\002\033\009\088\109")
_XGrC.Description = _AHU("\122\109\105\083\122\009\047\109\002\033\009\088\109\083\007\109\105\083\068\109\105\043\045\030\039\090\109\043\043\109\039\047\109\033\083\078\067\105\043\045\030\090\033\017\043\007\009\047\109\033")
_XGrC.Visible = true
_XGrC.Media = _U2ru
_XGrC.Icon = _U2ru
_XGrC.InputType = "Text"
_XGrC.Text = _AHU("\089\045\030\083\088\090\043\043\083\007\109\033\083\122\009\047\109\002\033\009\088\109\033\083\007\109\105\083\122\009\047\109\033\083\109\002\033\017\109\048\109\033\114\083\122\009\043\083\059\002\105\007\083\002\030\088\083\007\002\109\083\122\009\047\109\033\083\030\067\045\030\039\009\007\109\033\083\090\033\007\083\059\002\105\083\051\067\109\033\033\109\033\083\043\002\109\083\009\033\009\039\037\043\002\109\105\109\033\114\052\016\027\084\096\062\002\033\047\036\083\076\002\033\051\043\083\002\033\083\007\109\105\083\049\122\083\062\031\039\039\109\083\002\043\047\083\109\002\033\083\057\027\028\055\067\007\109\004\083\105\109\045\030\047\043\083\007\109\105\083\122\009\047\109\002\033\009\088\109\114\083\118\043\083\109\099\002\043\047\002\109\105\047\083\051\109\002\033\109\083\120\030\037\043\002\043\045\030\109\083\049\122\028\032\009\105\047\109\114\066")
__c1A2 = Wherigo.ZInput(_64T)
__c1A2.Id = "0071dad2-4c3c-46e3-95db-6eb8d700bfb4"
__c1A2.Name = _AHU("\025\033\047\002\068\002\105\090\043\122\029\025")
__c1A2.Description = _AHU("\029\090\105\083\088\002\047\083\007\109\105\083\105\002\045\030\047\002\017\109\033\083\122\029\025\028\049\109\072\090\109\033\022\083\002\043\047\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\059\002\105\051\043\009\088\114")
__c1A2.Visible = true
__c1A2.Media = _C0t
__c1A2.Icon = _C0t
__c1A2.InputType = "Text"
__c1A2.Text = _AHU("\029\090\105\083\088\002\047\083\007\109\105\083\105\002\045\030\047\002\017\109\033\083\122\029\025\028\049\109\072\090\109\033\022\083\002\043\047\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\059\002\105\051\043\009\088\114\083\093\002\109\083\039\009\090\047\109\047\083\043\002\109\083\033\090\105\031\052\016\027\084\096\062\002\033\047\036\083\122\109\105\083\025\090\104\051\039\109\048\109\105\083\088\002\047\083\007\109\105\083\063\109\047\105\002\043\045\030\009\039\109\083\051\009\033\033\083\068\109\105\043\045\030\059\090\033\007\109\033\083\043\109\002\033\114\083\049\090\045\030\109\083\022\090\105\083\029\067\047\083\007\109\033\083\017\109\043\045\030\105\002\109\048\109\033\109\033\083\062\002\033\047\010\066")
_xHYwG = Wherigo.ZInput(_64T)
_xHYwG.Id = "d899f02a-af94-44da-bb0b-596534a1fb87"
_xHYwG.Name = _AHU("\121\002\105\090\043\122\029\025")
_xHYwG.Description = _AHU("\122\002\109\083\122\029\025\083\049\109\072\090\109\033\022\083\007\109\043\083\121\002\105\090\043\083\115\009\048\045\115")
_xHYwG.Visible = true
_xHYwG.Media = _3do
_xHYwG.Icon = _3do
_xHYwG.InputType = "Text"
_xHYwG.Text = _AHU("\089\045\030\083\088\090\043\043\083\007\002\109\083\122\029\025\028\049\109\072\090\109\033\022\083\007\109\043\083\121\002\105\090\043\083\109\002\033\017\109\048\109\033\083\090\088\083\109\043\083\009\090\104\022\090\030\009\039\047\109\033\010\052\016\027\084\096\062\002\033\047\036\083\122\109\105\083\025\090\104\051\039\109\048\109\105\083\088\002\047\083\007\109\105\083\063\109\047\105\002\043\045\030\009\039\109\083\051\009\033\033\083\068\109\105\043\045\030\059\090\033\007\109\033\083\043\109\002\033\114\083\049\090\045\030\109\083\022\090\105\083\029\067\047\083\007\109\033\083\017\109\043\045\030\105\002\109\048\109\033\109\033\083\062\002\033\047\010\066")

-- WorksWithList for object commands --

-- functions --
function _64T:OnStart()
end
function _64T:OnRestore()
end
function _83W:OnEnter()
	_0iMVd = _AHU("\020\074\019\093")
	_n92:Start()
end
function _83W:OnExit()
	_0iMVd = _AHU("\020\074\019\093")
	_n92:Stop()
end
function _uK1F:OnEnter()
	_0iMVd = _AHU("\020\090\032\070\078")
	_274E()
end
function _uK1F:OnProximity()
	_0iMVd = _AHU("\020\090\032\070\078")
	_274E()
end
function _V0sK:OnEnter()
	_0iMVd = _AHU("\020\121\042\043\032")
	_zuWn.Visible = false
	_zuWn.Active = false
	_zuWn.Complete = false
	_uK1F.Active = false
	_uK1F.Visible = false
	_gpW3 = _6d9V
	_WpD()
end
function _V0sK:OnExit()
	_0iMVd = _AHU("\020\121\042\043\032")
	_pwd:Stop()
end
function _010Ld:OnEnter()
	_0iMVd = _AHU("\020\042\070\042\076\007")
	_lg_q()
end
function _9jxK:OnEnter()
	_0iMVd = _AHU("\020\005\041\099\032")
	if _dOKW == false then
		_dOKW = true
		_hm_P()
		_pCal7:Start()
		_66mD:Start()
		_Urwigo.Dialog(false, {
			{
				Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
				Media = _f5Fh, 
				Buttons = {
					_AHU("\009\033\033\109\030\088\109\033"), 
					_AHU("\009\048\039\109\030\033\109\033")
				}
			}
		}, function(action)
			if (action == "Button1") == true then
				Wherigo.PlayAudio(_M_jHw)
				_Urwigo.MessageBox{
					Text = _AHU("\121\109\105\033\002\045\030\047\109\083\007\009\043\083\121\002\105\090\043\114\083\122\090\083\030\009\043\047\083\033\002\045\030\047\083\068\002\109\039\083\116\109\002\047\010\083\118\043\083\105\109\009\017\002\109\105\047\083\043\047\009\105\051\083\009\090\104\083\110\121\028\076\002\045\030\047\114\083\110\033\007\083\007\109\033\051\109\083\007\009\105\009\033\004\083\007\002\109\083\122\029\025\028\049\109\072\090\109\033\022\083\002\043\047\083\059\002\045\030\047\002\017\114")
				}
			else
				_Urwigo.OldDialog{
					{
						Text = _AHU("\122\090\083\002\017\033\067\105\002\109\105\043\047\083\007\009\043\083\032\039\002\033\017\109\039\033\083\122\109\002\033\109\043\083\119\109\039\109\104\067\033\043\114\114\114")
					}
				}
			end
		end)
		_mCde.Active = true
		_mCde.Visible = true
	else
	end
end
function _Qj3:OnEnter()
	_0iMVd = _AHU("\020\057\041\019")
	_lg_q()
end
function _n8_p:OnEnter()
	_0iMVd = _AHU("\020\033\074\020\120")
	_lg_q()
end
function _D_eH:OnSetComplete()
	_gpW3 = _tZZ
end
function _n7ZZ:OnSetComplete()
	_gpW3 = _gI33g
end
function _n7ZZ:OnClick()
	Wherigo.PlayAudio(_250p)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(_XGrC)
	end)
end
function _zuWn:OnClick()
	_Urwigo.Dialog(false, {
		{
			Text = _AHU("\089\045\030\083\088\090\043\043\083\088\002\105\083\090\109\048\109\105\039\109\017\109\033\004\083\006\105\114\083\056\067\030\033\043\067\033\083\009\033\022\090\105\090\104\109\033\083\090\033\007\083\002\030\088\083\068\067\033\083\007\109\088\083\119\105\109\104\104\109\033\083\088\002\047\083\007\109\088\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\083\022\090\048\109\105\002\045\030\047\109\033\114\083\093\109\033\033\083\002\045\030\083\007\009\043\083\088\009\045\030\109\004\083\059\002\105\007\083\109\105\083\007\009\033\033\083\009\039\039\109\043\083\093\109\002\047\109\105\109\083\109\002\033\105\002\045\030\047\109\033\114\083\006\009\017\083\043\109\002\033\004\083\007\009\043\043\083\007\002\109\083\009\090\045\030\083\033\090\105\083\063\105\067\104\002\039\047\083\009\090\043\083\009\039\039\109\088\083\049\045\030\039\009\017\109\033\004\083\009\048\109\105\083\002\088\088\109\105\030\002\033\083\002\043\047\083\109\043\083\007\009\033\033\083\033\002\045\030\047\083\088\109\030\105\083\088\109\002\033\109\083\025\090\104\017\009\048\109\114\114\114"), 
			Media = _CZOB, 
			Buttons = {
				_AHU("\025\033\105\090\104\109\033"), 
				_AHU("\029\002\045\030\047\083\009\033\105\090\104\109\033")
			}
		}
	}, function(action)
		if (action == "Button1") == true then
			_Urwigo.MessageBox{
				Text = _AHU("\089\045\030\083\007\009\033\051\109\083\089\030\033\109\033\114\083\089\045\030\083\088\090\043\043\083\017\109\043\047\109\030\109\033\004\083\002\045\030\083\030\009\047\047\109\083\022\090\109\105\043\047\083\088\109\002\033\109\083\116\059\109\002\104\109\039\004\083\059\009\043\083\049\002\109\083\009\033\017\109\030\047\114\083\025\048\109\105\083\017\039\009\090\048\109\033\083\049\002\109\083\088\002\105\004\083\049\002\109\083\030\009\048\109\033\083\007\009\043\083\027\002\045\030\047\002\017\109\083\017\109\047\009\033\083\090\033\007\083\007\109\105\083\006\109\033\043\045\030\030\109\002\047\083\109\002\033\109\033\083\017\105\067\043\043\109\033\083\122\002\109\033\043\047\083\109\105\059\002\109\043\109\033\010\083\076\009\043\043\109\033\083\049\002\109\083\088\002\045\030\083\088\109\002\033\109\083\122\009\033\051\048\009\105\051\109\002\047\083\022\090\088\083\025\090\043\007\105\090\045\051\083\048\105\002\033\017\109\033\114\083\093\002\105\083\059\109\105\007\109\033\083\109\002\033\109\083\051\039\109\002\033\109\083\115\016\109\039\067\030\033\090\033\017\115\083\104\031\105\083\049\002\109\083\068\067\105\048\109\105\109\002\047\109\033\114\083\032\067\088\088\109\033\083\049\002\109\083\022\090\083\007\109\033\083\009\033\017\109\017\109\048\109\033\109\033\083\032\067\067\105\007\002\033\009\047\109\033\114\083\025\045\030\004\083\090\033\007\083\033\067\045\030\083\109\047\059\009\043\114\114\114\083\002\045\030\083\059\109\002\043\043\083\089\030\105\109\083\025\105\048\109\002\047\083\043\109\030\105\083\022\090\083\043\045\030\009\109\047\022\109\033\114\083\079\109\105\009\007\109\083\041\109\047\022\047\083\059\109\105\007\109\033\083\059\002\105\083\047\009\047\051\105\009\109\104\047\002\017\109\043\083\063\109\105\043\067\033\009\039\083\048\109\033\067\109\047\002\017\109\033\114\083\089\045\030\083\088\067\109\045\030\047\109\083\049\002\109\083\017\109\105\033\109\083\002\033\083\088\109\002\033\109\088\083\119\109\009\088\083\059\002\043\043\109\033\114\083\122\109\033\051\109\033\083\049\002\109\083\007\009\105\090\109\048\109\105\083\033\009\045\030\010\083\079\067\047\047\083\043\045\030\090\109\047\022\109\083\049\002\109\010"), 
				Media = _CZOB, 
				Buttons = {
					_AHU("\009\090\104\039\109\017\109\033")
				}
			}
			Wherigo.PlayAudio(_qMp)
			_zuWn.Complete = true
			_zuWn.Active = false
			_zuWn.Visible = false
			_woPlL.Visible = true
			_woPlL.Active = true
			_woPlL.Visible = true
			_010Ld.Visible = true
			_010Ld.Active = true
			_V0sK.Active = false
			_V0sK.Visible = false
			_gpW3 = _vgC9t
		else
			_gpW3 = _HgE0
		end
		_64T:RequestSync()
	end)
end
function _mCde:OnClick()
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(_xHYwG)
	end)
end
function _HMlVW:OnClick()
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(__c1A2)
	end)
end
function _XGrC:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if _Urwigo.Hash(string.lower(input)) == 56054 then
		_64T:RequestSync()
		_Urwigo.MessageBox{
			Text = _AHU("\089\045\030\083\030\009\048\109\083\007\002\109\083\122\009\047\109\033\083\109\105\104\067\039\017\105\109\002\045\030\083\030\067\045\030\017\109\039\009\007\109\033\114\114\114\083\056\109\047\022\047\083\088\090\043\043\083\109\105\083\043\002\109\083\033\090\105\083\033\067\045\030\083\109\033\047\043\045\030\039\090\109\043\043\109\039\033\114\083\122\009\033\033\083\051\067\109\033\033\109\033\083\059\002\105\083\009\033\083\109\002\033\109\088\083\079\109\017\109\033\088\002\047\047\109\039\083\009\105\048\109\002\047\109\033\114")
		}
		Wherigo.PlayAudio(_md3)
		_n7ZZ.Active = false
		_n7ZZ.Visible = false
		_n7ZZ.Complete = true
		_6HJvw:Start()
	elseif _Urwigo.Hash(string.lower(input)) == 14155 then
		_64T:RequestSync()
		_Urwigo.MessageBox{
			Text = _AHU("\089\045\030\083\030\009\048\109\083\007\002\109\083\122\009\047\109\033\083\109\105\104\067\039\017\105\109\002\045\030\083\030\067\045\030\017\109\039\009\007\109\033\114\114\114\083\056\109\047\022\047\083\088\090\043\043\083\109\105\083\043\002\109\083\033\090\105\083\033\067\045\030\083\109\033\047\043\045\030\039\090\109\043\043\109\039\033\114\083\122\009\033\033\083\051\067\109\033\033\109\033\083\059\002\105\083\009\033\083\109\002\033\109\088\083\079\109\017\109\033\088\002\047\047\109\039\083\009\105\048\109\002\047\109\033\114")
		}
		Wherigo.PlayAudio(_md3)
		_n7ZZ.Active = false
		_n7ZZ.Visible = false
		_n7ZZ.Complete = true
		_6HJvw:Start()
	else
		_Urwigo.MessageBox{
			Text = _AHU("\029\109\002\033\004\083\068\109\105\104\039\002\099\047\004\083\007\009\043\083\043\002\033\007\083\033\002\045\030\047\083\007\002\109\083\105\002\045\030\047\002\017\109\033\083\122\009\047\109\033\114\083\089\045\030\083\088\090\043\043\083\109\043\083\059\109\002\047\109\105\083\068\109\105\043\090\045\030\109\033\114\083\122\002\109\083\116\109\002\047\083\039\009\109\090\104\047\114")
		}
		Wherigo.PlayAudio(_RbK)
	end
	Wherigo.Command "StopSound"
end
function __c1A2:OnGetInput(input)
	if input == nil then
		input = ""
	end
	_WGVO = input
	if Wherigo.NoCaseEquals(_WGVO, "") then
		return
		
	end
	if Wherigo.NoCaseEquals(_WGVO, _AHU("\017\009\047\047\009\045\009")) then
		Wherigo.PlayAudio(_wrD7u)
		_V0sK.Active = false
		_V0sK.Visible = false
		_HMlVW.Complete = true
		_HMlVW.Active = false
		_HMlVW.Visible = false
		_9jxK.Active = true
		_9jxK.Visible = true
		_gpW3 = _ErB5
		_FQNs.Visible = true
		_64T:RequestSync()
	else
		Wherigo.PlayAudio(_CKx)
	end
end
function _xHYwG:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if _Urwigo.Hash(string.lower(input)) == 53079 then
		_pCal7:Stop()
	else
		_Urwigo.MessageBox{
			Text = _AHU("\122\029\025\083\006\090\043\047\109\105\083\043\047\002\088\088\047\083\033\002\045\030\047\083\031\048\109\105\109\002\033\010")
		}
	end
end
function _sjR:OnTick()
	if _1MJv.Complete == false then
		_hm_P()
		_Urwigo.Dialog(false, {
			{
				Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
				Media = _f5Fh, 
				Buttons = {
					_AHU("\009\033\033\109\030\088\109\033"), 
					_AHU("\009\048\039\109\030\033\109\033")
				}
			}
		}, function(action)
			if (action == "Button1") == true then
				Wherigo.PlayAudio(_xvaq)
				_Urwigo.MessageBox{
					Text = _AHU("\089\045\030\083\017\105\090\109\043\043\109\083\049\002\109\010\083\006\109\002\033\109\083\029\009\088\109\083\002\043\047\083\056\067\030\033\043\067\033\114\083\052\016\027\084\093\002\105\083\030\009\048\109\033\083\109\002\033\083\017\109\088\109\002\033\043\009\088\109\043\083\116\002\109\039\114\083\122\009\043\083\121\002\105\090\043\083\022\090\083\043\047\067\120\120\109\033\114\083\089\045\030\083\009\105\048\109\002\047\109\083\002\088\083\025\090\104\047\105\009\017\083\007\109\105\083\116\109\090\043\083\089\033\045\114\083\118\002\033\083\032\067\033\051\090\105\105\109\033\022\090\033\047\109\105\033\109\030\088\109\033\004\083\104\090\109\105\083\041\109\033\109\004\083\007\002\109\083\007\002\109\043\109\043\083\121\002\105\090\043\083\033\067\045\030\083\030\109\090\047\109\083\029\009\045\030\047\083\104\105\109\002\043\109\047\022\109\033\083\059\109\105\007\109\033\114\083\006\109\002\033\109\033\083\089\033\104\067\105\088\009\047\002\067\033\109\033\083\022\090\104\067\039\017\109\083\009\105\048\109\002\047\109\033\083\049\002\109\083\088\002\047\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\083\022\090\043\009\088\088\109\033\114\083\118\105\083\030\009\047\083\109\002\033\083\079\109\017\109\033\088\002\047\047\109\039\114\083\122\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\059\002\105\007\083\002\030\033\109\033\083\009\048\109\105\083\033\002\045\030\047\043\083\033\090\109\047\022\109\033\114\083\079\039\009\090\048\109\033\083\049\002\109\083\088\002\105\114\083\118\002\033\083\110\033\047\109\105\033\109\030\088\109\033\083\059\002\109\083\007\002\109\083\063\105\067\088\109\047\030\109\090\043\083\055\067\105\120\114\083\030\009\047\083\002\088\088\109\105\083\109\002\033\109\033\083\063\039\009\033\083\016\114\083\049\002\109\083\051\067\109\033\033\109\033\083\017\109\017\109\033\083\109\002\033\083\006\090\039\047\002\088\002\039\039\002\009\105\007\109\033\028\043\045\030\059\109\105\109\043\083\110\033\047\109\105\033\109\030\088\109\033\083\033\002\045\030\047\083\017\109\059\002\033\033\109\033\114\083\093\002\105\083\043\045\030\067\033\010\083\052\016\027\084\076\002\109\104\109\105\033\083\049\002\109\083\090\033\043\083\007\109\033\083\089\033\104\067\105\088\009\033\047\109\033\083\009\090\043\004\083\007\009\033\033\083\009\105\048\109\002\047\109\033\083\059\002\105\083\088\002\047\083\002\030\088\083\022\090\043\009\088\088\109\033\083\090\033\007\083\120\105\067\007\090\022\002\109\105\109\033\083\109\002\033\083\079\109\017\109\033\088\002\047\047\109\039\114\083\052\016\027\084\016\109\017\109\048\109\033\083\049\002\109\083\043\002\045\030\083\002\033\083\007\002\109\083\029\009\109\030\109\083\043\109\002\033\109\105\083\093\067\030\033\090\033\017\114\083\118\105\083\059\002\105\007\083\043\002\045\030\083\059\002\109\007\109\105\083\048\109\002\083\089\030\033\109\033\083\088\109\039\007\109\033\114\083\093\109\033\033\083\109\105\083\007\009\043\083\047\090\047\004\083\043\009\017\109\033\083\049\002\109\083\090\033\043\083\048\109\043\045\030\109\002\007\004\083\059\002\105\083\109\105\039\109\007\002\017\109\033\083\007\109\033\083\027\109\043\047\114\083\122\109\033\051\109\033\083\049\002\109\083\007\009\105\090\109\048\109\105\083\033\009\045\030\010\083\029\090\105\083\088\002\047\083\090\033\043\083\030\009\048\109\033\083\049\002\109\083\109\002\033\109\083\055\030\009\033\045\109\010\083"), 
					Media = _CZOB, 
					Buttons = {
						_AHU("\093\109\002\047\109\105\010")
					}
				}
				_1MJv.Complete = true
				_Ec3.Active = true
				_Ec3.Visible = true
				_gTjnp.Active = false
				_gTjnp.Visible = false
				_uK1F.Active = true
				_uK1F.Visible = true
				_Ec3.Complete = false
				_gpW3 = _sFi3H
			else
				_Urwigo.OldDialog{
					{
						Text = _AHU("\122\090\083\002\017\033\067\105\002\109\105\043\047\083\007\009\043\083\032\039\002\033\017\109\039\033\083\122\109\002\033\109\043\083\119\109\039\109\104\067\033\043\114\114\114")
					}
				}
				_sjR:Start()
			end
		end)
	else
	end
end
function _NCS:OnTick()
	_274E()
	_gpW3 = _NhEiR
end
function _pCal7:OnStop()
	_66mD:Stop()
	_64T:RequestSync()
	_hm_P()
	_mCde.Active = false
	_mCde.Visible = false
	_1la.Active = true
	_1la.Visible = true
	_Urwigo.Dialog(false, {
		{
			Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
			Media = _f5Fh, 
			Buttons = {
				_AHU("\009\033\033\109\030\088\109\033")
			}
		}
	}, function(action)
		Wherigo.PlayAudio(_4rK)
		_Urwigo.MessageBox{
			Text = _AHU("\079\067\047\047\083\043\109\002\083\122\009\033\051\010\052\016\027\084\122\009\043\083\121\002\105\090\043\083\002\043\047\083\068\109\105\033\002\045\030\047\109\047\083\059\067\105\007\109\033\114\083\122\002\109\083\006\109\033\043\045\030\030\109\002\047\083\030\009\047\083\033\067\045\030\083\109\002\033\109\083\055\030\009\033\045\109\114\114\114\083\068\067\105\109\105\043\047\010\083\025\048\109\105\083\017\109\105\009\007\109\083\041\109\047\022\047\083\048\105\009\090\045\030\047\083\109\043\083\041\109\007\109\033\083\062\109\039\007\109\033\114\052\016\027\084\089\045\030\083\088\090\043\043\083\032\067\033\047\009\051\047\083\088\002\047\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\083\009\090\104\033\109\030\088\109\033\114\083\118\043\083\017\002\048\047\083\007\009\083\007\002\109\043\109\033\083\047\067\047\109\033\083\016\105\002\109\104\051\009\043\047\109\033\114\114\114"), 
			Media = _C0t
		}
	end)
	_n8_p.Active = true
	_n8_p.Visible = true
	_9jxK.Active = false
	_9jxK.Visible = false
	_gpW3 = _sMOxN
end
function _pCal7:OnTick()
	_64T:RequestSync()
	_mCde.Active = false
	_mCde.Visible = false
	_1Ow.Active = true
	_1Ow.Visible = true
	Wherigo.PlayAudio(_Xjl)
	_Urwigo.Dialog(false, {
		{
			Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
			Media = _f5Fh, 
			Buttons = {
				_AHU("\009\033\033\109\030\088\109\033"), 
				_AHU("\009\048\039\109\030\033\109\033")
			}
		}
	}, function(action)
		if (action == "Button1") == true then
			Wherigo.PlayAudio(_mWf0o)
			_Urwigo.MessageBox{
				Text = _AHU("\121\109\105\104\039\090\045\030\047\004\083\109\043\083\002\043\047\083\022\090\083\043\120\009\109\047\114\114\114\083\009\048\109\105\083\109\043\083\017\002\048\047\083\033\067\045\030\083\062\067\104\104\033\090\033\017\114\052\016\027\084\122\002\109\083\093\109\039\047\083\048\105\009\090\045\030\047\083\017\109\105\009\007\109\083\041\109\047\022\047\083\017\090\047\109\083\119\105\067\090\048\039\109\043\030\067\067\047\109\105\010\052\016\027\084\089\045\030\083\088\090\043\043\083\032\067\033\047\009\051\047\083\088\002\047\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\083\009\090\104\033\109\030\088\109\033\114\083\118\043\083\017\002\048\047\083\007\009\083\007\002\109\043\109\033\083\047\067\047\109\033\083\016\105\002\109\104\051\009\043\047\109\033\114\114\114"), 
				Media = _3do
			}
		else
			_Urwigo.OldDialog{
				{
					Text = _AHU("\122\090\083\002\017\033\067\105\002\109\105\043\047\083\007\009\043\083\032\039\002\033\017\109\039\033\083\122\109\002\033\109\043\083\119\109\039\109\104\067\033\043\114\114\114")
				}
			}
		end
	end)
	_Qj3.Active = true
	_Qj3.Visible = true
	_9jxK.Active = false
	_9jxK.Visible = false
	_gpW3 = _UJqko
end
function _66mD:OnTick()
	_hm_P()
	_Urwigo.Dialog(false, {
		{
			Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
			Media = _f5Fh, 
			Buttons = {
				_AHU("\009\033\033\109\030\088\109\033"), 
				_AHU("\009\048\039\109\030\033\109\033")
			}
		}
	}, function(action)
		if (action == "Button1") == true then
			Wherigo.PlayAudio(_rMOm5)
			_Urwigo.MessageBox{
				Text = _AHU("\122\009\043\083\121\002\105\090\043\083\059\002\105\007\083\043\002\045\030\083\009\033\083\109\002\033\109\088\083\067\109\104\104\109\033\047\039\002\045\030\109\033\083\063\039\009\047\022\083\048\109\104\002\033\007\109\033\114\083\089\045\030\083\068\109\105\088\090\047\109\004\083\109\043\083\059\002\105\007\083\009\033\083\109\002\033\109\105\083\093\009\043\043\109\105\072\090\109\039\039\109\083\043\109\002\033\004\083\007\009\088\002\047\083\109\043\083\043\002\045\030\083\043\045\030\033\109\039\039\083\068\109\105\048\105\109\002\047\109\033\083\051\009\033\033\114"), 
				Media = _tLtT, 
				Buttons = {
					_AHU("\067\051\009\037")
				}
			}
		else
			_Urwigo.OldDialog{
				{
					Text = _AHU("\122\090\083\002\017\033\067\105\002\109\105\043\047\083\007\009\043\083\032\039\002\033\017\109\039\033\083\122\109\002\033\109\043\083\119\109\039\109\104\067\033\043\114\114\114")
				}
			}
		end
	end)
end
function _6Cw:OnTick()
	_VIRxo()
end
function _n92:OnTick()
	_Iat4()
end
function _pwd:OnTick()
	_WpD()
end
function _b6yE:OnTick()
	_qaGGH()
end
function _6HJvw:OnTick()
	_sjR:Start()
end
function _h5k:On_DWa1Q(target)
	_6Cw:Start()
end
function _PA9:On_qZ0dC(target)
	_b6yE:Start()
end

-- Urwigo functions --
function _lg_q()
	_PA9.Visible = true
	_Urwigo.Dialog(false, {
		{
			Text = _AHU("\079\039\031\045\051\059\090\033\043\045\030\114\083\122\090\083\030\009\043\047\083\007\009\043\083\109\105\043\047\109\083\032\009\120\002\047\109\039\083\068\067\033\083\063\105\067\088\109\047\030\109\090\043\083\007\090\105\045\030\017\109\043\120\002\109\039\047\114\083\056\109\047\022\047\083\088\090\043\043\047\083\122\090\083\033\090\105\083\033\067\045\030\083\007\109\033\083\055\009\045\030\109\083\104\002\033\007\109\033\083\090\033\007\083\076\067\017\017\109\033\114\052\016\027\084\093\109\033\033\083\122\090\083\002\030\033\083\017\109\104\090\033\007\109\033\083\030\009\043\047\004\083\051\039\002\045\051\109\083\009\090\104\083\067\051\009\037\010"), 
			Media = _U2ru
		}, 
		{
			Text = string.sub(Player.CompletionCode, 1, 15), 
			Media = _uQmi, 
			Buttons = {
				_AHU("\016\109\109\033\007\109\033")
			}
		}
	}, function(action)
		_64T.Complete = true
		_64T:RequestSync()
	end)
end
function _VIRxo()
	_Urwigo.OldDialog{
		{
			Text = _gpW3, 
			Media = _Qch4n
		}
	}
end
function _274E()
	_64T:RequestSync()
	if _Ec3.Complete == false then
		_hm_P()
		_Urwigo.Dialog(false, {
			{
				Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
				Media = _f5Fh, 
				Buttons = {
					_AHU("\009\033\033\109\030\088\109\033"), 
					_AHU("\009\048\039\109\030\033\109\033")
				}
			}
		}, function(action)
			if (action == "Button1") == true then
				Wherigo.PlayAudio(_U9HLq)
				_Urwigo.MessageBox{
					Text = _AHU("\118\043\083\088\109\039\007\109\047\083\043\002\045\030\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\114\083\118\105\083\030\009\047\083\007\002\109\083\122\009\047\109\033\083\109\033\047\043\045\030\039\090\109\043\043\109\039\047\114\083\118\105\083\030\009\047\083\088\002\105\083\007\002\109\083\032\067\067\105\007\002\033\009\047\109\033\083\017\109\017\109\048\109\033\004\083\059\067\083\007\002\109\083\110\109\048\109\105\017\009\048\109\083\007\109\043\083\079\109\017\109\033\088\002\047\047\109\039\043\083\043\047\009\047\047\104\002\033\007\109\033\083\059\002\105\007\114\083\118\105\083\059\002\105\007\083\009\090\045\030\083\007\009\083\043\109\002\033\114\083\093\109\033\033\083\002\045\030\083\007\109\105\083\116\109\090\043\083\089\033\045\114\083\068\109\105\047\105\009\090\109\033\083\059\067\039\039\047\109\004\083\043\067\039\039\047\109\083\002\045\030\083\041\109\047\022\047\083\006\105\114\083\056\067\030\033\043\067\033\083\009\033\105\090\104\109\033\083\090\033\007\083\002\030\088\083\007\009\068\067\033\083\048\109\105\002\045\030\047\109\033\083\048\109\068\067\105\083\009\039\039\109\043\083\022\090\083\068\002\109\039\083\104\090\109\105\083\088\002\045\030\083\059\002\105\007\114\114\114"), 
					Media = _Q7u, 
					Buttons = {
						_AHU("\067\051\009\037")
					}
				}
				_Ec3.Complete = true
				_Ec3.Visible = false
				_uK1F.Active = false
				_uK1F.Visible = false
				_V0sK.Active = true
				_V0sK.Visible = true
				_zuWn.Active = true
				_zuWn.Visible = true
			else
				_Urwigo.OldDialog{
					{
						Text = _AHU("\122\090\083\002\017\033\067\105\002\109\105\043\047\083\007\009\043\083\032\039\002\033\017\109\039\033\083\122\109\002\033\109\043\083\119\109\039\109\104\067\033\043\114\114\114")
					}
				}
				_NCS:Start()
			end
		end)
	else
	end
end
function _WpD()
	if _HMlVW.Complete == false then
		_hm_P()
		_Urwigo.Dialog(false, {
			{
				Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
				Media = _f5Fh, 
				Buttons = {
					_AHU("\009\033\033\109\030\088\109\033"), 
					_AHU("\009\048\039\109\030\033\109\033")
				}
			}
		}, function(action)
			if (action == "Button1") == true then
				Wherigo.PlayAudio(_UGA)
				_Urwigo.MessageBox{
					Text = _AHU("\089\045\030\083\088\090\043\043\083\007\009\043\083\079\109\017\109\033\088\002\047\047\109\039\083\104\002\033\007\109\033\114\083\118\043\083\105\109\009\017\002\109\105\047\083\043\047\009\105\051\083\009\090\104\083\110\121\028\076\002\045\030\047\114\083\122\009\043\083\059\002\105\007\083\088\002\105\083\030\109\039\104\109\033\114\083\119\105\067\047\022\007\109\088\004\083\002\045\030\083\088\090\043\043\083\090\033\009\090\104\104\009\109\039\039\002\017\083\043\109\002\033\114\083\056\109\007\109\105\083\030\002\109\105\083\051\067\109\033\033\047\109\083\104\090\109\105\083\007\002\109\083\063\105\067\088\109\047\030\109\090\043\083\055\067\105\120\114\083\009\105\048\109\002\047\109\033\114"), 
					Buttons = {
						_AHU("\067\051\009\037")
					}
				}
				_HMlVW.Visible = true
				_HMlVW.Active = true
			else
				_Urwigo.OldDialog{
					{
						Text = _AHU("\122\090\083\002\017\033\067\105\002\109\105\043\047\083\007\009\043\083\032\039\002\033\017\109\039\033\083\122\109\002\033\109\043\083\119\109\039\109\104\067\033\043\114\114\114")
					}
				}
				_pwd:Start()
			end
		end)
	end
end
function _Iat4()
	if _D_eH.Complete == false then
		_hm_P()
		_Urwigo.Dialog(false, {
			{
				Text = _AHU("\118\002\033\083\025\033\105\090\104\083\068\067\033\083\109\002\033\109\105\083\090\033\048\109\051\009\033\033\047\109\033\083\029\090\088\088\109\105"), 
				Media = _f5Fh, 
				Buttons = {
					_AHU("\009\033\033\109\030\088\109\033"), 
					_AHU("\009\048\039\109\030\033\109\033")
				}
			}
		}, function(action)
			if (action == "Button1") == true then
				Wherigo.PlayAudio(_yAc4)
				_Urwigo.MessageBox{
					Text = _AHU("\118\033\047\043\045\030\090\039\007\002\017\109\033\083\049\002\109\114\114\114\083\002\045\030\083\048\105\009\090\045\030\109\083\089\030\105\109\083\062\002\039\104\109\010\083\006\109\002\033\083\029\009\088\109\083\002\043\047\083\056\067\030\033\083\079\105\109\109\033\059\002\047\045\030\114\083\089\045\030\083\059\009\105\083\078\067\105\043\045\030\109\105\083\048\109\002\083\007\109\105\083\063\105\067\088\109\047\030\109\090\043\083\055\067\105\120\114\052\016\027\084\093\002\105\083\104\067\105\043\045\030\047\109\033\083\009\033\083\007\109\033\083\017\109\104\009\109\030\105\039\002\045\030\043\047\109\033\083\121\002\105\109\033\083\007\109\105\083\093\109\039\047\114\114\114\083\090\033\007\083\002\045\030\083\104\090\109\105\045\030\047\109\004\083\017\109\033\009\090\083\007\002\109\043\109\083\059\109\105\007\109\033\083\002\030\105\083\077\033\048\043\120\103\110\033\047\109\105\017\009\033\017\083\059\109\105\007\109\033\004\083\059\109\033\033\083\049\002\109\083\033\002\045\030\047\083\030\109\039\104\109\033\010\052\016\027\084\122\002\109\083\063\105\067\088\109\047\030\109\090\043\083\055\067\105\120\114\083\028\083\007\002\109\043\109\083\017\109\039\007\017\002\109\105\002\017\109\033\083\062\090\033\007\109\114\114\114\083\049\002\109\083\059\109\105\007\109\033\083\007\009\043\083\121\002\105\090\043\083\033\067\045\030\083\030\109\090\047\109\083\029\009\045\030\047\083\104\105\109\002\043\109\047\022\109\033\114\083\089\045\030\083\068\109\105\088\090\047\109\004\083\090\088\083\048\009\039\007\083\109\002\033\083\079\109\017\109\033\088\002\047\047\109\039\083\047\109\090\109\105\083\022\090\083\068\109\105\051\009\090\104\109\033\114\083\025\039\043\083\002\045\030\083\089\030\105\109\033\083\063\039\009\033\083\109\105\051\009\033\033\047\083\030\009\048\109\004\083\088\090\043\043\047\109\083\002\045\030\083\090\033\047\109\105\047\009\090\045\030\109\033\083\090\033\007\083\007\002\109\083\078\067\105\043\045\030\090\033\017\043\007\009\047\109\033\083\068\109\105\043\047\109\045\051\109\033\114\083\049\090\045\030\109\033\083\049\002\109\083\088\109\002\033\109\083\025\090\104\022\109\002\045\030\033\090\033\017\109\033\114\083\029\090\105\083\043\067\083\051\067\109\033\033\109\033\083\059\002\105\083\007\009\043\083\121\002\105\090\043\083\033\067\045\030\083\043\047\067\120\120\109\033\114"), 
					Media = _Xas4
				}
				_D_eH.Complete = true
				_D_eH.Visible = false
				_n7ZZ.Active = true
				_n7ZZ.Visible = true
				_83W.Active = false
				_gTjnp.Active = true
				_gTjnp.Visible = true
			else
				_Urwigo.OldDialog{
					{
						Text = _AHU("\122\090\083\002\017\033\067\105\002\109\105\043\047\083\007\009\043\083\032\039\002\033\017\109\039\033\083\122\109\002\033\109\043\083\119\109\039\109\104\067\033\043\114\114\114")
					}
				}
				_n92:Start()
			end
		end)
	end
end
function _qaGGH()
	_64T.Complete = true
	_Urwigo.MessageBox{
		Text = string.sub(Player.CompletionCode, 1, 15)
	}
	Wherigo.Command "SaveClose"
end
function _hm_P()
	if Wherigo.NoCaseEquals(Env.Platform, _AHU("\121\109\033\007\067\105\083\070\083\025\027\006\005")) then
		Wherigo.PlayAudio(_sD0md)
	else
		Wherigo.PlayAudio(_Xjl)
	end
end

-- Begin user functions --
-- End user functions --
return _64T
