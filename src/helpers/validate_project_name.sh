# Define a function to validate the project name
function validate_project_name {
    local project_name=$1  # The project name to validate
    local result=true  # Default result is true

    local is_equal_to_project_type=$(validate_project_type $project_name)  # Check if the name is a valid project type

    # Check if a directory with the project name already exists
    if [ -d "$project_name" ]; then
        log "Error" "A directory with the name '$project_name' already exists."
        result=false  # Set result to false if the directory exists
    elif [ $is_equal_to_project_type == true ]; then
        # Ask the user for confirmation if the name is a valid project type
        log "Warning" "Are you sure you want to create a project with name '$project_name'? (y/n)"
        result=$(confirm)  # Get the user's confirmation
        if [ $result == false ]; then
            log "Info" "Aborted!"
        fi
    fi

    echo $result  # Output the result
}