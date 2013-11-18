--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:bc1053c49f7bff4a62e5066e7790052a:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- avatar_01
            x=2,
            y=2,
            width=51,
            height=51,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- back_btn
            x=55,
            y=2,
            width=27,
            height=22,

            sourceX = 5,
            sourceY = 1,
            sourceWidth = 41,
            sourceHeight = 25
        },
        {
            -- completed_title
            x=84,
            y=2,
            width=159,
            height=20,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 168,
            sourceHeight = 28
        },
        {
            -- currentgame_title
            x=245,
            y=2,
            width=134,
            height=18,

            sourceX = 2,
            sourceY = 4,
            sourceWidth = 141,
            sourceHeight = 30
        },
        {
            -- green_bar
            x=2,
            y=55,
            width=273,
            height=42,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 277,
            sourceHeight = 46
        },
        {
            -- green_bar_sm
            x=277,
            y=55,
            width=80,
            height=24,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 80,
            sourceHeight = 24
        },
        {
            -- grey_bar
            x=2,
            y=99,
            width=273,
            height=41,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 277,
            sourceHeight = 45
        },
        {
            -- grey_bar_sm
            x=277,
            y=99,
            width=80,
            height=24,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 80,
            sourceHeight = 24
        },
        {
            -- main_header
            x=2,
            y=142,
            width=348,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 347,
            sourceHeight = 103
        },
        {
            -- main_passplay
            x=352,
            y=142,
            width=91,
            height=71,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 95,
            sourceHeight = 75
        },
        {
            -- main_practicemode
            x=2,
            y=244,
            width=91,
            height=71,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 95,
            sourceHeight = 75
        },
        {
            -- main_smartmatch
            x=95,
            y=244,
            width=91,
            height=71,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 94,
            sourceHeight = 75
        },
        {
            -- match_results_header
            x=2,
            y=317,
            width=360,
            height=113,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 360,
            sourceHeight = 113
        },
        {
            -- newgame_title
            x=245,
            y=2,
            width=134,
            height=18,

            sourceX = 2,
            sourceY = 4,
            sourceWidth = 141,
            sourceHeight = 30
        },
        {
            -- play_bar_btn
            x=2,
            y=432,
            width=276,
            height=46,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 276,
            sourceHeight = 47
        },
        {
            -- play_bar_btn_active
            x=2,
            y=480,
            width=327,
            height=51,

            sourceX = 3,
            sourceY = 2,
            sourceWidth = 332,
            sourceHeight = 57
        },
        {
            -- play_header
            x=2,
            y=533,
            width=360,
            height=35,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 360,
            sourceHeight = 35
        },
        {
            -- red_bar
            x=2,
            y=570,
            width=273,
            height=41,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 276,
            sourceHeight = 45
        },
        {
            -- red_bar_sm
            x=277,
            y=570,
            width=80,
            height=24,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 80,
            sourceHeight = 24
        },
        {
            -- rematch_btn
            x=359,
            y=570,
            width=147,
            height=35,

            sourceX = 5,
            sourceY = 1,
            sourceWidth = 156,
            sourceHeight = 43
        },
        {
            -- rematch_btn_active
            x=2,
            y=613,
            width=162,
            height=37,

            sourceX = 5,
            sourceY = 2,
            sourceWidth = 172,
            sourceHeight = 47
        },
        {
            -- resign_btn
            x=166,
            y=613,
            width=147,
            height=35,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 156,
            sourceHeight = 40
        },
        {
            -- resign_btn_active
            x=315,
            y=613,
            width=162,
            height=38,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 171,
            sourceHeight = 44
        },
        {
            -- settings_btn
            x=479,
            y=613,
            width=27,
            height=28,

            sourceX = 12,
            sourceY = 1,
            sourceWidth = 43,
            sourceHeight = 31
        },
        {
            -- settings_btn_active
            x=2,
            y=653,
            width=30,
            height=30,

            sourceX = 13,
            sourceY = 2,
            sourceWidth = 47,
            sourceHeight = 35
        },
        {
            -- their_turn_title
            x=34,
            y=653,
            width=170,
            height=19,

            sourceX = 2,
            sourceY = 4,
            sourceWidth = 193,
            sourceHeight = 31
        },
        {
            -- tile_base
            x=206,
            y=653,
            width=64,
            height=65,

            sourceX = 6,
            sourceY = 5,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_base_sel
            x=272,
            y=653,
            width=64,
            height=64,

            sourceX = 6,
            sourceY = 6,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_dl
            x=338,
            y=653,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_dl_sel
            x=410,
            y=653,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_dw
            x=2,
            y=724,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_dw_sel
            x=74,
            y=724,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_tl
            x=146,
            y=724,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_tl_sel
            x=218,
            y=724,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_tw
            x=290,
            y=724,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- tile_tw_sel
            x=362,
            y=724,
            width=70,
            height=69,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- word_bar
            x=2,
            y=795,
            width=320,
            height=50,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 49
        },
        {
            -- your_turn_title
            x=324,
            y=795,
            width=146,
            height=19,

            sourceX = 8,
            sourceY = 6,
            sourceWidth = 160,
            sourceHeight = 33
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["avatar_01"] = 1,
    ["back_btn"] = 2,
    ["completed_title"] = 3,
    ["currentgame_title"] = 4,
    ["green_bar"] = 5,
    ["green_bar_sm"] = 6,
    ["grey_bar"] = 7,
    ["grey_bar_sm"] = 8,
    ["main_header"] = 9,
    ["main_passplay"] = 10,
    ["main_practicemode"] = 11,
    ["main_smartmatch"] = 12,
    ["match_results_header"] = 13,
    ["newgame_title"] = 14,
    ["play_bar_btn"] = 15,
    ["play_bar_btn_active"] = 16,
    ["play_header"] = 17,
    ["red_bar"] = 18,
    ["red_bar_sm"] = 19,
    ["rematch_btn"] = 20,
    ["rematch_btn_active"] = 21,
    ["resign_btn"] = 22,
    ["resign_btn_active"] = 23,
    ["settings_btn"] = 24,
    ["settings_btn_active"] = 25,
    ["their_turn_title"] = 26,
    ["tile_base"] = 27,
    ["tile_base_sel"] = 28,
    ["tile_dl"] = 29,
    ["tile_dl_sel"] = 30,
    ["tile_dw"] = 31,
    ["tile_dw_sel"] = 32,
    ["tile_tl"] = 33,
    ["tile_tl_sel"] = 34,
    ["tile_tw"] = 35,
    ["tile_tw_sel"] = 36,
    ["word_bar"] = 37,
    ["your_turn_title"] = 38,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
