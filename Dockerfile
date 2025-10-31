FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# System deps (added curl)
RUN apt-get update && apt-get install -y build-essential git curl && rm -rf /var/lib/apt/lists/*

# Copy files
COPY . /app

# Install dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -e . \
    && pip install flask livekit-agents
RUN apt-get update && apt-get install -y build-essential git curl && rm -rf /var/lib/apt/lists/*

# Add health endpoint
COPY health.py /app/health.py

EXPOSE 5000

# Start both Flask and LiveKit Agent
CMD python /app/health.py & exec python -m livekit_agents.examples.basic_agent
