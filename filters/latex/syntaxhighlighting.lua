function CodeBlock(block)


    if block.attributes["fontsize"] ~=nil then
        return {
            pandoc.RawInline("latex", "\\renewcommand{\\pandoccodeblockfontsize}{\\"..block.attributes["fontsize"].."}"),
            block,
            pandoc.RawInline("latex", "\\renewcommand{\\pandoccodeblockfontsize}{\\normalsize}")
        }
    end
    return block
end