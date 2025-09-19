FROM python:3.11-slim

WORKDIR /app
ENV PYTHONUNBUFFERED=1

RUN pip install uv

COPY pyproject.toml uv.lock ./
RUN uv sync --no-cache

COPY main.py .

# create non-root user
RUN useradd -m -u 1000 mcpuser && \
    chown -R mcpuser:mcpuser /app
USER mcpuser

CMD ["uv", "run", "main.py"]