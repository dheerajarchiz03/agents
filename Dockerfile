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
# Add simple HTTP heartbeat for Coolify
RUN pip install flask
COPY <<EOF /app/health.py
from flask import Flask
app = Flask(__name__)
@app.route('/')
def ok(): return 'OK', 200
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF
CMD ["python", "health.py"]

# Run basic agent example
CMD ["python", "-m", "livekit_agents.examples.basic_agent"]
