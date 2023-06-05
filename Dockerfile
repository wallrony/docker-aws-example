FROM node:16

WORKDIR /code

COPY package.json tsconfig.json index.html tsconfig.node.json vite.config.ts /code/
COPY src /code/src

RUN npm install
RUN npm run build -- /code/
RUN npm install -g serve

CMD ["serve", "-s", "/code/build", "-l", "80"]
