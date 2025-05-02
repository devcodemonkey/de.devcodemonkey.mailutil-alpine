## 🛠️ Use of the Container

## 📬 alpine-mailutil – Lightweight Email Sender with `msmtp`

This container allows you to send simple emails from a Docker container using Alpine Linux and `msmtp`. It supports:

- SMTP with or without authentication
- TLS with optional certificate verification
- Custom sender, recipient, subject, and body
- Mounted custom TLS certificates

---

### 🚀 Basic Usage

Run the container with the required environment variables:

```bash
docker run --rm \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=25 \
  -e FROM=ci@example.com \
  -e TO=devteam@example.com \
  -e SUBJECT="Notification from CI" \
  -e BODY="Your job completed successfully." \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### 🔐 Example with SMTP Authentication

```bash
docker run --rm \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=587 \
  -e SMTP_USER=user@example.com \
  -e SMTP_PASS=supersecret123 \
  -e FROM=user@example.com \
  -e TO=admin@example.com \
  -e SUBJECT="Mail with Auth" \
  -e BODY="This message uses SMTP authentication." \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### 🔒 Skip TLS Certificate Check (for internal/testing)

```bash
docker run --rm \
  -e SMTP_SERVER=mail.internal.example.com \
  -e SMTP_PORT=25 \
  -e FROM=ci@internal.example.com \
  -e TO=alerts@example.com \
  -e SUBJECT="Skip TLS Check" \
  -e BODY="This skips TLS certificate validation." \
  -e TLS_CERTCHECK=off \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### 📄 Using a Mounted TLS Certificate

```bash
docker run --rm \
  -v "$PWD/certs:/certs:ro" \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=587 \
  -e FROM=noreply@example.com \
  -e TO=admin@example.com \
  -e SUBJECT="Secure Mail" \
  -e BODY="This email uses a mounted CA cert for TLS." \
  -e TLS_CERT_PATH=/certs/smtp.pem \
  registry.hl-dev.de/alpine-mailutil:latest
```

---

### ✅ Required Environment Variables

| Variable      | Description                       |
| ------------- | --------------------------------- |
| `SMTP_SERVER` | SMTP host to connect to           |
| `SMTP_PORT`   | Port number (usually 25 or 587)   |
| `FROM`        | Sender email address              |
| `TO`          | Recipient email address (or list) |
| `SUBJECT`     | Subject line of the email         |
| `BODY`        | Body of the email                 |

---

### ⚙️ Optional Environment Variables

| Variable        | Description                                         |
| --------------- | --------------------------------------------------- |
| `SMTP_USER`     | SMTP username (if authentication is needed)         |
| `SMTP_PASS`     | SMTP password                                       |
| `TLS_CERT_PATH` | Path to a mounted TLS cert (e.g. `/certs/smtp.pem`) |
| `TLS_CERTCHECK` | Set to `off` to disable cert verification           |

## 📦 Image Versions

<!-- VERSION_START -->
