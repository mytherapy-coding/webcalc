from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlitedict import SqliteDict
import string
import random

app = FastAPI()

# Initialize a SqliteDict instance for data storage
content_store = SqliteDict("mydata.sqlite", autocommit=True)

class ShareRequest(BaseModel):
    expression: str

class ShareResponse(BaseModel):
    short_url: str

@app.post("/api/share", response_model=ShareResponse)
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
    uvicorn.run(app, host="localhost", port=5000)
