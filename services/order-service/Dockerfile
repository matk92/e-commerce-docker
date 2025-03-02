FROM node:18-alpine as base

WORKDIR /app

COPY package*.json ./

FROM base as development
ENV NODE_ENV=development
RUN npm install
COPY . .
EXPOSE 3002
CMD ["npm", "run", "dev"]

FROM base as production
ENV NODE_ENV=production
RUN npm ci --only=production
COPY . .
EXPOSE 3002

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3002/health || exit 1

CMD ["npm", "start"]
