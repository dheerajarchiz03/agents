FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y build-essential git curl && rm -rf /var/lib/apt/lists/*

COPY . /app

# Install dependencies properly
RUN pip install --upgrade pip setuptools wheel \
    && pip install -e . \
    && pip install flask \
    && pip install "livekit>=0.17.0" \
    && pip install "git+https://github.com/livekit/agents.git@main"

COPY health.py /app/health.py

EXPOSE 5000

CMD python /app/health.py & exec python -m livekit_agents.examples.basic_agent
