# Production Docker container for Explainable RL Energy Asset Controller
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install pinned Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir "numpy==1.26.4" "scikit-learn<=1.2.2" "gymnasium==0.28.1" "stable-baselines3==2.0.0" "simplejson" "pyyaml" "matplotlib" "seaborn" "lz4" "scipy" "pytest" && \
    pip install --no-cache-dir --no-deps "citylearn==3.0.2" && \
    pip install --no-cache-dir -r requirements.txt || true

# Copy application source
COPY . .

# Run test suite by default
CMD ["pytest", "tests/", "-v"]
