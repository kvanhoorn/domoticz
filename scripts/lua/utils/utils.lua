--[[

    This file is included in every script
    it sets some short named variables and has some functions

]]--

t = timeofday
g = globalvariables

u = uservariables
cu = uservariablechanged
ul = uservariables_lastupdate

c = devicechanged

d = otherdevices
ds = otherdevices_svalues
dl = otherdevices_lastupdate
du = otherdevices_utility
di = otherdevices_idx

dom_ip    = '192.168.0.58'
dom_port  = '8080'
dom_full  = 'http://' .. dom_ip .. ':' .. dom_port
dom_api   = dom_full .. '/json.htm?'

-- the vardump for logfile (recursive print)
function vardump(value)
  serpent = (loadfile '/home/pi/domoticz/scripts/lua/utils/serpent.lua')()
  print(serpent.block(value, {comment=false}))
end


-- return time difference till now in seconds
function time_difference(s)
   td_year = string.sub(s, 1, 4)
   td_month = string.sub(s, 6, 7)
   td_day = string.sub(s, 9, 10)
   td_hour = string.sub(s, 12, 13)
   td_minutes = string.sub(s, 15, 16)
   td_seconds = string.sub(s, 18, 19)
   t1 = os.time()
   t2 = os.time{year=td_year, month=td_month, day=td_day, hour=td_hour, min=td_minutes, sec=td_seconds}
   difference = os.difftime (t1, t2)
   return difference
end

function get_now()
   return os.date("%Y-%m-%d %H:%M:%S")
end

function timestamp_to_date(inp)
    return os.date("%Y-%m-%d %H:%M:%S", inp)
end

-- split by given seperator
function string:split(sep)

  local sep, fields = sep or ":", {}
  local pattern = string.format("([^"..sep.."]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields

end

function join(tbl, glue)

  local glue, str = glue or ":", ""
  str = table.concat(tbl, glue)
  return str

end

-- floor or ceil depending on first decimal
function round(x)
  x = tonumber(x)
  return x >= 0 and math.floor(x+.5) or math.ceil(x-.5)
end