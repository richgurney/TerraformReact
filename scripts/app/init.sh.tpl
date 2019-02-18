#!/bin/bash

cd /home/ubuntu/app
export DB_HOST=${db_host}
node seeds/seed.js
pm2 start app.js
