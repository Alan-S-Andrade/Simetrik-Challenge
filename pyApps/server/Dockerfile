FROM python:3.8-slim

WORKDIR /app

COPY server.py /app/
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "server.py"]
