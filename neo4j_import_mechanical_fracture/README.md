# 机械断裂知识图谱 - Neo4j导入数据

## 图谱结构

```
DesignParam ──[INFLUENCED_BY]──> Mechanism ──[HAS_MECHANISM]──> FailureMode
    │                                                              ▲
    └─────────────────[DIRECTLY_AFFECTS]───────────────────────────┘
```

## 节点统计

| 标签 | 数量 | 说明 |
|------|------|------|
| FailureMode | 13 | 机械断裂类失效模式 |
| Mechanism | 9 | 相关失效机理（含主机理与辅机理） |
| DesignParam | 23 | 影响因素的设计参数 |
| **合计** | **45** | |

## 关系统计

| 关系类型 | 数量 | 方向 | 含义 |
|----------|------|------|------|
| HAS_MECHANISM | 49 | 失效→机理 | 失效模式的主/辅机理（role属性区分） |
| INFLUENCED_BY | 58 | 机理→参数 | 机理受设计参数影响（含影响描述） |
| DIRECTLY_AFFECTS | 27 | 参数→失效 | 参数直接影响失效模式（跳过机理层） |
| **合计** | **134** | | |

## 因果链总览

| 失效模式 | 主机理 | 辅机理 |
|---------|--------|--------|
| F042 极耳断裂 | M009 机械疲劳断裂 | M032, M011, M020 |
| F060 正极辊压断带 | M020 极片内应力集中 | M009, M026, M018 |
| F061 负极辊压断带 | M020 极片内应力集中 | M009, M011, M026 |
| F073 铜箔碎裂 | M009 机械疲劳断裂 | M011, M010, M020 |
| F083 循环后铝箔断裂 | M018 铝箔电化学腐蚀 | M009, M020, M011 |
| F089 循环后铜箔断裂 | M009 机械疲劳断裂 | M011, M010, M020 |
| F105 铝箔翻折 | M020 极片内应力集中 | M009, M018 |
| F108 正极耳断裂 | M009 机械疲劳断裂 | M032, M020, M018 |
| F109 正极软极耳断裂 | M009 机械疲劳断裂 | M032, M020 |
| F110 负极耳断裂 | M009 机械疲劳断裂 | M032, M011, M020 |
| F111 负极软极耳断裂 | M009 机械疲劳断裂 | M032, M011 |
| F126 焊接拉力不良 | M032 极耳焊接疲劳 | M009, M019 |
| F129 铜箔抗拉强度降低 | M010 铜箔溶解再沉积 | M009, M011, M025, M020 |

## 文件说明

### CSV文件（用于neo4j-admin import或LOAD CSV）
- `nodes_failure_mode.csv` — 失效模式节点（13条）
- `nodes_mechanism.csv` — 机理节点（9条）
- `nodes_design_param.csv` — 设计参数节点（23条）
- `rels_failure_mechanism.csv` — 失效→机理关系（49条）
- `rels_mechanism_param.csv` — 机理→参数关系（58条）
- `rels_param_failure_direct.csv` — 参数→失效直接关系（27条）

### Cypher脚本
- `import_mechanical_fracture.cypher` — 完整Cypher导入脚本（一键执行）

## 导入方式

### 方式一：Cypher脚本直接执行
```bash
cat import_mechanical_fracture.cypher | cypher-shell -u neo4j -p <password>
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

// 加载关系
LOAD CSV WITH HEADERS FROM 'file:///rels_failure_mechanism.csv' AS row
MATCH (f:FailureMode {entityId: row.`:START_ID`})
MATCH (m:Mechanism {mechId: row.`:END_ID`})
CREATE (f)-[:HAS_MECHANISM {role: row.role}]->(m);

LOAD CSV WITH HEADERS FROM 'file:///rels_mechanism_param.csv' AS row
MATCH (m:Mechanism {mechId: row.`:START_ID`})
MATCH (p:DesignParam {entityId: row.`:END_ID`})
CREATE (m)-[:INFLUENCED_BY {influence: row.influence}]->(p);

LOAD CSV WITH HEADERS FROM 'file:///rels_param_failure_direct.csv' AS row
MATCH (p:DesignParam {entityId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (p)-[:DIRECTLY_AFFECTS {influence: row.influence}]->(f);
```

## 涉及的原始数据ID

### 失效模式（表一）
F042, F060, F061, F073, F083, F089, F105, F108, F109, F110, F111, F126, F129

### 机理（表二）
M009, M010, M011, M018, M019, M020, M025, M026, M032

### 设计参数（表三）
P022, P024, P025, P029, P033, P035, P038, P040, P041, P043, P049, P050, P051, P056, P058, P071, P072, P073, P074, P077, P102, P114, P116
