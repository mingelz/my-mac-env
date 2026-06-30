# AGENTS.md

## 本文件更新策略
- 本文件仅简要说明项目特点，不描述技术细节，如果业务迭代不涉及架构变更不必更新此文档

## 开发环境
- 本机配置文件尽量遵循 XDG 规范

## Java 相关

## Javascript/Typescript 相关

## 数据库相关

- 设计表时，要保证每个表都包括 `id`, `created_at`, `updated_at` 列，以 MySQL 举例：

```sql
CREATE TABLE `table_name` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  ...
)
```
