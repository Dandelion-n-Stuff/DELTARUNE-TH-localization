import subprocess
import json
import sys
import os

if len(sys.argv) <= 1:
    print("Not enough arguments. Usage: python . [file]")
    exit()

filename = os.path.basename(sys.argv[1]).split(".")[0]

subprocess.call(f"prettier {sys.argv[1]} > {filename}Prettified.yy", shell=True)

prettified = f"{filename}Prettified.yy"
with open(prettified) as f:
    data = json.loads(f.read())

os.remove(prettified)

for char, entry in data["glyphs"].items():
    for k in entry:
        if k == "character":
            continue
        data["glyphs"][char][k] *= 2

with open(f"{filename}Scaled.yy", "w") as f:
    f.write(json.dumps(data, indent=4))

