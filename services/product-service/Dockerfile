FROM node:18-alpine AS base

WORKDIR /user/src/app

COPY package*.json ./

FROM base AS development
ENV NODE_ENV=development
RUN npm install
RUN npm install -g nodemon
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1


FROM base AS production

RUN addgroup -S appgroup && adduser -S appuser -G appgroupn

RUN npm ci --only=production --no-optional

COPY . .

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

CMD ["node", "src/app.js"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1