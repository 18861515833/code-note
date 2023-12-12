ngx_module_t 是描述一个nginx模块的基本数据结构, nginx所有的功能都离不开基本的模块

nginx模块提供了一些nginx整体流程内的钩子函数

```c
ngx_int_t (*init_master)(ngx_log_t *log);  // 无用, 代码中并没有实现
ngx_int_t (*init_module)(ngx_cycle_t *cycle); // master进程在配置解析完成后, 执行模块初始化工作
ngx_int_t (*init_process)(ngx_cycle_t *cycle); // 在worker进程生成之后, 正式逻辑开始之前
void (*exit_process)(ngx_cycle_t *cycle); // worker进程退出时调用
void (*exit_master)(ngx_cycle_t *cycle); // master进程退出时调用
```

每个nginx 模块, 不管是属于core模块, http模块, event模块, 都可以有上述钩子函数

每个nginx 模块的conf结构体都不一样, 需要模块自行定义和组织, 在nginx中使用void* 保存在cycle->conf_ctx中, 使用时做对应的结构体类型转换



nginx http模块提供了一些通用的http流程内的钩子函数

```c
// 
ngx_int_t (*preconfiguration)(ngx_conf_t *cf);
ngx_int_t (*postconfiguration)(ngx_conf_t *cf);
void *(*create_main_conf)(ngx_conf_t *cf);
char *(*init_main_conf)(ngx_conf_t *cf, void *conf);

void *(*create_srv_conf)(ngx_conf_t *cf);
char *(*merge_srv_conf)(ngx_conf_t *cf, void *prev, void *conf);

void *(*create_loc_conf)(ngx_conf_t *cf);
char *(*merge_loc_conf)(ngx_conf_t *cf, void *prev, void *conf);
```



