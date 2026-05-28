# 膨胀鼓气知识图谱 - Neo4j导入数据

## 图谱结构

```
DesignParam ──[INFLUENCED_BY]──> Mechanism ──[HAS_MECHANISM]──> FailureMode
    │                                                              ▲
    └─────────────────[DIRECTLY_AFFECTS]───────────────────────────┘
```

## 节点统计

| 标签 | 数量 | 说明 |
|------|------|------|
| FailureMode | 17 | 膨胀鼓气类失效模式 |
| Mechanism | 11 | 相关失效机理（含主机理与辅机理） |
| DesignParam | 27 | 影响因素的设计参数 |
| **合计** | **55** | |

## 关系统计

| 关系类型 | 数量 | 方向 | 含义 |
|----------|------|------|------|
| HAS_MECHANISM | 83 | 失效→机理 | 失效模式的主/辅机理（role属性区分） |
| INFLUENCED_BY | 63 | 机理→参数 | 机理受设计参数影响（含影响描述） |
| DIRECTLY_AFFECTS | 38 | 参数→失效 | 参数直接影响失效模式（跳过机理层） |
| **合计** | **184** | | |

## 因果链总览

### 膨胀类（主机理: M011 负极体积膨胀应力）
| 失效模式 | 主机理 | 辅机理 |
|---------|--------|--------|
| F043 常温循环膨胀失效 | M011 | M012, M028, M037, M020 |
| F044 45℃循环膨胀失效 | M011 | M012, M022, M006, M037, M020 |
| F045 循环变形 | M011 | M020, M037, M012 |
| F047 浅充浅放厚度膨胀恶化 | M011 | M012, M028, M037 |
| F048 循环锅盖变形 | M011 | M020, M037, M012 |
| F066 满电变形 | M011 | M037, M020 |
| F086 18℃循环膨胀失效 | M011 | M012, M028, M037 |
| F099 12℃循环膨胀OOF | M011 | M012, M028, M016, M037 |

### 鼓气类（主机理: M012/M022 界面产气/热分解）
| 失效模式 | 主机理 | 辅机理 |
|---------|--------|--------|
| F036 高温储存鼓气 | M012 | M022, M006, M023, M027, M037 |
| F082 高温Interval循环鼓气 | M012 | M022, M006, M027, M023, M037 |
| F113 极限高温储存鼓气 | M022 | M021, M006, M012, M027, M037 |
| F115 55℃循环400T鼓气 | M012 | M022, M006, M027, M023, M037 |
| F144 45℃高温interval鼓气 | M012 | M022, M006, M027, M023, M037 |
| F145 55℃高温interval鼓气 | M022 | M012, M021, M006, M027, M037 |

### 压力/涨液类
| 失效模式 | 主机理 | 辅机理 |
|---------|--------|--------|
| F046 电芯顶底部出现鼓包 | M037 | M011, M012, M020 |
| F103 电芯涨液 | M012 | M011, M037, M028 |
| F152 析锂导致鼓气 | M016 | M012, M037, M028 |

## 关键设计参数影响覆盖

| 核心参数 | 直接影响的失效数 | 说明 |
|---------|----------------|------|
| P029 负极Si总含量 | 8 | 硅膨胀是循环膨胀的根本驱动 |
| P078 铝塑膜厚度 | 7 | 决定鼓气时外壳承受极限 |
| P116 充电上限电压 | 6 | 高电压加速各类产气反应 |
| P066 电解液物料编码 | 4 | 电解液配方决定产气倾向 |
| P092 电芯层数 | 3 | 层数决定膨胀累积量 |
| P035 负极Si总占比 | 3 | 综合硅含量决定膨胀程度 |

## 文件说明

### CSV文件
- `nodes_failure_mode.csv` — 失效模式节点（17条）
- `nodes_mechanism.csv` — 机理节点（11条）
- `nodes_design_param.csv` — 设计参数节点（27条）
- `rels_failure_mechanism.csv` — 失效→机理关系（83条）
- `rels_mechanism_param.csv` — 机理→参数关系（63条）
- `rels_param_failure_direct.csv` — 参数→失效直接关系（38条）

### Cypher脚本
- `import_swelling_gassing.cypher` — 完整Cypher导入脚本

## 导入方式

### 方式一：Cypher脚本直接执行
```bash
cat import_swelling_gassing.cypher | cypher-shell -u neo4j -p <password>
```

### 方式二：LOAD CSV导入
```cypher
LOAD CSV WITH HEADERS FROM 'file:///nodes_failure_mode.csv' AS row
CREATE (:FailureMode {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, detectTime: row.detectTime});

LOAD CSV WITH HEADERS FROM 'file:///nodes_mechanism.csv' AS row
CREATE (:Mechanism {mechId: row.`mechId:ID`, name: row.name, description: row.description});

LOAD CSV WITH HEADERS FROM 'file:///nodes_design_param.csv' AS row
CREATE (:DesignParam {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, affectAttributes: row.affectAttributes});

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
F036, F043, F044, F045, F046, F047, F048, F066, F082, F086, F099, F103, F113, F115, F144, F145, F152

### 机理（表二）
M006, M011, M012, M016, M020, M021, M022, M023, M027, M028, M037

### 设计参数（表三）
P014, P021, P029, P033, P035, P038, P039, P040, P041, P047, P053, P056, P057, P066, P067, P068, P078, P079, P092, P105, P106, P107, P108, P113, P114, P116, P117
