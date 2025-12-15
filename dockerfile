FROM node:24-alpine as build

WORKDIR /app

# copy package.json
COPY package*.json /.

# copy file
copy . .

RUN npm run build

# --------- Runtime stage  ------------
FROM nginx:1.25-alpine
# remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# custome nginx config
COPY /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# COPY built assest
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
