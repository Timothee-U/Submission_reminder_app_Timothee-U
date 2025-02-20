#!/bin/bash

# ask for user's name
read -p "Enter a name you prefer: " userName

# Define main dir
T_dir="submission_reminder_${userName}"

# Create directory one by one
mkdir -p "$T_dir/config"
mkdir -p "$T_dir/modules"
mkdir -p "$T_dir/app"
mkdir -p "$T_dir/assets"

# files
touch "$T_dir/config/config.env"
touch "$T_dir/assets/submissions.txt"
touch "$T_dir/app/reminder.sh"
touch "$T_dir/modules/functions.sh"
touch "$T_dir/startup.sh"


# config.env
cat << EOF > "$T_dir/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# submissions.txt with some student records
cat << EOF > "$T_dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Chris, Shell Navigation, not submitted
Karake, Shell Basics, submitted
Prince, Shell Navigation, not submitted
Timothee, Shell Navigation, not submitted
Nazira, Shell Navigation, not submitted
Denyse, Shell Navigation, submitted
EOF

# functions.sh
cat << 'EOF' > "$T_dir/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
 
 function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# reminder.sh
cat << 'EOF' > "$T_dir/app/reminder.sh"
#!/bin/bash
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# startup.sh
cat << 'EOF' > "$T_dir/startup.sh"
#!/bin/bash
echo "Starting Submission Reminder App..."
./app/reminder.sh
EOF

# execute the scripts
chmod +x "$T_dir/modules/functions.sh"
chmod +x "$T_dir/startup.sh"
chmod +x "$T_dir/app/reminder.sh"
