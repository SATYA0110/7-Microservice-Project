FROM python:3.11-alpine AS build
WORKDIR /app
RUN apk add --no-cache build-base libffi-dev postgresql-dev
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.11-alpine
WORKDIR /app

# Fixed the typo "addgoup" to "addgroup"
RUN addgroup -g 10006 orderuser && adduser -u 10006 -G orderuser -D -S orderuser

# Fixed the typo "oderuser" to "orderuser"
COPY --from=build /root/.local /home/orderuser/.local
# Fixed "COPY .." to explicitly copy files to the current working directory
COPY . .

ENV PATH=/home/orderuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

RUN chown -R orderuser:orderuser /app
USER orderuser

EXPOSE 8080
# Make sure your main.py file invokes uvicorn on port 8080
CMD ["python", "main.py"]
