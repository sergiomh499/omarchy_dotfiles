return {
  {
    "omacom-io/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#080201",
        dark_bg    = "#060201",
        darker_bg  = "#040101",
        lighter_bg = "#211b1a",

        fg         = "#eedff1",
        dark_fg    = "#b3a7b5",
        light_fg   = "#f1e4f3",
        bright_fg  = "#f2e7f5",
        muted      = "#69625f",

        red        = "#c65b4a",
        yellow     = "#dd8c33",
        orange     = "#cf7465",
        green      = "#d17f27",
        cyan       = "#4fa0ee",
        blue       = "#6181da",
        purple     = "#ad6bbe",
        brown      = "#7c463d",

        bright_red    = "#f67c65",
        bright_yellow = "#ffb135",
        bright_green  = "#ffa329",
        bright_cyan   = "#6fc4ff",
        bright_blue   = "#83a2ff",
        bright_purple = "#d989f3",

        accent               = "#6181da",
        cursor               = "#eedff1",
        foreground           = "#eedff1",
        background           = "#080201",
        selection             = "#211b1a",
        selection_foreground = "#eedff1",
        selection_background = "#211b1a",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
