set -x DIRENV_LOG_FORMAT ""
eval (direnv hook fish)
function b
    eval "$BUILD_COMMAND"
end
function t
    eval "$TEST_COMMAND"
end
