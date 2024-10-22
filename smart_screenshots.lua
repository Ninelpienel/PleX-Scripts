-- Smart Screenshots v2.2 by Nino
-- https://github.com/Ninelpienel/Plex-Scripts

function screenshot()
    local media, file

    timedate = os.date("%Y%m%d_%H.%M.%S")

    dir = mp.get_property_native("screenshot-directory")
    if (string.len(dir) > 0) then dir = dir .. '/' end
    dir = mp.command_native({"expand-path", dir})

    img = mp.get_property_native("screenshot-format")

    media = mp.get_property("user-data/plex/playing-media")

    if media and string.match(media, '"type":"episode"') then
        media_cut = media:sub(media:find('grandparentTitle') + 19, #media)
        title = media_cut:sub(0, media_cut:find('guid') - 4)
        title = title:gsub("[%<%>%:%\"%/\\|%?%*]", "")

        -- Extract episode number
        local epnumber = media_cut:sub(media_cut:find('index') + 7, media_cut:find('key') - 3)
        epnumber = tonumber(epnumber) or 0  -- Default to 0 if nil
        epnumber = string.format("%02d", epnumber)

        -- Debugging output
        print("Episode Number:", epnumber)

        -- Extract season number
        local snumber = tonumber(media_cut:match('"parentIndex":(%d+)') or 0)
        snumber = string.format("%02d", snumber)

        -- Debugging output
        print("Season Number:", snumber)

        -- Get the current position
        local position = mp.get_property_osd("time-pos")
        position = position or "00:00"  -- Default value if position is nil
        positionf = string.gsub(position, "[:]", ".")

        -- Debugging output
        print("Current Position:", positionf)

        -- Take the screenshot
        mp.commandv("screenshot-to-file", dir .. timedate .. "_" .. title .. " - S" .. snumber .. "E" .. epnumber .. " (" .. positionf .. ")." .. img)
        mp.osd_message('Screenshot created!')

    elseif media and string.match(media, '"type":"movie"') then
        -- For movies
        local title = media:match(',"title":"([^"]+)","type"') or media:match(',"title":"([^"]+)","titleSort"')
        title = title:gsub("[%<%>%:%\"%/\\|%?%*]", "")

        -- Get the current position
        local position = mp.get_property_osd("time-pos")
        position = position or "00:00"  -- Default value if position is nil
        positionf = string.gsub(position, "[:]", ".")

        -- Take the screenshot
        mp.commandv("screenshot-to-file", dir .. timedate .. "_" .. title .. " (" .. positionf .. ")." .. img)
        mp.osd_message('Screenshot created!')

    else
        mp.osd_message("No valid media playing.")
    end
    return nil
end

function screenshot_no_subs()
    local media, file

    timedate = os.date("%Y%m%d_%H.%M.%S")

    dir = mp.get_property_native("screenshot-directory")
    if (string.len(dir) > 0) then dir = dir .. '/' end
    dir = mp.command_native({"expand-path", dir})

    img = mp.get_property_native("screenshot-format")

    media = mp.get_property("user-data/plex/playing-media")

    if media and string.match(media, '"type":"episode"') then
        media_cut = media:sub(media:find('grandparentTitle') + 19, #media)
        title = media_cut:sub(0, media_cut:find('guid') - 4)
        title = title:gsub("[%<%>%:%\"%/\\|%?%*]", "")

        epnumber = media_cut:sub(media_cut:find('index') + 7, media_cut:find('key') - 3)
        epnumber = tonumber(epnumber) or 0
        epnumber = string.format("%02d", epnumber)

        -- Debugging output
        print("Episode Number (No Subs):", epnumber)

        snumber = tonumber(media_cut:match('"parentIndex":(%d+)') or 0)
        snumber = string.format("%02d", snumber)

        -- Debugging output
        print("Season Number (No Subs):", snumber)

        position = mp.get_property_osd("time-pos")
        position = position or "00:00"
        positionf = string.gsub(position, "[:]", ".")

        mp.commandv("screenshot-to-file", dir .. timedate .. "_" .. title .. " - S" .. snumber .. "E" .. epnumber .. " (" .. positionf .. ")." .. img, "video")
        mp.osd_message('Screenshot created without subs!')

    elseif media and string.match(media, '"type":"movie"') then
        title = media:match(',"title":"([^"]+)","type"') or media:match(',"title":"([^"]+)","titleSort"')
        title = title:gsub("[%<%>%:%\"%/\\|%?%*]", "")

        position = mp.get_property_osd("time-pos")
        position = position or "00:00"
        positionf = string.gsub(position, "[:]", ".")

        mp.commandv("screenshot-to-file", dir .. timedate .. "_" .. title .. " (" .. positionf .. ")." .. img, "video")
        mp.osd_message('Screenshot created without subs!')

    else
        mp.osd_message("No valid media playing.")
    end
    return nil
end

function qc_screenshot()
    local media, file
    local format = "{\\an8\\fs18\\bord1.2\\c&HFFFFFF&\\3c&H000074&\\b1}"

    timedate = os.date("%Y%m%d_%H.%M.%S")

    dir = mp.get_property_native("screenshot-directory")
    if (string.len(dir) > 0) then dir = dir .. '/' end
    dir = mp.command_native({"expand-path", dir})

    img = mp.get_property_native("screenshot-format")

    qcdir = mp.command_native({"expand-path", dir .. "QC/"})

    media = mp.get_property("user-data/plex/playing-media")

    if media and string.match(media, '"type":"episode"') then
        media_cut = media:sub(media:find('grandparentTitle') + 19, #media)
        title = media_cut:sub(0, media_cut:find('guid') - 4)
        titlef = title:gsub("[%<%>%:%\"%/\\|%?%*]", "")
        epnumber = media_cut:sub(media_cut:find('index') + 7, media_cut:find('key') - 3)
        epnumber = tonumber(epnumber) or 0
        epnumber = string.format("%02d", epnumber)
        
        -- Debugging output
        print("Episode Number (QC):", epnumber)

        snumber = tonumber(media_cut:match('"parentIndex":(%d+)') or 0)
        snumber = string.format("%02d", snumber)

        -- Debugging output
        print("Season Number (QC):", snumber)

        position = mp.get_property_osd("time-pos")
        position = position or "00:00"
        positionf = string.gsub(position, "[:]", ".")

        msg = format .. title .. " – S" .. snumber .. "E" .. epnumber .. " (" .. position .. ")"

        mp.osd_message(mp.get_property_osd("osd-ass-cc/0") .. msg .. mp.get_property_osd("osd-ass-cc/1"), 4)
        mp.add_timeout(0.1, function()
            mp.commandv("screenshot-to-file", qcdir .. timedate .. "_" .. titlef .. " - S" .. snumber .. "E" .. epnumber .. " (" .. positionf .. ")." .. img, "window")
        end)

    elseif media and string.match(media, '"type":"movie"') then
        title = media:match(',"title":"([^"]+)","type"') or media:match(',"title":"([^"]+)","titleSort"')
        titlef = title:gsub("[%<%>%:%\"%/\\|%?%*]", "")

        position = mp.get_property_osd("time-pos")
        position = position or "00:00"
        positionf = string.gsub(position, "[:]", ".")

        msg = format .. title .. " (" .. position .. ")"

        mp.osd_message(mp.get_property_osd("osd-ass-cc/0") .. msg .. mp.get_property_osd("osd-ass-cc/1"), 4)
        mp.add_timeout(0.1, function()
            mp.commandv("screenshot-to-file", qcdir .. timedate .. "_" .. titlef .. " (" .. positionf .. ")." .. img, "window")
        end)
    else
        mp.osd_message("No valid media playing.")
    end
    return nil
end

-- Define your key bindings here.

mp.add_forced_key_binding("1", "screenshot", screenshot)
mp.add_forced_key_binding("2", "screenshot_no_subs", screenshot_no_subs)
mp.add_forced_key_binding("3", "qc_screenshot", qc_screenshot)
