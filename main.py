import json
import os
import random
import string

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlitedict import SqliteDict

# Create a SqliteDict object
db = SqliteDict("mydata.sqlite", autocommit=True)

# Store data
db['key1'] = 'value1'
db['key2'] = {'nested': 'value'}

# Retrieve data
print(db['key1'])  # Output: 'value1'

# Close the SqliteDict connection
db.close()


def load_mappings() -> dict[str, str]:
    """
    Load URL mappings from the 'data.json' file.

    Returns:
        dict: A dictionary containing the loaded URL mappings.
    """
    try:
        with open("data.json", "r", encoding="utf-8") as file:
            return json.load(file)
    except FileNotFoundError:
        return {}


def save_mappings(content_store: dict[str, str]):
    """
    Save URL mappings to the 'data.json' file.

    This function writes the current URL mappings to the 'data.json' file.
    If the file does not exist, it will be created.

    Note:
        This function overwrites the existing 'data.json' file.

    Raises:
        IOError: If there is an issue writing to the file.
    """
    with open("data1.json", "w", encoding="utf-8") as file:
        json.dump(content_store, file, indent=4)
    os.replace("data1.json", "data.json")


def generate_short_url() -> str:
    """
    Generate a random short URL.

    This function generates a random short URL by combining ASCII letters
    (both lowercase and uppercase) and digits. The length of the short URL
    is set to 6 characters by default, but you can adjust the length as needed.

    Returns:
        str: A randomly generated short URL.

    Example:
        >>> generate_short_url()
        'AbC12f'
    """
    characters = string.ascii_letters + string.digits
    short_url = "".join(random.choice(characters) for i in range(6))
    # You can adjust the length of the short URL
    return short_url


app = FastAPI()

# In-memory dictionary to store content associated with IDs
content_store: dict[str, str] = load_mappings()


class ContentRequest(BaseModel):
    content: str


class ShortURLResponse(BaseModel):
    id: str


@app.post("/api/save", response_model=ShortURLResponse)
def save_content(content_req: ContentRequest):
    print(content_store)
    # Generate a unique ID (for simplicity, using a simple incrementing number)
    short_url = generate_short_url()

    # Store the content in the in-memory dictionary
    content_store[short_url] = content_req.content
    save_mappings(content_store)
    
    # Return the generated ID
    return {"id": short_url}


@app.get("/api/{short_url}")
def get_content(short_url: str):
    print(content_store)
    # Check if the ID exists in the content_store
    if short_url not in content_store:
        raise HTTPException(status_code=404, detail="ID not found")

    # Retrieve and return the content associated with the ID
    return content_store[short_url]


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
