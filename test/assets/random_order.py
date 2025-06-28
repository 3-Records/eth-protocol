import json
import random
from pathlib import Path

# Define your image/description/amount variations
variations = [
    {
        "image": "ipfs://QmXg97GmEx9w5Tyirpe9obkpnj7rf6JqeEXc3YxZrKdRrM/slap.PNG",
        "description": "Dude, that's fucked up",
        "amount": 200
    },
    {
        "image": "ipfs://QmXg97GmEx9w5Tyirpe9obkpnj7rf6JqeEXc3YxZrKdRrM/drop.JPG",
        "description": "Let me drop him, Ella",
        "amount": 100
    },
    {
        "image": "ipfs://QmXg97GmEx9w5Tyirpe9obkpnj7rf6JqeEXc3YxZrKdRrM/tough.JPG",
        "description": "Fireworks, anyone?",
        "amount": 500
    },
    {
        "image": "ipfs://QmXg97GmEx9w5Tyirpe9obkpnj7rf6JqeEXc3YxZrKdRrM/claw.JPG",
        "description": "Bro, do you think he drinks?",
        "amount": 160
    },
    {
        "image": "ipfs://QmXg97GmEx9w5Tyirpe9obkpnj7rf6JqeEXc3YxZrKdRrM/movva.JPG",
        "description": "Dude, that's fucked up",
        "amount": 40
    }
]

# Shared metadata base
base_metadata = {
    "name": "Test Record",
    "artist": "Timothy Keegan",
    "animation_url": "ipfs://QmefSHfNk8vgYjpKDPsGjm9J2oMQMsS2wUH7FMiyEaVHZF?filename=player.html",
    "songs": [
        {
            "track": 1,
            "title": "Dogdays",
            "artist": "Timothy Keegan",
            "duration": "1:57",
            "audio": "ipfs://QmPoDCJ87SYdTvQ5vdFWxKL3SQrmeNnf7P3RnUuAsfpTd3/dogdays.ogg"
        },
        {
            "track": 2,
            "title": "Why Should I?",
            "artist": "Timothy Keegan",
            "duration": "1:53",
            "audio": "ipfs://QmPoDCJ87SYdTvQ5vdFWxKL3SQrmeNnf7P3RnUuAsfpTd3/why_should_i.ogg"
        },
        {
            "track": 3,
            "title": "Lady May",
            "artist": "Timothy Keegan",
            "duration": "2:36",
            "audio": "ipfs://QmPoDCJ87SYdTvQ5vdFWxKL3SQrmeNnf7P3RnUuAsfpTd3/lady_may.ogg"
        }
    ]
}

# Output directory
output_dir = Path("metadata")
output_dir.mkdir(exist_ok=True)

# Step 1: Build full metadata list
metadata_list = []

for variation in variations:
    for _ in range(variation["amount"]):
        entry = base_metadata.copy()
        entry["image"] = variation["image"]
        entry["description"] = variation["description"]
        metadata_list.append(entry)

# Step 2: Shuffle to randomize order
random.shuffle(metadata_list)

# Step 3: Write to files with index-based filenames
for idx, metadata in enumerate(metadata_list):
    metadata["tokenId"] = idx
    with open(output_dir / f"{idx}.json", "w") as f:
        json.dump(metadata, f, indent=2)

print(f"✅ Generated {len(metadata_list)} randomized metadata files in '{output_dir}/'")