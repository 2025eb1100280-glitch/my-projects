#!/bin/bash

# Create or clear the output file
> ugly.txt

# --- Function to check if a number is an UGLY number ---
is_ugly() {
    local num=$1

    # Only positive integers can be ugly numbers
    if (( 10#$num <= 0 )); then
        return 1
    fi

    if (( 10#$num == 1 )); then
        return 0
    fi

    # Divide by 2, 3, and 5 as long as possible
    for factor in 2 3 5; do
        while (( 10#$num % factor == 0 )); do
            num=$(( 10#$num / factor ))
        done
    done

    (( 10#$num == 1 ))
}

# --- Process each line of record.txt ---
# Use IFS to handle spaces correctly in names
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    [[ -z "$line" ]] && continue

    # Extract ID, First, and Last names safely
    read -r ID FIRST LAST <<<"$line"

    # Skip if ID is missing or malformed
    [[ -z "$ID" ]] && continue

    # Extract 10th–13th characters from ID (indexing starts at 0)
    IDPART="${ID:9:4}"

    # Remove leading zeros (handle empty results correctly)
    NUM="${IDPART##+(0)}"
    [[ -z "$NUM" ]] && NUM=0

    # Ensure NUM is a valid positive integer
    if ! [[ "$NUM" =~ ^[0-9]+$ ]] || (( 10#$NUM <= 0 )); then
        continue
    fi

    # Check if it’s an ugly number
    if is_ugly "$NUM"; then
        EMAIL="$(echo "$ID" | tr '[:upper:]' '[:lower:]')@bitspilani-digital.edu.in"
        # Proper fixed-width formatting for output
        printf "%s\t\t%-10s%-10s\t%s\n" "$ID" "$FIRST" "$LAST" "$EMAIL" >> ugly.txt
    fi
done < record.txt
