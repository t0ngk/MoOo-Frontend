FROM node:18.10.0-alpine AS base
WORKDIR /app
COPY package.json ./

FROM base AS build
RUN npm install
COPY . .
RUN npm run build

FROM base AS release
COPY --from=build /app/build ./
COPY --from=build /app/node_modules ./node_modules

EXPOSE 3000

CMD [ "node", "index.js" ]
