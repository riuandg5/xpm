# Define a function to validate the project type
function validate_project_type {
    local project_type=$1  # The project type to validate
    local result=true  # Default result is true

    # Check if the project type is not one of the valid types
    if [[ "$project_type" != "ps" && "$project_type" != "pl" && "$project_type" != "pspl" ]]; then
        result=false  # Set result to false if the type is invalid
    fi

    echo $result  # Output the result
}