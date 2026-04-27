FROM node:20-alpine

WORKDIR /app

COPY .output ./.output

ENV HOST=0.0.0.0
ENV PORT=3001
ENV NODE_ENV=production

EXPOSE 3001

CMD ["node", ".output/server/index.mjs"]
