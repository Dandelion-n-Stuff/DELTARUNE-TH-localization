import archive_data
import json

output = "missing_keys.json"
archive = set(archive_data.get_data().keys())
keys = set()

with open("lang_en.json") as f:
    keys = set(json.load(f).keys())    

diff = keys - archive

if len(diff) == 0:
    print("No missing keys")
else:
    print(f"{len(diff)} missing keys:\n")
    
    for k in diff:
        print(k)

    print(f"\nAlso saving as: {output}")
    with open(output, 'w') as f:
        json.dump(list(diff), f, indent=4)

