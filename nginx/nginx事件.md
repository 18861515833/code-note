nginx发送响应逻辑

```
nginx的header_filter和body_filter最终都是调用这个发送函数
ngx_http_write_filter


ngx_http_finalize_request可能会调用下面的函数进行数据发送
ngx_http_set_write_handler
ngx_http_writer
```







