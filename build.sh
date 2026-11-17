#!/usr/bin/env bash
undertalemodclipath=""
_filename=$0


initializationCheck() {
    printf "Running a few checks before creating a development environment\n"
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        printf "Hey, just a heads-up, I don't have a Macintosh machine... or a Windows machine... or FreeBSD... or literally anything else that's not GNU/Linux.\nIf your system has GNU utilities (because this script might have some GNU-ism in it) and Python, it should be fine... I think.\nIf there are any dependencies that I have not caught, please do forgive me."
    fi
    if [[ ! -d "DELTARUNE" ]]; then
        printf "Please copy the original unmodified version of DELTARUNE to this directory to proceed.\n"
        initerr=1
    fi
    if [[ -z "$undertalemodclipath" ]]; then
        if command -v UndertaleModCli &>/dev/null; then
            printf "UndertaleModCLI not found in PATH!\nPlease make sure to provide it in the PATH or manually specify it using the -b parameter.\n"
            initerr=1
        fi
    elif [[ ! -f "$(undertalemodclipath)/UndertaleModCli" ]]; then
        printf "UndertaleModCLI binary not found in %s!\n" "$undertalemodclipath"
        initerr=1
    elif [[ ! -x "$(undertalemodclipath)/UndertaleModCli" ]]; then
        printf "UndertaleModCLI is not executable!\n"
        initerr=1
    fi
    if [[ initerr -eq 1 ]]; then
        exit 1
    fi
}

useModTool() {
    if [[ -z "$undertalemodclipath" ]]; then
        UndertaleModCli $1
    else
        "$undertalemodclipath"/UndertaleModCli $1
    fi
}
createPatchFromModification() {
    for chdir in ./modifications/ch*/; do
        for cfiles in "$chdir/code/"*; do
            if [ -e ./extracted/"$(basename "$chdir")"/CodeEntries/"$(basename "$cfiles")" ]; then
                diff -a ./extracted/"$(basename "$chdir")"/CodeEntries/"$(basename "$cfiles")" "$cfiles" > ./patches/diff/"$(basename "$chdir")"/"$(basename "$cfiles")".patch
            else
                cp "$cfiles" patches/etc/"$(basename "$chdir")"/
            fi
        done
    done

    # Chapter Select
    for cfiles in ./modifications/sel/latest/code/*; do
        if [ -e extracted/sel/latest/CodeEntries/"$(basename "$cfiles")" ]; then
            diff -a extracted/sel/latest/CodeEntries/"$(basename "$cfiles")" "$cfiles" > patches/diff/sel/latest/"$(basename "$cfiles")".patch
        else
            cp "$cfiles" patches/etc/sel/latest/"$(basename "$chdir")"/
        fi
    done

    if [[ -d ./DELTARUNEdemo/ ]]; then
        for cfiles in ./modifications/sel/demo/code/*; do
            if [ -e ./extracted/sel/demo/CodeEntries/"$(basename "$cfiles")" ]; then
                diff -a ./extracted/sel/demo/CodeEntries/"$(basename "$cfiles")" "$cfiles" > ./patches/diff/sel/demo/"$(basename "$cfiles")".patch
            else
                cp "$cfiles" ./patches/etc/sel/demo/"$(basename "$chdir")"/
            fi
        done
    fi

}

createModificationFromPatch() {
    for chdir in patches/diff/ch*/; do
        for dfiles in "$chdir"/* ; do
            cp extracted/"$(basename "$chdir")"/CodeEntries/"$(basename "$dfiles" .patch)" modifications/"$(basename "$chdir")"/code/"$(basename "$dfiles")".gml
            patch modifications/"$(basename "$chdir")"/code/"$(basename "$dfiles" .patch)".gml "$dfiles"
        done
    done
    for chdir in patches/etc/ch*/; do
        for dfiles in "$chdir"/* ; do
            cp "$dfiles" modifications/"$(basename "$chdir")"/code/"$(basename "$dfiles")"
        done
    done
    # Chapter Select
    for dfiles in patches/diff/sel/latest/* ; do
        cp extracted/sel/latest/CodeEntries/"$(basename "$dfiles" .patch)" modifications/sel/latest/code/"$(basename "$dfiles" .patch)".gml
        patch modifications/sel/latest/code/"$(basename "$dfiles" .patch)".gml "$dfiles"
    done
    if [[ -d ./DELTARUNEdemo/ ]]; then
        cp extracted/sel/demo/CodeEntries/"$(basename "$dfiles" .patch)" modifications/sel/demo/code/"$(basename "$dfiles" .patch)".gml
        patch modifications/sel/demo/code/"$(basename "$dfiles" .patch)".gml "$dfiles"
    fi
}

extractCodesFromDELTARUNE() {
    if [[ -d ./DELTARUNEdemo/ ]]; then # DEMO
        mkdir -p extracted/sel/latest
        useModTool "dump DELTARUNE/data.win -c UMT_DUMP_ALL -o extracted/sel/demo"
    fi
    mkdir -p extracted/sel/latest
    useModTool "dump DELTARUNE/data.win -c UMT_DUMP_ALL -o extracted/sel/latest"
    chcount=0
    for chapter in DELTARUNE/chapter*/; do
        ((chcount++))
        mkdir -p extracted/ch"$chcount"/
        useModTool "dump $chapter/data.win -c UMT_DUMP_ALL -o extracted/ch$chcount/"
    done
}

buildDELTARUNE() {
    cp -r ./DELTARUNE ./output ## Beatiful. No loops. Because lazy.
    useModTool "project build ./modifications/sel/latest/project.json --source ./output/data.win --destination ./output/data.win"
    useModTool "project build ./modifications/ch1/project.json --source ./output/chapter1_windows/data.win --destination ./output/chapter1_windows/data.win"
    useModTool "project build ./modifications/ch2/project.json --source ./output/chapter2_windows/data.win --destination ./output/chapter2_windows/data.win"
    useModTool "project build ./modifications/ch3/project.json --source ./output/chapter3_windows/data.win --destination ./output/chapter3_windows/data.win"
    useModTool "project build ./modifications/ch4/project.json --source ./output/chapter4_windows/data.win --destination ./output/chapter4_windows/data.win"
    useModTool "project build ./modifications/ch5/project.json --source ./output/chapter5_windows/data.win --destination ./output/chapter5_windows/data.win"
}

buildDELTARUNEdemo() {
    cp -r ./DELTARUNEdemo ./outputDEMO ## Beatiful. No loops. Because lazy.
    useModTool "project build ./modifications/sel/demo/project.json --source ./outputDEMO/data.win --destination ./outputDEMO/data.win"
    useModTool "project build ./modifications/ch1/project.json --source ./outputDEMO/chapter1_windows/data.win --destination ./outputDEMO/chapter1_windows/data.win"
    useModTool "project build ./modifications/ch2/project.json --source ./outputDEMO/chapter2_windows/data.win --destination ./outputDEMO/chapter2_windows/data.win"
}

initialize() {
    initalizationCheck
    printf "Initializing DELTARUNE Thai localization development environment\n"
    printf "Creating directory\n"
    mkdir modifications

    for dir in patches/diff/*/; do
        mkdir "modifications/$(basename "$dir")"/
        ln -s "$(realpath ./fonts/)" "modifications/$(basename "$dir")/fonts"
        mkdir "modifications/$(basename "$dir")"/code
    done

    extractCodesFromDELTARUNE
}




# Hang on, I keep forgetting what features this script have
# OK, so
# Extract DELTARUNE codes
# Create a development environment
# Update DIFF files
# Build DELTARUNE
#
# Also, too bad BASH does not have function prototypes
helpusage() {
    printf "Diskette\'s DELTARUNE Thai localization build tools\nThis script specifically is licensed under GNU LGPL\n\nUsage:"
    printf "%s -h :\nDisplay this message\n" "$_filename"
    printf "%s -b [directory] :\nSpecify UndertaleModCLI path, if not in PATH\n\n" "$_filename"
    printf "%s -B :\nBuild DELTARUNE from the changes made in the development directory\n\n" "$_filename"
    printf "%s -D :\nBuild DELTARUNE **DEMO** from the changes made in the development directory\n\n" "$_filename"
    printf "%s -c :\nCreate/update development directory from patches\n\n" "$_filename"
    printf "%s -i :\nForce reinitialization of the development directory\n\n" "$_filename"
    printf "%s -p :\nUpdate patches directory for commiting changes\n\n" "$_filename"
    printf "%s -x :\nExtract DELTARUNE into /extracted/ directory\n\n" "$_filename"
    exit 0
}


while getopts "hb:BDcipx" opt; do
    case $opt in
        h) helpusage ;;
        b) undertalemodclipath="$OPTARG" ;;
        B) buildDELTARUNE ;;
        D) buildDELTARUNEdemo ;;
        c) createModificationFromPatch ;;
        i) initialize ;;
        p) createPatchFromModification ;;
        x) extractCodesFromDELTARUNE ;;
        \?) printf "Invalid option: -%s" "$OPTARG" ;;
    esac
done

