local api = require("rmp.rmp")

-- GRUVBOX THEME COLORS:
-- Gruvbox is an earthy, warm color scheme with carefully selected colors
-- DARK VARIANT:
-- Title text: Gruvbox Light1 (#EBDBB2) - Brights.White equivalent
-- Title background: Gruvbox Dark0 (#282828) - NoBrights.Black
-- Border color: Gruvbox Light4 (#A89984) - Brights.White
-- Background: Gruvbox Dark0 (#282828) - NoBrights.Black
-- Primary content: Gruvbox Green (#98971A) - NoBrights.Green
-- Secondary content: Gruvbox Blue (#458588) - NoBrights.Blue
-- Accent elements: Gruvbox Red (#CC241D) - NoBrights.Red
-- Highlight: Gruvbox Yellow (#D79921) - NoBrights.Yellow
-- Muted elements: Gruvbox Purple (#B16286) - NoBrights.Magenta

-- LIGHT VARIANT:
-- Title text: Gruvbox Dark1 (#3C3836) - NoBrights.Black
-- Title background: Gruvbox Light0 (#FBF1C7) - Brights.White
-- Border color: Gruvbox Dark4 (#7C6F64) - NoBrights.White
-- Background: Gruvbox Light0 (#FBF1C7) - Brights.White
-- Primary content: Gruvbox Green (#79740E) - NoBrights.Green
-- Secondary content: Gruvbox Blue (#076678) - NoBrights.Blue
-- Accent elements: Gruvbox Red (#9D0006) - NoBrights.Red
-- Highlight: Gruvbox Yellow (#B57614) - NoBrights.Yellow
-- Muted elements: Gruvbox Purple (#8F3F71) - NoBrights.Magenta
--
-- {
--     id = 'main_window',
--     type = "Window",
--     title = {
--         type = "Text",
--         value = "[ Main Window ]",
--         foregroundColor = api.FGColors.Brights.Red,
--         backgroundColor = api.BGColors.NoBrights.Black,
--         dynamic = function(ctx)
--             return "[ " .. os.date("%H:%M:%S") .. " ]"
--         end
--     },
--     width = "2 * (w / 3)+ 2",
--     height = "h - (h - h/1.3)",
--     x = "w/6 + 1 + (w - (w - w/6) - 1)",
--     y = "h/4 + 1",
--     foregroundColor = api.FGColors.Brights.Yellow,
--     -- backgroundColor = api.BGColors.NoBrights.Black,
--     border = api.BoxDrawing.RoundedCorners,
--
-- },

local VARIANT = "dark"

local gruvbox = {
    dark = {
        BackGround = "#282828",
        -- BorderColor = "#CC241D",
        BorderColor = "#EBDBB2",
        TitleBackGround = "#282828",
        TitleText = "#EBDBB2",
        PrimaryContent = "#98971A",
        SecondaryContent = "#458588",
        AccentElements = "#A89984",
        Highlight = "#D79921",
        MutedElements = "#B16286"
    },
    light = {
        BackGround = "#FBF1C7",
        BorderColor = "#7C6F64",
        TitleBackGround = "#FBF1C7",
        TitleText = "#3C3836",
        PrimaryContent = "#79740E",
        SecondaryContent = "#076678",
        AccentElements = "#9D0006",
        Highlight = "#B57614",
        MutedElements = "#8F3F71"
    }
}

local function apply(tha_template)
    for _, component in ipairs(tha_template) do
        if component.title then
            if type(component.title) == "string" then
                local val = component.title
                component.title = {
                    value = val,
                    foregroundColor = api.colorFromHex(gruvbox[VARIANT].TitleText, api.FG),
                    backgroundColor = api.colorFromHex(gruvbox[VARIANT].TitleBackGround, api.BG),
                }
            elseif type(component.title) == "table" then
                component.title.foregroundColor = api.colorFromHex(gruvbox[VARIANT].TitleText, api.FG)
                component.title.backgroundColor = api.colorFromHex(gruvbox[VARIANT].TitleBackGround, api.BG)
            else
                ---- unreachable
                component.table = nil
            end
        end
        component.foregroundColor = api.colorFromHex(gruvbox[VARIANT].BorderColor, api.FG)
        component.backgroundColor = api.colorFromHex(gruvbox[VARIANT].BackGround, api.BG)
        if component.children then
            apply(component.children)
        end
    end
end

local vt = api.VirtualTerminal.new(1, 1) -- sins i don't have to render shit
return function()
    -- getting the configurations
    vt:onConfiguration(function(cfg)
        if cfg then
            local conf = cfg:get("gruvbox-theme-rmp")
            if conf and conf.VARIANT then
                -- maybe add more fields to configurations like choose specific window id to apply something
                -- light | dark
                VARIANT = conf.VARIANT
            end
        end
    end)

    -- apply the theme on the template
    vt:onTemplate(function(template)
        if template then
            apply(template)
        end
    end)

    -- share the current theme
    -- all plugins can get the theme and use it as their theme
    vt:addEventListener(api.EventType.TransformDataPut, function()
        return {
            theme = gruvbox[VARIANT]
        }
    end)

    return vt
end
