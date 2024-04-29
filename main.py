
import random
import string
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlitedict import SqliteDict

app = FastAPI()

content_store = SqliteDict("mydata.sqlite", autocommit=True)

def generate_short_url(length: int = 6) -> str:
    characters = string.ascii_letters + string.digits
    short_url = "".join(random.choice(characters) for _ in range(length))
    return short_url

class ContentRequest(BaseModel):
    content: str

class ShortURLResponse(BaseModel):
    id: str

@app.post("/api/save", response_model=ShortURLResponse)
def save_content(content_req: ContentRequest):
    short_url = generate_short_url()
    content_store[short_url] = content_req.content
    return {"id": short_url}

@app.get("/api/{short_url}")
def get_content(short_url: str):
    if short_url not in content_store:
        raise HTTPException(status_code=404, detail="ID not found")
    return content_store[short_url]

class ShareRequest(BaseModel):
    expression: str

class ShareResponse(BaseModel):
    short_url: str


@app.post("/api/share", response_model=ShareRequest)
def share_expression(share_req: ShareRequest):
    try:
        # Evaluate the expression
        result = eval(share_req.expression)

        # Generate short URL (for simplicity, using random characters)
        short_url = ''.join(random.choices(string.ascii_letters + string.digits, k=6))

        # Store the result in the content store using the short URL
        content_store[short_url] = result

        # Return the short URL as the response
        return {"short_url": short_url}

    except Exception as e:
        # If an error occurs during evaluation, return an error response
        raise HTTPException(status_code=400, detail=str(e))



if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=10000)

