if pcall(require, 'alpha') then
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    math.randomseed(os.time())

    local function pick_color()
      local colors = { 'String', 'Identifier', 'Keyword', 'Number' }
      return colors[math.random(#colors)]
    end

    local function footer()
      local total_plugins = #vim.tbl_keys(packer_plugins)
      local datetime = os.date(' %D   %I:%M')
      local version = vim.version()
      local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
    end

    -- 43
    local logo = {
      '',
      [[                  .:               :.]],
      [[                .::::              :::.]],
      [[              .:::::::.            :::::.]],
      [[           . '::::::::::           :::::::.]],
      [[          :''.'::::::::::.         ::::::::::]],
      [[          :: '.'::::::::::.        ::::::::::]],
      [[          ::   : '::::::::::       ::::::::::]],
      [[          ::    '.'::::::::::.     ::::::::::]],
      [[          ::     ': '::::::::::    ::::::::::]],
      [[          ::      :: '::::::::::.  ::::::::::]],
      [[          ::      ::   ':::::::::. ::::::::::]],
      [[          ::      ::    ':::::::::: '::::::::]],
      [[          ::      ::     '::::::::::.':::::::]],
      [[          ::      ::       ':::::::::. ::::::]],
      [[          ::      ::        ':::::::::: '::::]],
      [[          ::.     ::         '::::::::::.'::']],
      [[            ':.   ::           ':::::::::. ]],
      [[              ':. ::            ':::::::']],
      [[                ':.:             '::::']],
      [[                  ':               :']],
      '',
      '',
      [[                                  :::]],
      [[. ...     ,...,    ,.., ...,    .,... ...,... ,...,]],
      [[:'   ': .:     : .'    '.:::.  :::::: :::' '::' ':::]],
      [[:     : ::......':      : ::: ::: ::: :::   ::   :::]],
      [[:     : ::       :      :  :::::  ::: :::   ::   :::]],
      [[:     :  '.....'  '....'    :::   ::: :::   ::   :::]],
      '',
    }

    dashboard.section.header.val = logo
    dashboard.section.header.opts.hl = pick_color()
    dashboard.section.buttons.val = {
      dashboard.button( "e", "  New file" , ":ene<CR>"),
      dashboard.button('<Leader>ff', '  Find File'),
      dashboard.button('<Leader>fg', '  Find Word'),
      dashboard.button('<Leader>ps', '  Update plugins', ':PackerSync<CR>'),
      dashboard.button('q', '  Quit', ':qa<CR>')
    }
    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = 'Constant'

    alpha.setup(dashboard.opts)
else
    print('Error loading alpha.lua')
end
