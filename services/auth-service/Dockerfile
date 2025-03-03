FROM node:18-alpine AS base

WORKDIR /user/src/app

COPY package*.json ./

FROM base AS development
ENV NODE_ENV=development
RUN npm install
RUN npm install -g nodemon
COPY . .
EXPOSE 3001
CMD ["npm", "run", "dev"]

FROM base AS production
ENV NODE_ENV=production
RUN npm ci --only=production
COPY . .
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
EXPOSE 3001
CMD ["npm", "start"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3001/api/health || exit 1