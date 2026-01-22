set -x DIRENV_LOG_FORMAT ""
eval (direnv hook fish)
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
set fish_greeting "Don't stop 'till Stanford"
kubectl completion fish | source
talosctl completion fish | source
