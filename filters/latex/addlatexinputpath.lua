
function Meta(m)
    local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
    local path = folderOfThisFile .. "../../templates/texinput"
    path = path:gsub("\\", "/")
    m.latex_input_path = path

    return m
end

return {
    { Meta = Meta }
}
