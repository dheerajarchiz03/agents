FROM python:3.12-slim

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git curl build-essential && rm -rf /var/lib/apt/lists/*

COPY . /app

# Install Flask, LiveKit SDK, and LiveKit Agents directly from GitHub
RUN pip install --upgrade pip setuptools wheel flask \
    && pip install livekit \
    && pip install "git+https://github.com/livekit/agents.git@main#subdirectory=python"

COPY health.py /app/health.py

EXPOSE 5000

CMD ["bash", "-c", "python /app/health.py & exec python -m livekit.agents.examples.basic_agent"]
