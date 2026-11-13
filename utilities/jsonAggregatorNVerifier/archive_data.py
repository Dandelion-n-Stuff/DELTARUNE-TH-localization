from rapidjson import Decoder, PM_COMMENTS, PM_TRAILING_COMMAS
import os
from os import path

def get_data(target: str = "data"):
    keys = {}

    decoder = Decoder(parse_mode=PM_COMMENTS | PM_TRAILING_COMMAS)
    for file in os.listdir(target):
        print(f"Reading file: {file}")
        with open(path.join(target, file)) as f:
            keys.update(decoder(f.read()))
    
    return keys

if __name__ == "__main__":
    print(get_data())

