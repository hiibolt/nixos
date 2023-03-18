#!/bin/bash

git clone https://github.com/boltr6/nix-templates
mv nix-templates/$1/* .
rm -R -f nix-templates
