#!/bin/bash

declare -a files
directory="university_db"
SQL_FILES=("create_and_use_db.sql" "create_students_table.sql" "alter_students_table.sql") # Array of filenames

for file in "${files[@]}"; do  # Important: Quote "${files[@]}"
filepath="$directory/$file" # Construct the full path
if [ -f "$filepath" ]; then
    echo "$filepath exists"
else
    echo "$filepath does not exist"
fi
done