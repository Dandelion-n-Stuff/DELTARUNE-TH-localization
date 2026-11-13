#!/usr/bin/python3

"""
Usage: python fill_missing_keys.py [FILE] [ARCHIVE]

Copy keys from ARCHIVE with values from FILE into a new archive. ARCHIVE is expected to be a folder. FILE defaults to "lang_th.json" and ARCHIVE defaults to "data"

Add missing keys to language file

Outputs to ARCHIVE.out
"""

from rapidjson import Decoder, PM_COMMENTS, PM_TRAILING_COMMAS
import json
import sys
import shutil
import os
from os import path

archive_dir = "data"
file_name = "lang_th.json"

if len(sys.argv) > 1:
    file_name = sys.argv[1]

if len(sys.argv) > 2:
    archive_dir = sys.argv[2]

lang_data = None

with open(file_name) as f:
    lang_data = json.load(f)

lang_keys = set(lang_data.keys())

output = archive_dir + ".out"
shutil.copytree(archive_dir, output, dirs_exist_ok=True)

decoder = Decoder(parse_mode=PM_COMMENTS | PM_TRAILING_COMMAS)

for name in os.listdir(output):
    filepath = path.join(output, name)
    data = {}
    with open(filepath, 'r') as f:
        data = decoder(f.read())

    for k in data.keys():
        data[k] = lang_data.get(k) or ""
    
    with open(filepath, 'w') as f:
        json.dump(data, f, indent=4, sort_keys=True, ensure_ascii=False)

