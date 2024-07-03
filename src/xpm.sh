#!/bin/bash

# Set the XPM_PATH variable to the directory of the script
XPM_PATH=$(dirname "$0")

# Source the necessary helper scripts
source $XPM_PATH/helpers/log.sh
source $XPM_PATH/helpers/confirm.sh
source $XPM_PATH/helpers/validate_project_type.sh
source $XPM_PATH/helpers/sanitize_project_name.sh
source $XPM_PATH/helpers/validate_project_name.sh
source $XPM_PATH/helpers/create_pl_project.sh
source $XPM_PATH/helpers/create_ps_project.sh
source $XPM_PATH/helpers/create_project.sh


# Main script execution starts here
if [ "$#" -eq 1 ] || [ "$#" -eq 2 ]; then
    sanitized_project_name=$(sanitize_project_name "$1")  # Sanitize the project name
    is_project_name_valid=$(validate_project_name $sanitized_project_name)  # Validate the project name
    
    # Proceed if the project name is valid
    if [ $is_project_name_valid == true ]; then
        if [ "$#" -eq 1 ]; then
            log "Info" "Considering default project type 'pl'."
            create_project $sanitized_project_name "pl"  # Create a project with the default type
        else
            is_project_type_valid=$(validate_project_type "$2")  # Validate the project type
            if [ $is_project_type_valid == true ]; then
                create_project $sanitized_project_name "$2"  # Create a project with the specified type
            else
                log "Error" "Valid project types are 'pl' (default), 'ps', 'pspl'."
            fi
        fi
    else
        exit 1  # Exit if the project name is not valid
    fi
else
    # Print usage information if the number of arguments is incorrect
    echo "Usage: xpm <project_name> [project_type]"
    echo
    echo "[project_type]:  'pl'   for Vivado Project only (Default)"
    echo "                 'ps'   for SDK Project only"
    echo "                 'pspl' for Vivado + SDK project"
fi