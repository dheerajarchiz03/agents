FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y build-essential git curl && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pip install --upgrade pip setuptools wheel \
    && pip install -e . \
    && pip install flask "livekit-agents"

COPY health.py /app/health.py

EXPOSE 5000

CMD python /app/health.py & exec livekit-agents
