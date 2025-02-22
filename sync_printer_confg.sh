
#!/bin/bash

# Ruta del directorio de configuración
CONFIG_DIR="/home/chebasic/printer_data/config"
CONFIG_FILE="printer.cfg"

# Navegar al directorio del repo
cd "$CONFIG_DIR" || exit

# Verificar si hay cambios en printer.cfg
if git diff --quiet "$CONFIG_FILE"; then
    echo "⚠️ No hay cambios en printer.cfg. Nada que commitear."
    exit 0
fi

# Extract changes in 'git diff' format (excluding Klipper auto-generated lines)
DIFF_OUTPUT=$(git diff --unified=0 "$CONFIG_FILE" | grep -E '^\+|^\-' | grep -v '+++' | grep -v '\-\-\-' | grep -v '#\*\#')

FORMATTED_DIFF=$(echo "$DIFF_OUTPUT" | sed -E 's/^(\+|-)/\1\t/')

# Format the commit message
COMMIT_MESSAGE="Auto-sync: Updated printer.cfg\n\n$FORMATTED_DIFF"

# Add changes
git add "$CONFIG_FILE"

# Commit with formatted message
echo -e "$COMMIT_MESSAGE" | git commit -F -

# Push changes to the repository
git push origin main
# Display the commit message in the terminal
echo "✅ Configuration synced with Git"
echo -e "📌 Commit message:\n$COMMIT_MESSAGE"
