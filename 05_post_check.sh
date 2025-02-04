#!/bin/bash

# Database credentials (environment variables are recommended)
DB_HOST="${DB_HOST:-127.0.0.1}"  # Default to 127.0.0.1 if not set
DB_PORT="${DB_PORT:-4000}"      # Default to 4000 if not set
DB_USER="${DB_USER:-root}"      # Default to root if not set
DB_USER="${DB_NAME:-UniversityDB}"      # Default to root if not set

# Expected table structure (adjust as needed)
EXPECTED_STRUCTURE=$(cat output/table_structure.txt)

# Function to get the actual table structure from the database
get_table_structure() {
  mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" -e "DESCRIBE Students;" | tail -n +2 | awk '{print "    "$1" "$2" "$3" "$4" "$5" "$6";"}'
}

# Get the actual table structure
actual_structure=$(get_table_structure)

# Format the expected structure for comparison (remove extra whitespace)
expected_formatted=$(echo "$EXPECTED_STRUCTURE" | sed 's/^[ \t]*//; s/[ \t]*$//; s/[ \t][ \t]*/ /g')

# Format the actual structure for comparison (remove extra whitespace)
actual_formatted=$(echo "$actual_structure" | sed 's/^[ \t]*//; s/[ \t]*$//; s/[ \t][ \t]*/ /g')


# Compare the structures
if [[ "$expected_formatted" == "$actual_formatted" ]]; then
  echo "Table structure is correct."
else
  echo "Table structure is INCORRECT."
  echo "Expected:"
  echo "$expected_formatted"
  echo "Actual:"
  echo "$actual_formatted"
  diff <(echo "$expected_formatted") <(echo "$actual_formatted") # Show the difference
  exit 1 # Exit with error code if structures do not match
fi

exit 0