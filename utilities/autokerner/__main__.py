#!/usr/bin/env python3

import os
import sys, argparse
import codecs
import json5

## Configuration
# Base width
xbase = 6
# Base spacing
xspace = 2

parser = argparse.ArgumentParser(
    prog="Autokerner",
    description="A .yy font autokerner to Toby Fox-ism DELTARUNE dialogue code",
    epilog="This script is under MIT License"
)

parser.add_argument("-f", "--file", help="The input file for conversion.", action='store')
parser.add_argument("-o", "--output", help="Output mode.\nYou may use `std` for standard output\nor `file` for file output.\nThe default argument is standard output.", action="append", default="std")
parser.add_argument("-F", "--outputfile", help="Output file.\nFor use with --output file option only.\nThe file needs to be in a writable directory.", action="append")

args = parser.parse_args()


if len(sys.argv) <= 1:
    print("Not enough arguments. Please use --help for all usage.")
    sys.exit(0)

with open(args.file) as f:
    data = json5.load(f)

processed = {}

for char, entry in data["glyphs"].items():
    try:
        print(str(data["glyphs"][char]["shift"]) + " 8 " + str(data["glyphs"][char]["offset"]) + "\tAnd this equals to... " + str(data["glyphs"][char]["shift"]-xbase+data["glyphs"][char]["offset"])+ "   \tCHAR: " + str(data["glyphs"][char]["character"]))
        processed[data["glyphs"][char]["shift"]-xbase+data["glyphs"][char]["offset"]].append(data["glyphs"][char]["character"])
    except KeyError:
        processed[data["glyphs"][char]["shift"]-xbase+data["glyphs"][char]["offset"]] = [data["glyphs"][char]["character"]]

print("This is processed data:\n" + str(processed) + "\n\n\n")
def dothemagicstuff():
    result = ("if (myfont == "+ data["name"] + ")\n{\n")
    for diff, char in processed.items():
        result += ("\tif (")
        for samechr in char:
            result += ("mychar == ")
            result += ("\""+ chr(samechr) +"\""+ " || ")
        result = result.rstrip(" |")
        result += ")\n\t\twx"
        if diff < 0:
            result += (" -= " + str(abs(diff)) + "\n")
        else:
            result += (" += " + str(abs(diff)) + "\n")
    result += "}\n"
    return result

#if args.output == std:
print(dothemagicstuff())
