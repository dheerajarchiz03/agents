FROM python:3.12-slim

WORKDIR /app

# Prevent Python from buffering logs and writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app

# Upgrade pip and install dependencies
RUN pip install --upgrade pip setuptools wheel && pip install -e .

# Install Flask for heartbeat server
RUN pip install flask

# Create simple HTTP heartbeat for Coolify
COPY health.py /app/health.py

# Expose port 5000 for Flask
EXPOSE 5000

# Use bash to start both Flask and LiveKit agent in parallel
CMD python /app/health.py & exec python -m livekit_agents.examples.basic_agent

