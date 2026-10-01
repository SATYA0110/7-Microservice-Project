# Stage 1: Build & compile Python dependencies
FROM python:3.11-slim AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a clean virtual environment container
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Minimal non-root runtime environment
FROM python:3.11-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Add a secure system worker account
RUN adduser --disabled-password --gecos "" orderuser

# Copy the entire compiled virtual environment over to the runtime stage
COPY --from=builder /opt/venv /opt/venv
COPY . .

# Ensure the app runtime execution paths point cleanly to the virtual environment binaries
ENV PATH="/opt/venv/bin:$PATH"

# Grant the non-root execution user clear folder ownership
RUN chown -R orderuser:orderuser /app /opt/venv
USER orderuser

EXPOSE 8080

# Clean Uvicorn module target invocation syntax
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
