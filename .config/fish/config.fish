set -x DIRENV_LOG_FORMAT ""
eval (direnv hook fish)
function c
    set_color -o red
    echo "Cleanup phase '$CLEAN_COMMAND'"
    set_color normal
    eval "$CLEAN_COMMAND"
end
function b
    set_color -o yellow
    echo "Build phase '$BUILD_COMMAND'"
    set_color normal
    eval "$BUILD_COMMAND"
end
function t
    set_color -o green
    echo "Test phase '$TEST_COMMAND'"
    set_color normal
    eval "$TEST_COMMAND"
end
function cbt
    c
    b
    t
end
function e
    code . &
    disown
    exit
end
function cfg
    cd /etc/nixos
    xdg-open .
    code .
end
function boilerplate -d "Grabs a boilerplate from https://github.com/boltr6/nix-templates"
    if contains -- "$argv" "-L" "--list"
        # List the available boilerplates
        git clone -q https://github.com/boltr6/nix-templates
        echo "Availabe boilerplates:"
        ls "$PWD/nix-templates"
        rm -R -f nix-templates
    else
        # Clone and move the selected boilerplate
        git clone -q https://github.com/boltr6/nix-templates
        echo "Grabbing the following files:"
        ls -A "$PWD/nix-templates/$argv[1]"
        mv -n "$PWD/nix-templates/$argv[1]/"{.*,*} "$PWD"
        rm -R -f nix-templates
        echo "Done"
    end
end
set_color -i cyan
set fish_greeting "ILY ~E"
set_color normal