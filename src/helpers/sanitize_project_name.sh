# Define a function to sanitize the project name by replacing spaces with underscores
function sanitize_project_name {
    local project_name=$1  # The project name to sanitize
    local result=$project_name  # Default result is the original project name

    # Check if the project name contains spaces
    if [[ "$project_name" == *" "* ]]; then
        # Log a warning message
        log "Warning" "Project name '$project_name' contains spaces. Replacing spaces with underscores."
        project_name=${project_name// /_}  # Replace spaces with underscores
        log "Info" "Considering project name '$project_name'"
        result=$project_name  # Update the result with the sanitized name
    fi

    echo $result  # Output the result
}