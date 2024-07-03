# Define a function to log messages with a specific type (Info, Warning, Error)
function log {
    local type=$1  # The type of the log (Info, Warning, Error)
    local message=$2  # The message to log

    # Output the message to stderr with a prefix
    echo "[ XPM ] $type: $message" >&2
}