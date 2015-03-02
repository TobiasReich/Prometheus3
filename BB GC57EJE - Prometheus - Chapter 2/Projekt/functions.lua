function dialog(text, media, bt_ok, on_ok)
    _Urwigo.Dialog(false,
        {
            {
                Text = text,
                Media = media,                
                Buttons = {bt_ok}
            }
        },
        function(action)
            if action == "Button1" and on_ok then
                on_ok()
            end
        end
    ) -- Dialog
end

function question(text, media, bt1, bt2, on1, on2)
    _Urwigo.Dialog(false,
        {
            {
                Text = text,
                Media = media,                
                Buttons = {bt1, bt2}
            }
        },
        function(action)
            if action == "Button1" and on1 then
                on1()
            elseif on2 then
                on2()
            end
        end
    ) -- Dialog
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
function incoming_phone_call(
            call_notification,
            call_accept_audio,
            call_accept_alternate_text,
            call_accept_image,
            on_accept,
            call_reject_text,
            on_reject)
    
    phone_ring()
    _Urwigo.Dialog(false,
        {
            {
                Text = call_notification, 
                Media = img_telephone, 
                Buttons = {
                    text_accept, 
                    text_reject
                }
            }
        },
        function(action)
            if action == "Button1" then
                Wherigo.PlayAudio(call_accept_audio)
                dialog(
                    call_accept_alternate_text,
                    call_accept_image,
                    text_ok,
                    on_accept)
            else
                dialog(call_reject_text, nil, text_ok, on_reject)
            end
        end
    ) -- Dialog
end

-- Returns the vertices of a regular polygon
--   center    center of the polygon
--   radius    radius of the polygon in meters (default: 50m)
--   edges     number of edges (default: 5)
--   alpha     angle offset in degrees (default 0°)
function regular_polygon(center, radius, edges, alpha)
    radius = radius or 50
    edges = edges or 5
    alpha = alpha or 0
    local result = {}
    for i = 1, edges do
        result[i] = Wherigo.TranslatePoint(
            center,
            Wherigo.Distance(radius, 'm'),
            360 / edges * i + alpha)
    end
    return result
end
