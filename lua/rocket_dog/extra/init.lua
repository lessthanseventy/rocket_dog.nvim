local M = {}

local function write(str, fileName)
  print("[write] extra/" .. fileName)
  vim.fn.mkdir(vim.fs.dirname("extras/" .. fileName), "p")
  local file = io.open("extras/" .. fileName, "w")
  file:write(str)
  file:close()
end

function M.setup()
  local config = require("rocket_dog.config")
  vim.o.background = "dark"

  -- map of plugin name to plugin extension
  local extras = {
    kitty = "conf",
    fish = "fish",
    fish_themes = "theme",
    alacritty = "yml",
    wezterm = "toml",
    tmux = "tmux",
    xresources = "Xresources",
    xfceterm = "theme",
    foot = "ini",
    tilix = "json",
    iterm = "itermcolors",
    lua = "lua",
    sublime = "tmTheme",
    delta = "gitconfig",
    terminator = "conf",
    prism = "js"
  }
  -- map of style to style name
  local styles = { storm = " Storm", night = "", day = " Day", moon = " Moon" }

  for extra, ext in pairs(extras) do
    package.loaded["rocket_dog.extra." .. extra] = nil
    local plugin = require("rocket_dog.extra." .. extra)
    for style, style_name in pairs(styles) do
      config.setup({ style = style })
      local colors = require("rocket_dog.colors").setup({
        transform = true
      })
      local fname = extra .. "/rocket_dog_" .. style .. "." .. ext
      colors["_upstream_url"] =
          "https://github.com/lessthanseventy/rocket_dog.nvim/raw/main/extras/" ..
          fname
      colors["_style_name"] = "Rocket Dog" .. style_name
      write(plugin.generate(colors), fname)
    end
  end
end

return M
