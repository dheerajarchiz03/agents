FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    git curl build-essential python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

# Install dependencies and LiveKit Agents manually
RUN pip install --upgrade pip setuptools wheel \
    && pip install flask livekit \
    && git clone https://github.com/livekit/agents.git /tmp/agents \
    && pip install /tmp/agents/sdk/python \
    && pip install /tmp/agents

COPY health.py /app/health.py

EXPOSE 5000

CMD python /app/health.py & exec python -m livekit.agents.examples.basic_agent
