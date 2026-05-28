# 边缘析锂知识图谱 - Neo4j导入数据

## 图谱结构

```
DesignParam --[INFLUENCED_BY]--> Mechanism --[HAS_MECHANISM]--> FailureMode
    |                                                              ^
    +-------------------[DIRECTLY_AFFECTS]-------------------------+
```

## 节点统计

| 标签 | 数量 | 说明 |
|------|------|------|
| FailureMode | 7 | 边缘析锂的二级分类失效模式 |
| Mechanism | 7 | 相关失效机理 |
| DesignParam | 19 | 影响因素的设计参数 |

## 关系统计

| 关系类型 | 数量 | 方向 | 含义 |
|----------|------|------|------|
| HAS_MECHANISM | 21 | 失效→机理 | 失效模式的主/辅机理 |
| INFLUENCED_BY | 26 | 机理→参数 | 机理受设计参数影响 |
| DIRECTLY_AFFECTS | 10 | 参数→失效 | 参数直接影响失效模式 |

## 文件说明

### CSV文件（用于neo4j-admin import或LOAD CSV）
- `nodes_failure_mode.csv` - 失效模式节点
- `nodes_mechanism.csv` - 机理节点
- `nodes_design_param.csv` - 设计参数节点
- `rels_failure_mechanism.csv` - 失效→机理关系
- `rels_mechanism_param.csv` - 机理→参数关系
- `rels_param_failure_direct.csv` - 参数→失效直接关系

### Cypher脚本
- `import_edge_lithium_plating.cypher` - 完整Cypher导入脚本

## 导入方式

### 方式一：Cypher脚本直接执行
```bash
cat import_edge_lithium_plating.cypher | cypher-shell -u neo4j -p <password>
```

### 方式二：LOAD CSV导入
```cypher
// 示例：加载失效模式节点
LOAD CSV WITH HEADERS FROM 'file:///nodes_failure_mode.csv' AS row
CREATE (:FailureMode {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, detectTime: row.detectTime});
```

## 涉及的原始数据ID

### 失效模式
F013, F014, F015, F018, F019, F023, F034

### 机理
M001, M002, M003, M004, M011, M020, M040

### 设计参数
P018, P021, P029, P033, P035, P038, P039, P040, P041, P059, P067, P068, P096, P097, P098, P099, P113, P114, P122
