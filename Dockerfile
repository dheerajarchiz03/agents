FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential git curl && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -e . \
    && pip install flask "livekit-agents"

# Add health endpoint
COPY health.py /app/health.py

EXPOSE 5000

# Start Flask (background) and LiveKit agent
CMD python /app/health.py & exec python -m livekit.agents.examples.basic_agent

