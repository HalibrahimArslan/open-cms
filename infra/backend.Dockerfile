# Backend — DEV imajı (hot reload). Prod imajı TASK-021'de ayrı hazırlanacak.
# Build context: backend/  (bkz. infra/docker-compose.yml)
FROM node:20-alpine

# Prisma'nın alpine üzerinde ihtiyaç duyduğu kütüphane
RUN apk add --no-cache openssl

WORKDIR /app

# Önce yalnızca manifest'ler: bağımlılık katmanı cache'lenir
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Prisma client üret (schema yoksa sessizce geç)
RUN if [ -f prisma/schema.prisma ]; then npx prisma generate; fi

EXPOSE 4000

# Başlangıçta migration'ları uygula, sonra dev sunucusunu başlat.
# Sözleşme: `npm run db:migrate` ve `npm run dev` tanımlı olmalı (infra/README.md).
CMD ["sh", "-c", "npm run db:migrate && npm run dev"]
