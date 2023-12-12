# trailer

 trailer是一种HTTP消息头字段, 它用于在消息体之后传输附加的头部

使用curl一般看不到这种头部的响应, 可以使用nc命令模拟查看, 或者抓包查看

一般情况下, chunked响应的时候, 才会用到trailer补充header响应