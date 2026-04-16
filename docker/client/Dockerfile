FROM python:3.12-slim

WORKDIR /app

COPY client/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY client /app

EXPOSE 8000

CMD ["python", "app.py"]
