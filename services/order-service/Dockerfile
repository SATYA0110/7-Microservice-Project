FROM python:3.11-alpine AS build
WORKDIR /app
RUN apk add --no-cache build-base libffi-dev
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt
FROM python:3.11-alpine
WORKDIR /app
RUN addgoup -g 10006 orderuser && adduser -u 10006 -G orderuser -D -S orderuser
COPY --from=build /root/.local /home/oderuser/.local
COPY . .
ENV PATH=/home/orderuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
RUN chown -R orderuser:orderuser /app
USER orderuser
EXPOSE 8080
CMD ["python" , "main.py"] 
