FROM node:18-alpine AS base

WORKDIR /user/src/app

COPY package*.json ./

FROM base AS development
ENV NODE_ENV=development
RUN npm install
COPY . .
EXPOSE 3002
CMD ["npm", "run", "dev"]

FROM base AS production
ENV NODE_ENV=production
RUN npm ci --only=production
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY . .
RUN chown -R appuser:appgroup /user/src/app
USER appuser
EXPOSE 3002

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3002/api/health || exit 1

CMD ["npm", "start"]
