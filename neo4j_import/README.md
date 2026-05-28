# 边缘析锂知识图谱 - Neo4j导入数据

## 图谱结构

```
DesignParam ──[INFLUENCED_BY]──> Mechanism ──[HAS_MECHANISM]──> FailureMode
    │                                                              ▲
    └─────────────────[DIRECTLY_AFFECTS]───────────────────────────┘
```

## 节点统计

| 标签 | 数量 | 说明 |
|------|------|------|
| FailureMode | 7 | 边缘析锂的二级分类失效模式 |
| Mechanism | 11 | 相关失效机理（含主机理与辅机理） |
| DesignParam | 24 | 影响因素的设计参数 |
| **合计** | **42** | |

## 关系统计

| 关系类型 | 数量 | 方向 | 含义 |
|----------|------|------|------|
| HAS_MECHANISM | 32 | 失效→机理 | 失效模式的主/辅机理（role属性区分） |
| INFLUENCED_BY | 45 | 机理→参数 | 机理受设计参数影响（含影响描述） |
| DIRECTLY_AFFECTS | 18 | 参数→失效 | 参数直接影响失效模式（跳过机理层） |
| **合计** | **95** | | |

## 因果链总览

| 失效模式 | 主机理 | 辅机理 |
|---------|--------|--------|
| F013 极片边缘析锂 | M002 局部电流密度集中 | M001, M003, M024 |
| F014 负极尾部两折边缘析锂 | M020 极片内应力集中 | M002, M011, M005, M039 |
| F015 极耳胶纸边缘析锂 | M002 局部电流密度集中 | M004, M003, M005, M015 |
| F018 OH边缘析锂 | M002 局部电流密度集中 | M004, M001, M015 |
| F019 极耳位极片边缘月牙形析锂 | M002 局部电流密度集中 | M040, M003, M005, M024, M039 |
| F023 负极单双面交界处析锂 | M020 极片内应力集中 | M002, M011, M039 |
| F034 叠片顶部极耳位边缘析锂 | M002 局部电流密度集中 | M040, M004, M024 |

## 文件说明

### CSV文件（用于neo4j-admin import或LOAD CSV）
- `nodes_failure_mode.csv` — 失效模式节点（7条）
- `nodes_mechanism.csv` — 机理节点（11条）
- `nodes_design_param.csv` — 设计参数节点（24条）
- `rels_failure_mechanism.csv` — 失效→机理关系（32条）
- `rels_mechanism_param.csv` — 机理→参数关系（45条）
- `rels_param_failure_direct.csv` — 参数→失效直接关系（18条）

### Cypher脚本
- `import_edge_lithium_plating.cypher` — 完整Cypher导入脚本（一键执行）

## 导入方式

### 方式一：Cypher脚本直接执行
```bash
cat import_edge_lithium_plating.cypher | cypher-shell -u neo4j -p <password>
```

### 方式二：LOAD CSV导入
```cypher
// 加载失效模式节点
LOAD CSV WITH HEADERS FROM 'file:///nodes_failure_mode.csv' AS row
CREATE (:FailureMode {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, detectTime: row.detectTime});

// 加载机理节点
LOAD CSV WITH HEADERS FROM 'file:///nodes_mechanism.csv' AS row
CREATE (:Mechanism {mechId: row.`mechId:ID`, name: row.name, description: row.description});

// 加载设计参数节点
LOAD CSV WITH HEADERS FROM 'file:///nodes_design_param.csv' AS row
CREATE (:DesignParam {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, affectAttributes: row.affectAttributes});

// 加载失效→机理关系
LOAD CSV WITH HEADERS FROM 'file:///rels_failure_mechanism.csv' AS row
MATCH (f:FailureMode {entityId: row.`:START_ID`})
MATCH (m:Mechanism {mechId: row.`:END_ID`})
CREATE (f)-[:HAS_MECHANISM {role: row.role}]->(m);

// 加载机理→参数关系
LOAD CSV WITH HEADERS FROM 'file:///rels_mechanism_param.csv' AS row
MATCH (m:Mechanism {mechId: row.`:START_ID`})
MATCH (p:DesignParam {entityId: row.`:END_ID`})
CREATE (m)-[:INFLUENCED_BY {influence: row.influence}]->(p);

// 加载参数→失效直接关系
LOAD CSV WITH HEADERS FROM 'file:///rels_param_failure_direct.csv' AS row
MATCH (p:DesignParam {entityId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (p)-[:DIRECTLY_AFFECTS {influence: row.influence}]->(f);
```

## 涉及的原始数据ID

### 失效模式（表一）
F013, F014, F015, F018, F019, F023, F034

### 机理（表二）
M001, M002, M003, M004, M005, M011, M015, M020, M024, M039, M040

### 设计参数（表三）
P018, P021, P029, P033, P035, P037, P038, P039, P040, P041, P044, P059, P061, P064, P067, P068, P096, P097, P098, P099, P107, P113, P114, P122
