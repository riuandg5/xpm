# Define a function to create a project with the specified name and type
function create_project {
    local project_name=$1  # The project name
    local project_type=$2  # The project type

    mkdir $project_name  # Create the project directory

    mkdir $project_name/images  # Create a directory for images

    touch $project_name/README.md  # Create a README file
    echo "# $project_name" >> $project_name/README.md  # Initialize the README file

    # Create the project structure based on the project type
    if [ $project_type == "pl" ]; then
        create_pl_project $project_name
    elif [ $project_type == "ps" ]; then
        create_ps_project $project_name
    elif [ $project_type == "pspl" ]; then
        mkdir "$project_name/pl"
        create_pl_project "$project_name/pl"

        mkdir "$project_name/ps"
        create_ps_project "$project_name/ps"
    fi

    log "Info" "Projected created!"
}