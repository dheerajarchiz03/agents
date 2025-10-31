FROM python:3.12-slim

WORKDIR /app

# Prevent Python from buffering logs and writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app

# Upgrade pip and install dependencies directly from pyproject
RUN pip install --upgrade pip setuptools wheel && pip install -e .

# Expose port
EXPOSE 5000

# Run basic agent example
CMD ["python", "-m", "livekit_agents.examples.basic_agent"]
