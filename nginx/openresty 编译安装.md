# 适用环境

* centos
* macos
* 其他环境可能需要修改部分命令，整体步骤不变，可以自行尝试

# 下载pcre源码

```
cd /usr/local/
wget http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.gz
tar -zxvf pcre-8.35.tar.gz
```

# 下载openssl源码

```
cd /usr/local/
wget http://www.openssl.org/source/openssl-1.1.1k.tar.gz
tar -zxvf openssl-1.1.1k.tar.gz
```

# 下载openresty源码

```
cd /usr/local
wget https://openresty.org/download/openresty-1.19.3.1.tar.gz
tar -zxvf openresty-1.19.3.1.tar.gz
```



# configure

```
cd /usr/local/openresty-1.19.3.1
./configure --prefix=/usr/local/openresty --with-pcre=/usr/local/pcre-8.35/ --with-openssl=/usr/local/openssl-1.1.1k
```

--prefix指定openresty安装路径, 可以根据自己的需要自行更改

--with-http_v2_module 编译nginx http2功能

# configure 成功后

```
make
```

make 这一步骤耗时比较长，也比较容易报错，常见的错误原因有：

* 找不到pcre和openssl库，或者其他库。解决方法：检查库下载情况，路径是否对应
* 源码问题，直接报编译错误。解决方法：需要根据报错情况修改

# make 成功后

```
make install
```

# 检查安装情况

```
cd /usr/local/openresty/nginx
./sbin/nginx -V
```

报目录不存在，或者-V命令执行失败，安装有问题，请检查安装步骤

# 其他

如果想安装其他第三方nginx模块，或者加入自己编写的模块， 需要在configuge那一步通过命令。