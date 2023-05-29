set -x DIRENV_LOG_FORMAT ""
eval (direnv hook fish)
function b
    eval "$BUILD_COMMAND"
end
function t
    eval "$TEST_COMMAND"
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
        ls "$PWD/nix-templates/$argv[1]"
        mv -n "$PWD/nix-templates/$argv[1]/"* "$PWD"
        rm -R -f nix-templates
        echo "Done"
    end
end