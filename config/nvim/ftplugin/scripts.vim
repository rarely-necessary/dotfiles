if did_filetype()
    finish
endif

if getline(1) =~ '^#!.*\<sh\>'
    setfiletype sh
elseif getline(1) =~ '^#!.*\<zsh\>'
    setfiletype zsh
elseif getline(1) =~ '^#!.*\<bash\>'
    setfiletype bash
elseif getline(1) =~ '^#!.*\<python\d*\.*\d*\>'
    setfiletype python
elseif getline(1) =~ '^#!.*\<ruby\>'
    setfiletype ruby
elseif getline(1) =~ '^#!.*\<lua\>'
    setfiletype lua
elseif getline(1) =~ '^#!.*\<node\>'
    setfiletype javascript
elseif getline(1) =~ '^#!.*\<perl\>'
    setfiletype perl
endif
