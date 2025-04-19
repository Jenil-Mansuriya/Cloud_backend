FROM python:3.11.8-slim-bookworm

# Set environment variables
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install pip and upgrade
RUN pip install --upgrade pip

# Install essential tools, QEMU, and compilers/interpreters for x86, ARM, MIPS
RUN apt-get update && apt-get install -y \
    nasm \
    gcc \
    g++ \
    qemu-user \
    qemu-user-static \
    binfmt-support \
    binutils \
    make \
    build-essential \
    gcc-arm-linux-gnueabi \
    binutils-arm-linux-gnueabi \
    spim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Register qemu interpreters (mostly optional in Docker, but doesn't hurt)
RUN update-binfmts --enable qemu-arm && \
    update-binfmts --enable qemu-mips && \
    update-binfmts --enable qemu-mipsel

# Set working directory
WORKDIR /app

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files
COPY . .

# Expose the app port
EXPOSE 5001

# Run your app (Render will inject $PORT)
CMD gunicorn -b 0.0.0.0:$PORT cloud_backend:app
