#!./venv/bin/python3

import sys
import argparse
import json5
from pythainlp import word_tokenize

parser = argparse.ArgumentParser(
    prog="DELTARUNE Thai Script Preprocessor",
    description="Thai script shaper and preprocessor for DELTARUNE. Read the documentation at https://l10n.unix.in.th/wiki/DELTARUNE/Syntax",
    epilog="This script is licensed under BSD \"3-Clause\" license"
)

parser.add_argument("-t", "--thai", help="Thai JSON", action='store')
parser.add_argument("-e", "--english", help="English JSON for merging keys that does not exist.", action='store')

args = parser.parse_args()

if len(sys.argv) <= 1:
    print("Not enough arguments. Please use --help for all usage.")
    sys.exit(0)

with open(args.thai,encoding="utf8") as f:
    data = json5.load(f)

data_processed = {}


# This is probably an egregious implementation.
# As I am not a Python God yet
# --Diskette
def egregiouszwspimplementation(original):
    """Egregious ZWSP word segmentation implementation"""
    wordlist = word_tokenize(original)
    escape = [" ", "\\", "&", "^", "#", "/", "(", ")", "!", "?", ".", "-", "*", "\"", "\'"]
    processed = ""
    for i in range(len(wordlist)): # Frowned upon, to other editors, don't do loop like this
        if wordlist[i] in escape:
            processed += (wordlist[i])
        else:
            try:
                if wordlist[i + 1] in escape:
                    processed += (wordlist[i])
                else:
                    processed += (wordlist[i]) + u'\u200b' #\u200b is ZWSP
            except IndexError:
                processed += (wordlist[i])
    return processed


def uni2c90(uni):
    """Unicode to C90 (Microsoft Redmond PUA), accepts string. Possibily an egregious implementation"""

    out = "";
    ascending = False
    removable = False
    descender = False
    exceed = False
    thereisabovevowels = False
    thereisbelowvowels = False
    # Character mappings
    ac = {"ป", "ฝ", "ฟ", "ฬ"}
    rc = {"ญ", "ฐ"}
    dc = {"ฎ", "ฏ"}

    # I'm using Unicode escape sequence because อ่ อ้ อ๋ อ๊ in Emacs does not display properly
    tonemarks = {
        '\u0e48',  # MAI EK
        '\u0e49',  # MAI THO
        '\u0e4a',  # MAI TRI
        '\u0e4b',  # MAI CHATTAWA
        '\u0e4c',  # THANTHAKHAT
    }

    abovevowels = {
        '\u0e34',  # SARA I
        '\u0e35',  # SARA II
        '\u0e36',  # SARA UE
        '\u0e37',  # SARA UEE
        # PUA
        '\uf701',  # SARA I
        '\uf702',  # SARA II
        '\uf703',  # SARA UE
        '\uf704',  # SARA UEE
    }

    belowvowels = {
        '\u0e38',  # SARA U
        '\u0e39',  # SARA UU
        '\u0e3a'   # PINTHU
    }

    notconsonant = belowvowels | abovevowels | tonemarks


    # SHIFT down
    low = {
        '\u0e48' : '\uf70a',  # MAI EK
        '\u0e49' : '\uf70b',  # MAI THO
        '\u0e4a' : '\uf70c',  # MAI TRI
        '\u0e4b' : '\uf70d',  # MAI CHATTAWA
        '\u0e4c' : '\uf70e',  # THANTHAKHAT
    }
    lowVowel = {
        '\u0e38' : '\uf718',  # SARA U
        '\u0e39' : '\uf719',  # SARA UU
        '\u0e3a' : '\uf71a'  # PINTHU
    }

    # Shift left
    lowLeft = {
        '\u0e48' : '\uf705',  # MAI EK
        '\u0e49' : '\uf706',  # MAI THO
        '\u0e4a' : '\uf707',  # MAI TRI
        '\u0e4b' : '\uf708',  # MAI CHATTAWA
        '\u0e4c' : '\uf709',  # THANTHAKHAT
        '\u0e34' : '\uf701',  # SARA I
        '\u0e35' : '\uf702',  # SARA II
        '\u0e36' : '\uf703',  # SARA UE
        '\u0e37' : '\uf704',  # SARA UEE
        '\u0e47' : '\uf712',  # MAITAIKHU
    }

    left = {
        '\u0e48' : '\uf713',  # MAI EK
        '\u0e49' : '\uf714',  # MAI THO
        '\u0e4a' : '\uf715',  # MAI TRI
        '\u0e4b' : '\uf716',  # MAI CHATTAWA
        '\u0e4c' : '\uf717',  # THANTHAKHAT
        }

    removed = {
        'ญ' : '\uf70f',
        'ฐ' : '\uf700',
        }

    char = 0

    #Hello, before I go to sleep
    #Another idea was the separte the character into its own cell and then concatenate those into one character
    #For now, it's scanning until the consonants are reached, let
    cell = ""
    while char < len(uni):
        if uni[char] in notconsonant:
            if (cell[len(cell)-1] in tonemarks and uni[char] in tonemarks) or (cell[len(cell)-1] in abovevowels and uni[char] in abovevowels) or (cell[len(cell)-1] in belowvowels and uni[char] in belowvowels) or (cell[len(cell)-1] in tonemarks and uni[char] in abovevowels) or (cell[len(cell)-1] == " " and uni[char] in tonemarks) or (cell[len(cell)-1] == " " and uni[char] in abovevowels):
                exceed = True
            elif uni[char] in abovevowels:
                thereisabovevowels = True
                cell += uni[char]
                char += 1
                continue
            elif uni[char] in belowvowels:
                thereisbelowvowels = True
                cell += uni[char]
                char += 1
                continue
            else:
                cell += uni[char]
                char += 1
                continue

        if ascending == True:
            if cell in abovevowels:
                cell = cell.translate(str.maketrans(left))
            else:
                cell = cell.translate(str.maketrans(lowLeft))
        elif removable == True and thereisbelowvowels == True:
            cell = cell.translate(str.maketrans(removed))
            if thereisabovevowels == True:
                cell = cell.translate(str.maketrans(low))
        elif descender == True:
            cell = cell.translate(str.maketrans(lowVowel))
            if thereisabovevowels == True:
                cell = cell.translate(str.maketrans(low))
        else:
            if thereisabovevowels == True:
                cell = cell.translate(str.maketrans(low))
        out += cell

        ascending = False
        removable = False
        descender = False
        thereisabovevowels = False
        thereisbelowvowels = False
        if exceed == True:
            cell = '\u25cc'
            exceed = False
        else:
            if uni[char] in ac:
                ascending = True
            if uni[char] in rc:
                removable = True
            if uni[char] in dc:
                descender = True
            cell = uni[char]
            char += 1
    return out

for entry, message in data.items():
    print(entry, uni2c90(message))
