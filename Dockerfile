FROM python:3.11.8-slim-bookworm

# Set environment variables
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install pip and upgrade (inside the venv now)
RUN pip install --upgrade pip

# Set working directory
WORKDIR /app

# Copy requirement files
COPY requirements.txt .

# Install dependencies inside venv
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application
COPY . .

# Expose the port your app runs on
EXPOSE 5001

# Run your app
CMD ["gunicorn", "-b", "0.0.0.0:5001", "cloud_backend:app"]

