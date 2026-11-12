# Frontend — DEV imajı (Next.js dev server, hot reload). Prod imajı TASK-021'de.
# Build context: frontend/  (bkz. infra/docker-compose.yml)
FROM node:20-alpine

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

ENV NEXT_TELEMETRY_DISABLED=1
EXPOSE 3000

# Sözleşme: `npm run dev` 0.0.0.0 üzerinde $PORT'u dinlemeli (infra/README.md).
CMD ["npm", "run", "dev"]
