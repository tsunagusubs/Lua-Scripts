script_name="Scroll text in"
script_description="Displays text letter by letter"
script_author="QSaiki"
script_version="1.0"

include("karaskel.lua")

function scroller(sub, sel)

  --Load head info
  local meta,styles = karaskel.collect_head(sub, false)

  --Loop through each selected subtitle line
  for si,li in ipairs(sel) do
    local line=sub[li]
    local startpoint=0
    --Change this to speed (ms)
    local endpoint=20
    --Change this to change scrolling speed (ms)
    local speed=20
    local switch=true
    local done={}

    --Preprocess line
    karaskel.preproc_line(sub,meta,styles,line)

    --Add a tag for each char in the line text
    line.text:gsub(".", function(c)
      --Turn off autotagging if line section is a tag
      if c == "{" then
        switch=false
      end
      if switch then
        --Ignore spaces
        if c == " " then
          table.insert(done, c)
        else
          local tagged="{\\alpha&HFF&\\t("..startpoint..","..endpoint..",\\alpha&H00&)}"..c
          table.insert(done, tagged)
          startpoint=startpoint+speed
          endpoint=endpoint+speed
        end
      else
        table.insert(done, c)
      end
      --Turn autotagging back on when tag ends
      if c == "}" then
        switch=true
      end
    end)

    --Concatenate all tagged chars
    line.text=table.concat(done)

    --Put line back into the subtitles
    sub[li]=line


  --end for loop
  end

  --Set undo point and maintain selection
	aegisub.set_undo_point(script_name)
	return sel

--end function
end

--Register macro
aegisub.register_macro(script_name,script_description,scroller)
