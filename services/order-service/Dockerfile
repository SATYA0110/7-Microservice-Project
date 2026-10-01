# Stage 1: Build & compile Python package wheels
FROM python:3.11-slim AS builder
WORKDIR /app

# Install compilation headers required for database connectors like psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install python execution bundle dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Minimal runtime image
FROM python:3.11-slim
WORKDIR /app

# Install bare-minimum runtime client library for PostgreSQL
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Add a secure non-root systems worker account
RUN adduser --disabled-password --gecos "" orderuser

# Copy installed dependencies cleanly from the builder stage
COPY --from=builder /root/.local /home/orderuser/.local
COPY . .

# Update path execution environments to locate the copied wheel binaries
ENV PATH=/home/orderuser/.local/bin:$PATH
RUN chown -R orderuser:orderuser /app
USER orderuser

# Explicitly match the architectural network port your Python app listens on
# Expose the correct application port
EXPOSE 8080

# Serve the application instance via Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
