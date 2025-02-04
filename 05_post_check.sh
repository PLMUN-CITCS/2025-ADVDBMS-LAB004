#!/bin/bash

# Database credentials (environment variables are recommended)
DB_HOST="${DB_HOST:-127.0.0.1}"  # Default to 127.0.0.1 if not set
DB_PORT="${DB_PORT:-4000}"      # Default to 4000 if not set
DB_USER="${DB_USER:-root}"      # Default to root if not set
DB_USER="${DB_NAME:-UniversityDB}"      # Default to root if not set

# Expected table structure (adjust as needed)
EXPECTED_STRUCTURE=$(cat output/table_structure.txt)

# Get the actual table structure
actual_structure=$(mysql -h 127.0.0.1 -P 4000 -u root UniversityDB -e "DESCRIBE Students;" | tail -n +2 | awk '{print "    "$1" "$2" "$3" "$4" "$5" "$6";"}' 2>&1)

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

echo "$output"  # Print the output of the SQL script

exit 0