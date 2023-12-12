# break

```
Syntax:	break;
Default:	—
Context:	server, location, if
```

跳过后续所有的rewrite脚本指令执行,   http阶段接着在本location内往后处理

通过把脚本指令数组中插入一个NULL命令实现, 并且r->uri_changed置为0, 不再重复进行location查找



# if

```
Syntax:	if (condition) { ... }
Default:	—
Context:	server, location
```

if可以进行一些简单的判断, 如果条件为真, 则执行后续逻辑块内的指令

注意点‼️: if指令{}会生成一个location配置块, 继承上级配置并且合并, 如果条件符合, 会执行这个location块内的配置(将if块对应的loc_conf 赋给r->loc_conf), 然后回到rewrite脚本数组执行环境, 继续往后执行

如果对应上述逻辑, 做以下测试

* server块内的if, 理论上除了return和rewrite, 其他nginx配置均无法生效

  想使用limit_rate做测试, 但是发现limit_rate无法在server的if内使用, 可以算从侧面印证了猜想

其他的指令也是类似, 大部分非rewrite模块生效的命令, 都是不支持server 的if

* 两个if块都满足的情况下, 理论上按照第二个locaiton块生效

```nginx
locaiton  / {
  set $k true;
  if ($k) {
    	root html1;
  }
  if ($k) {
    	root html2;
  }
  root html;
}
```

测试结果: 在html2目录下查找文件

结论: 确实按照第二个if块生效,  同时root指令的出现顺序, 也没有影响, 只按照配置块继承逻辑, 跟出现的先后顺序无关

* 理论上rewrite脚本指令会保存上下文, 执行完if后, 继续从上次的地方接着执行rewrite脚本数组

```nginx
set $k 1;
locaiton / {
  	set $k ${k}2;
    if ($lurl) {
    	#break
			set $k ${k}3;
		}
		set $k ${k}4;
		return 200 $k;
}
```

测试结果: 1234

结论: 先执行locaiton内的脚本数组, 到if块后进入块内接着执行, 最后继续回到locaiton块执行

⚠️: 这里如果在if块内加入一个break呢, 会出现什么情况?

测试结果: 返回404, 没有走到locaiton块内的return命令, 直接走了默认的查找文件处理

✅: 实际上真正的逻辑是if块中的rewrite模块中的脚本指令, 还是按照顺序挂载在locaiton块内,  if 条件满足则执行, 不满足不执行(通过next指针转跳到locaiton块内的下一条命令)

# return

```
Syntax:	return code [text];
return code URL;
return URL;
Default:	—
Context:	server, location, if
```

直接返回给客户端响应, 可以指定状态码和响应内容, 也可以构造重定向状态码以及重定向url



# rewrite 

```
Syntax:	rewrite regex replacement [flag];
Default:	—
Context:	server, location, if
```

改写url

各种flag含义

* last 终止脚本指令数组执行, 重新进入find config阶段
* break 同break指令, 终止脚本指令数组执行, 继续在本locaiton内往后执行
* redirect , 返回302
* permanent, 返回301



# set

```
Syntax:	set $variable value;
Default:	—
Context:	server, location, if
```

定义变量,  可以使用复合变量

