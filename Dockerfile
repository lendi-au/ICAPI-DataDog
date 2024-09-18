FROM python:3.11.4-alpine3.18

# Need python3 dependencies
RUN apk add build-base --update
# Generic container setup
WORKDIR /usr/app
RUN addgroup -g 1001 -S appgroup && \
adduser -u 1001 -S appuser -G appgroup && \
chown -R appuser:appgroup /usr/app
USER appuser

# Dependency setup
COPY requirements.txt.lock .
RUN pip install -r requirements.txt.lock --user

# App setup
ENV DD_API_KEY DD_APP_KEY
COPY instaclustr instaclustr
COPY localdatadog localdatadog
ADD ic2datadog.py .

CMD ["python", "ic2datadog.py"]
