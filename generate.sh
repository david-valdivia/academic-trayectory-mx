#!/bin/bash

# Variables
name="$1"
first_surname="$2"
second_surname="$3"

# Validate arguments
if [ -z "$name" ] || [ -z "$first_surname" ] || [ -z "$second_surname" ]; then
    echo "Usage: $0 <name> <first_surname> <second_surname>"
    exit 1
fi

# Create directories
mkdir -p outputs templates

# API Request
api_response=$(curl -s -X POST https://www.cedulaprofesional.sep.gob.mx/cedula/buscaCedulaJson.action \
  -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
  -d "json={\"idCedula\":\"\",\"nombre\":\"$name\",\"paterno\":\"$first_surname\",\"materno\":\"$second_surname\"}")

# Verify API response
if [ -z "$api_response" ] || ! echo "$api_response" | jq . >/dev/null 2>&1; then
    echo "Error: API request failed"
    exit 1
fi

# Extract data with jq
items=$(echo "$api_response" | jq -r '.items[]? | "\(.anioreg)|\(.titulo)|\(.desins)|\(.idCedula)"')

if [ -z "$items" ]; then
    echo "No certificates found"
    exit 1
fi

# Function to determine badge type
get_badge_type() {
    local title="$1"
    if echo "$title" | grep -i "licenciatura" > /dev/null; then
        echo "bachelor"
    elif echo "$title" | grep -i -E "maestr|master|doctorado|doctor" > /dev/null; then
        echo "master"
    else
        echo "technical"
    fi
}

# Function to get badge text
get_badge_text() {
    local type="$1"
    case $type in
        "bachelor") echo "BACHELOR";;
        "master") echo "MASTER";;
        *) echo "TECHNICAL";;
    esac
}

# Function to fix tildes and special characters
fix_accents() {
    local text="$1"
    # Common encoding issues from API
    text="${text//�/Í}"
    text="${text//�/Ó}"
    text="${text//�/Á}"
    text="${text//�/É}"
    text="${text//�/Ú}"
    text="${text//�/Ñ}"
    text="${text//\?/Ó}"
    text="${text//Ã‰/É}"
    text="${text//Ã³/ó}"
    text="${text//Ã­/í}"
    text="${text//Ã¡/á}"
    text="${text//Ã©/é}"
    text="${text//Ãº/ú}"
    text="${text//Ã±/ñ}"
    echo "$text"
}

# Function to truncate text
truncate_text() {
    local text="$1"
    local max_len="$2"
    if [ ${#text} -gt $max_len ]; then
        echo "${text:0:$((max_len-3))}..."
    else
        echo "$text"
    fi
}

# Generate cards
all_cards=""
count=0

while IFS='|' read -r year title institution cedula; do
    if [ $count -ge 4 ]; then break; fi

    badge_type=$(get_badge_type "$title")
    badge_text=$(get_badge_text "$badge_type")

    # Positions
    if [ $((count % 2)) -eq 0 ]; then
        x_pos=0
    else
        x_pos=420
    fi

    if [ $count -lt 2 ]; then
        y_pos=0
    else
        y_pos=155
    fi

    # Truncate texts and fix accents
    title_truncated=$(fix_accents "$(truncate_text "$title" 35)")
    institution_truncated=$(fix_accents "$(truncate_text "$institution" 40)")

    # Standard badge width
    badge_width=120

    # Calculate positions
    badge_x=$((x_pos + 10))
    badge_y=$((y_pos + 10))
    badge_text_x=$((badge_x + badge_width / 2))
    badge_text_y=$((badge_y + 14))
    year_x=$((x_pos + 320))  # Adjusted to stay within card bounds
    year_y=$badge_text_y
    title_x=$((x_pos + 10))
    title_y=$((y_pos + 45))
    institution_x=$title_x
    institution_y=$((y_pos + 62))
    cedula_x=$title_x
    cedula_y=$((y_pos + 75))

    # Load and process card template
    card_template=$(cat templates/card.txt)
    card="${card_template//\{\{CARD_NUMBER\}\}/$((count+1))}"
    card="${card//\{\{BADGE_TEXT\}\}/$badge_text}"
    card="${card//\{\{YEAR\}\}/$year}"
    card="${card//\{\{X_POS\}\}/$x_pos}"
    card="${card//\{\{Y_POS\}\}/$y_pos}"
    card="${card//\{\{BADGE_X\}\}/$badge_x}"
    card="${card//\{\{BADGE_Y\}\}/$badge_y}"
    card="${card//\{\{BADGE_TYPE\}\}/$badge_type}"
    card="${card//\{\{BADGE_TEXT_X\}\}/$badge_text_x}"
    card="${card//\{\{BADGE_TEXT_Y\}\}/$badge_text_y}"
    card="${card//\{\{YEAR_X\}\}/$year_x}"
    card="${card//\{\{YEAR_Y\}\}/$year_y}"
    card="${card//\{\{TITLE_X\}\}/$title_x}"
    card="${card//\{\{TITLE_Y\}\}/$title_y}"
    card="${card//\{\{TITLE\}\}/$title_truncated}"
    card="${card//\{\{INSTITUTION_X\}\}/$institution_x}"
    card="${card//\{\{INSTITUTION_Y\}\}/$institution_y}"
    card="${card//\{\{INSTITUTION\}\}/$institution_truncated}"
    card="${card//\{\{CEDULA_X\}\}/$cedula_x}"
    card="${card//\{\{CEDULA_Y\}\}/$cedula_y}"
    card="${card//\{\{CEDULA_NUMBER\}\}/$cedula}"

    all_cards="$all_cards$card"
    count=$((count+1))
done <<< "$items"

# Generate final SVG
main_template=$(cat templates/main.txt)
final_svg="${main_template//\{\{CARDS\}\}/$all_cards}"

# Save file
output_file="outputs/academic_trajectory.svg"
echo "$final_svg" > "$output_file"

echo "SVG generated: $output_file"
