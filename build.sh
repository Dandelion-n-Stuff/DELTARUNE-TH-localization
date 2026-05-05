#!/usr/bin/env sh

# Checking mandatory dependencies/not found in PATH

NOTFOUND="The following binary is not installed or not in $PATH:"
DEPNOTFULFILLED=0
if ! command -v org.kde.krita >/dev/null 2>&1
then
    echo "$NOTFOUND org.kde.krita (KDE Krita)"
    DEPNOTFULFILLED=$((DEPNOTFULFILLED+1))
fi
if ! command -v undertalemodtool >/dev/null 2>&1
then
    echo "$NOTFOUND undertalemodtool (UndertaleModTool)"
    DEPNOTFULFILLED=$((DEPNOTFULFILLED+1))
fi

## Plural test
# if ! command -v thiscommandwillnotbefound >/dev/null 2>&1
# then
#     echo "$NOTFOUND The dependency checker works"
#     DEPNOTFULFILLED=$((DEPNOTFULFILLED+1))
# fi
# if ! command -v thiscommandwillnotbefound >/dev/null 2>&1
# then
#     echo "$NOTFOUND The dependency checker works... So does the plural?"
#     DEPNOTFULFILLED=$((DEPNOTFULFILLED+1))
# fi

# I like being punctual <3
if [ $DEPNOTFULFILLED = 1 ]
then
    echo "You do not have the required dependency. Exiting..."
    exit 1
elif [ $DEPNOTFULFILLED -ge 1 ]
then
    echo "You do not have the required dependencies. Exiting..."
    exit 1
fi
echo "All dependencies checked, building..."

# Export all .kra in ./sprites-raw/
for dir in ./sprites-raw/*/; do
    for kra in "$dir"*.kra
    do
        #EXPORTOPTS=$(sed -i )
        #org.kde.krita --export-filename "$EXPORTOPTS" "$kra"
    done
done

undertalemodtool
