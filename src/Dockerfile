FROM python:3.12-slim
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 5000

ENV DB_USER=idubi
ENV DB_PASSWORD=idubi
ENV DB_NAME=idubi
ENV DB_TYPE=postgresql
ENV DB_HOST=$DB_HOST
# win : DB_HOST=host.docker.internal
# lin : DB_HOST=172.17.0.1




ENV DB_PORT=5432
CMD ["flask", "run", "--host=0.0.0.0"]
