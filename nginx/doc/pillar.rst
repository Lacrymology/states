Pillar
======

Optional
--------

Example::

  nginx:
    worker_processes: 1
    redirect_numeric_ip: False
    log_format: $scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user "$request" $request_time $request_length:$bytes_sent $status "$http_referer" "$http_user_agent" "$http_x_forwarded_for


nginx:worker_processes
~~~~~~~~~~~~~~~~~~~~~~

Number of nginx worker.

Default: ``1`` by default of that pillar key.

nginx:log_format
~~~~~~~~~~~~~~~~

The format of log in nginx log file.

Default: $scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user
"$request" $request_time $request_length:$bytes_sent $status "$http_referer"
"$http_user_agent" "$http_x_forwarded_for.

Default: ``$scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user "$request" $request_time $request_length:$bytes_sent $status "$http_referer" "$http_user_agent" "$http_x_forwarded_for`` 
by default of that pillar key.

nginx:redirect_numeric_ip
~~~~~~~~~~~~~~~~~~~~~~~~~

Default: ``False`` by default of that pillar key.