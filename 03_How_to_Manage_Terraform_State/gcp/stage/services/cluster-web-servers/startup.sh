#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World</h1>
<p>DB connection string: ${connection_name}</p>
EOF

nohup busybox httpd -f -p ${server_port} &