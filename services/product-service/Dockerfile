FROM node:18-alpine AS base

WORKDIR /user/src/app

COPY package*.json ./

FROM base AS development
ENV NODE_ENV=development
RUN apk add --no-cache curl dos2unix
RUN npm install
COPY . .
EXPOSE 3000
CMD sh -c "dos2unix ./init-products.sh || true && sh ./init-products.sh & npm run dev"

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1


FROM base AS production

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN npm install --omit=dev

COPY . .

RUN chown -R appuser:appgroup /user/src/app

USER appuser

EXPOSE 3000

CMD ["npm", "start"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1