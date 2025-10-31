FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y build-essential git curl && rm -rf /var/lib/apt/lists/*

COPY . /app

# Install all dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -e . \
    && pip install flask \
    && pip install "livekit>=0.17.0" \
    && pip install "git+https://github.com/livekit/agents.git@main"

COPY health.py /app/health.py

EXPOSE 5000

# Launch healthcheck + basic LiveKit agent example
CMD python /app/health.py & exec python -m livekit.agents.examples.basic_agent
