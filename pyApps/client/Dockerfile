FROM python:3.8-slim

WORKDIR /app

COPY client.py /app/
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "client.py"]
