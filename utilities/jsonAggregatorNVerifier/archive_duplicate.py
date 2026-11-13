"""
Reads from a directory, maps out which key belongs to which file, and detect duplicates in the process

Logs duplicate keys, Output key_locations.json
"""

from rapidjson import Decoder, PM_COMMENTS, PM_TRAILING_COMMAS
import json
import os
from os import path

def get_data(target: str = "data"):
    data = {}

    decoder = Decoder(parse_mode=PM_COMMENTS | PM_TRAILING_COMMAS)
    for file in os.listdir(target):
        print(f"Reading file: {file}")
        with open(path.join(target, file)) as f:
            new = decoder(f.read())
            new_keys = set(new.keys())
            old_keys = set(data.keys())
            dupe = new_keys & old_keys

            if len(dupe) > 0:
                for k in dupe:
                    print(f"Duplicate key: {k} (collides with {data[k]})")
            
            for k in new_keys:
                data[k] = file 
    
    return data

if __name__ == "__main__":
    data = get_data()
    
    with open("key_locations.json", 'w') as f:
        json.dump(data, f, indent=4)

