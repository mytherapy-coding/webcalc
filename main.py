import random
import string
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlitedict import SqliteDict
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)


# Health check API endpoint
@app.get("/api/health")
def health_check():
    return {"status": "ok", "message": "Application is healthy"}


content_store = SqliteDict("mydata.sqlite", autocommit=True)


def generate_short_url(length: int = 6) -> str:
    characters = string.ascii_letters + string.digits
    short_url = "".join(random.choice(characters) for _ in range(length))
    return short_url


class ContentRequest(BaseModel):
    content: str


class ShortURLResponse(BaseModel):
    short_url: str


@app.post("/api/save", response_model=ShortURLResponse)
def save_content(content_req: ContentRequest):
    short_url = generate_short_url()
    content_store[short_url] = content_req.content
    return {"short_url": short_url}


@app.get("/api/{short_url}")
def get_content(short_url: str):
    if short_url not in content_store:
        raise HTTPException(status_code=404, detail="ID not found")
    return content_store[short_url]


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=10000)
