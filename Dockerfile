# Dockerfile
ARG AIRFLOW_IMAGE=apache/airflow:2.9.0-python3.12
FROM ${AIRFLOW_IMAGE}

USER root

# Install system dependencies for various database connectors
RUN apt-get update && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    odbcinst \
    libodbc1 \
    gcc \
    python3-dev \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Microsoft ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-prod.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt /tmp/requirements.txt

# Switch to airflow user and install python deps as that user into the user's site-packages
USER airflow

# Install packages into the airflow user's environment
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r /tmp/requirements.txt