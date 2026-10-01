# --- Build Stage ---
FROM python:3.11-slim AS builder

WORKDIR /app

# Install system dependencies required for building psycopg2 (PostgreSQL adapter)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy only the requirements file first to leverage Docker layer caching
COPY requirements.txt .

# Install dependencies into a localized wheel folder
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Final Runner Stage ---
FROM python:3.11-slim AS runner

WORKDIR /app

# Install runtime library needed by psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed python dependencies from the builder stage
COPY --from=builder /root/.local /root/.local
COPY main.py .

# Add local site-packages to python path
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

# Expose FastAPI default port
EXPOSE 8000

# Run the application using Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
