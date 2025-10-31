FROM python:3.12-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# use noninteractive, reduce apt noise, avoid timeout
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pip install --upgrade pip setuptools wheel flask \
 && git clone https://github.com/livekit/agents.git /tmp/agents \
 && pip install /tmp/agents/sdk/python /tmp/agents

EXPOSE 5000
CMD python -m livekit.agents.examples.basic_agent
