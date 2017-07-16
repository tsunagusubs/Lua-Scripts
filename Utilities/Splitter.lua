script_name="RapidFire"
script_description="Rapidly flashes letters"
script_author="QSaiki"
script_version="1.0"

include("karaskel.lua")
include("utils.lua")

function scroller(sub, sel)

  --Load head info
  local meta,styles = karaskel.collect_head(sub, false)

  --Loop through each selected subtitle line
  for si,li in ipairs(sel) do
    local line=sub[li]
    local tail=li
    local original=line.text

    --Preprocess line
    karaskel.preproc_line(sub,meta,styles,line)

    for word in original:gmatch("%S+") do
          --Increment tail
          tail=tail+1
          --Concatenate all chars
          line.text=word
          sub.insert(tail, line)
    --end nested for loop
    end

    line.text=original
  --end for loop
  end

  --Set undo point and maintain selection
	aegisub.set_undo_point(script_name)
	return sel

--end function
end

--Register macro
aegisub.register_macro(script_name,script_description,scroller)
