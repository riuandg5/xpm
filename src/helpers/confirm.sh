# Define a function to confirm an action with the user (y/n)
function confirm {
    local result=false  # Default result is false

    local loopon=true  # Control variable for the loop
    local key  # Variable to store the user input

    # Loop until a valid input (y/n) is received
    while [ $loopon == true ]; do
        read -n 1 key  # Read a single character from the user
        echo >&2  # Print a newline

        # Check the user input
        case $key in
            y|Y)
                result=true  # Set result to true if the input is 'y' or 'Y'
                loopon=false  # Exit the loop
            ;;

            n|N)
                result=false  # Set result to false if the input is 'n' or 'N'
                loopon=false  # Exit the loop
            ;;

            *)
                # Log an error message if the input is invalid
                log "Error" "Invalid response '$key'. Please press 'y' or 'n'."
            ;;
        esac
    done

    echo $result  # Output the result
}