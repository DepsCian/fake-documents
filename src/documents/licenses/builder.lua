local ffi = require("ffi")
local Encoding = require("core/encoding")
local Licenses = require("documents/licenses/init")

local Builder = {}

local GRID_SEL = "body > div.documents > div.documents__content.documents__content--license"
    .. " > div > div > div.documents-license__license-grid.svelte-e82vsm"
    .. " > div.documents-license__license.svelte-e82vsm"

local function _buildLicenseJson()
    local s = Licenses.state
    local parts = {}
    for _, item in ipairs(s.items) do
        local enabled = item.enabled[0] and "true" or "false"
        local date = Encoding.u8:decode(ffi.string(item.date))
        table.insert(parts, '"' .. item.id .. '":{"enabled":' .. enabled .. ',"date":"' .. date .. '"}')
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

function Builder.build()
    local json = _buildLicenseJson()
    return [[
const l=document.querySelectorAll("]] .. GRID_SEL .. [[");
const s=]] .. json .. [[;
l.forEach(c=>{
    const i=c.querySelector("i.documents-license__license-icon");
    if(!i)return;
    let t=null;
    for(const cl of i.classList){
        if(cl.startsWith("icon-")){t=cl.replace("icon-","");break}
    }
    if(!t||!s[t])return;
    const n=c.querySelector(".documents-license__license-icon");
    const a=c.querySelector(".documents-license__license-name");
    const e=c.querySelector(".documents-license__license-duration");
    if(s[t].enabled){
        if(n)n.classList.remove("documents-license__license-icon--disabled");
        if(a)a.classList.remove("documents-license__license-name--disabled");
        if(e){
            e.textContent="\u0414\u0435\u0439\u0441\u0442\u0432\u0443\u0435\u0442 \u0434\u043e: "+s[t].date;
            e.classList.remove("documents-license__license-duration--disabled");
        }
    }else{
        if(n)n.classList.add("documents-license__license-icon--disabled");
        if(a)a.classList.add("documents-license__license-name--disabled");
        if(e){
            e.textContent="\u041e\u0442\u0441\u0443\u0442\u0441\u0442\u0432\u0443\u0435\u0442";
            e.classList.add("documents-license__license-duration--disabled");
        }
    }
});
const d=document.querySelector(".documents-license__diplomacy");
if(d&&s.diplomacy){
    const di=d.querySelector(".documents-license__diplomacy-icon");
    const dn=d.querySelector(".documents-license__diplomacy-name");
    const dd=d.querySelector(".documents-license__diplomacy-duration");
    if(s.diplomacy.enabled){
        if(di)di.classList.remove("documents-license__diplomacy-icon--disabled");
        if(dn)dn.classList.remove("documents-license__diplomacy-name--disabled");
        if(dd){
            dd.textContent="\u0414\u0435\u0439\u0441\u0442\u0432\u0443\u0435\u0442 \u0434\u043e: "+s.diplomacy.date;
            dd.classList.remove("documents-license__diplomacy-duration--disabled");
        }
    }else{
        if(di)di.classList.add("documents-license__diplomacy-icon--disabled");
        if(dn)dn.classList.add("documents-license__diplomacy-name--disabled");
        if(dd){
            dd.textContent="\u041e\u0442\u0441\u0443\u0442\u0441\u0442\u0432\u0443\u0435\u0442";
            dd.classList.add("documents-license__diplomacy-duration--disabled");
        }
    }
}]]
end

return Builder
