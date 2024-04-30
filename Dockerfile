# Use the official Python 3.12 image as the base image
FROM python:3.12

# Set the working directory inside the container
WORKDIR /app

# Set the command to run your Python application when the container starts
CMD ["uvicorn", "main:app", "--reload", "--port", "10000"]

# Copy the requirements.txt file into the container
COPY reqs.txt .

# Install the Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r reqs.txt

# Copy the main.py file into the container
COPY main.py .
