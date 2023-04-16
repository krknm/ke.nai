--[[
~> DEV JABWA ⇿ @JABWA
]] 
function youtube(msg)
text = nil
if msg and msg.content and msg.content.text then
text = msg.content.text.text
end
msg_chat_id = msg.chat_id
msg_id = msg.id
if tonumber(msg.sender_id.user_id) == tonumber(Fast) then
return false
end
if text then
local neww = Redis:get(Fast.."Get:Reides:Commands:Group"..msg.chat_id..":"..text)
if neww then
text = neww or text
end
end
function time_to_sec(time)
    local sec = 0
    local time_table = {}
    for i in string.gmatch(time, "%d+") do
        table.insert(time_table, i)
    end
    local hour = tonumber(time_table[1])
    local min = tonumber(time_table[2])
    local sec = tonumber(time_table[3])
    return hour*3600 + min*60 + sec
end
if text == "تعطيل اليوتيوب" or text == "تعطيل يوتيوب" then
if not msg.Admin then
send(msg_chat_id,msg_id,'*• انت لست ادمن\n√*',"md",true)  
return false 
end
Redis:set(Fast.."yt:lock"..msg.chat_id,true)
send(msg.chat_id,msg.id,'\n*◍ تم تعطيل اليوتيوب\n√*',"md",true)  
end
if text == "تفعيل اليوتيوب" or text == "تفعيل يوتيوب" then
if not msg.Admin then
send(msg_chat_id,msg_id,'*• انت لست ادمن\n√*',"md",true)  
return false 
end
Redis:del(Fast.."yt:lock"..msg.chat_id)
send(msg.chat_id,msg.id,'\n*◍ تم تفعيل اليوتيوب\n√*',"md",true)  
end

if text then
if text:match("^بحث (.*)$") then
if Redis:get(Fast.."yt:lock") or Redis:get(Fast.."yt:lock"..msg.chat_id) then
send(msg.chat_id,msg.id,'*◍ عذرآ اليوتيوب معطل\n√*',"md",true)  
return false 
end
local search = text:match("^بحث (.*)$")
local j = json:decode(http.request("https://youtube-scrape.herokuapp.com/api/search?q="..URL.escape(search)..""))
local datar = {data = {{text = "⌁ قناة السورس ⚡" , url = 'http://t.me/'..chsource..''}}}
for i = 1,6 do
link = j.results[i].video.url
title = j.results[i].video.title
title = title:gsub("/","-") 
title = title:gsub("\n","-") 
title = title:gsub("|","-") 
title = title:gsub("'","-") 
title = title:gsub('"',"-") 
datar[i] = {{text = title , data =msg.sender_id.user_id.."dl/"..link}}
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = datar
}
send(msg.chat_id,msg.id,'*◍ نتائج بحثك لـ» '..search..'\n√*',"md",false, false, false, false, reply_markup)
end
end

if Redis:get(Fast.."youtube"..msg.sender_id.user_id..msg_chat_id) == "mp4" then
local rep = msg.id/2097152/0.5
local m = json:decode(https.request("https://api.telegram.org/bot"..Token.."/sendAnimation?chat_id="..msg_chat_id.."&animation=https://t.me/DEV_MEDOU/31&reply_to_message_id="..rep)).result.message_id
local se = http.request("http://aboelmagd.tk/ban/yotube.php?search="..URL.escape(text))
local Jbanda = JSON.decode(se)
local link = Jbanda.results[1].url
local view = Jbanda.results[1].view
local image = Jbanda.results[1].image
local time = Jbanda.results[1].time
local title = Jbanda.results[1].title 
local title = title:gsub("/","-") 
local title = title:gsub("\n","-") 
local title = title:gsub("|","-") 
local title = title:gsub("'","-") 
local title = title:gsub('"',"-") 
os.execute("yt-dlp "..link.." -f 18 -o '"..title..".mp4'")
bot.sendVideo(msg_chat_id,msg_id,'./'..title..'.mp4',"["..title.."]("..link..")\n⏳time: "..time.." Mins\n👀Views: "..view.." ","md") 
https.request("https://api.telegram.org/bot"..Token.."/deleteMessage?chat_id="..msg_chat_id.."&message_id="..m)
Redis:del(Fast.."youtube"..msg.sender_id.user_id..msg_chat_id)
sleep(1)
os.remove(""..title..".mp4")
end
if text == 'يوتيوب' then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'تحميل صوت 🎵', data = msg.sender_id.user_id..'/mp3'..msg_id}, {text = 'تحميل فيديو 🎥', data = msg.sender_id.user_id..'/mp4'..msg_id}, 
},
}
}
return bot.sendText(msg_chat_id,msg_id, [[*
🛂 | اختار نوع التحميل الي تريده

|  𝐯𝐢𝐝𝐞𝐨 |  𝐦𝐩3 |
*]],"md",false, false, false, false, reply_markup)
end

end
return {Fast = youtube}