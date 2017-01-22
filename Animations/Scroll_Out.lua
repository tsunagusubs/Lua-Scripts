script_name="Scroll text out"
script_description="Removes text letter by letter"
script_author="193hime"
script_version="1.0"

include("karaskel.lua")

function scroller(sub, sel)

  --Load head info
  local meta,styles = karaskel.collect_head(sub, false)

  --Loop through each selected subtitle line
  for si,li in ipairs(sel) do
    local line=sub[li]
    --Change this to change scrolling speed (ms)
    local speed=20
    local switch=true
    local done={}

    --Preprocess line
    karaskel.preproc_line(sub,meta,styles,line)

    local startpoint=line.duration-(string.len(line.text_stripped)*20)
    --Change this to speed (ms)
    local endpoint=startpoint+20

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
          local tagged="{\\t("..startpoint..","..endpoint..",\\alpha&HFF&)}"..c
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
