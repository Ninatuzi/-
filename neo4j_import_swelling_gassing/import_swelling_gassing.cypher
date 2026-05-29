// ============================================================
// 膨胀鼓气知识图谱 - Neo4j LOAD CSV 导入脚本
//
// 使用前提:
//   把本目录下所有CSV放到 Neo4j 的 import/swelling_gassing/ 文件夹
//
// 关系体系:
//   F_SWELL --[HAS_SUBTYPE]--> 子失效
//   机理    --[CAUSES]--> 失效 (主因)
//   机理    --[CONTRIBUTES]--> 失效 (辅因)
//   参数    --[INFLUENCES]--> 机理
//   参数    --[DIRECTLY_AFFECTS]--> 失效
//   机理    --[CAUSES|CONTRIBUTES|EVOLVES_TO]--> 机理 (机理间关系)
//
// 节点: 56个 (18 FailureMode + 11 Mechanism + 27 DesignParam)
// 关系: 200条
//
// 用法: 在 Neo4j Browser 中, 把每一段(以分号结尾)分别粘贴执行
// ============================================================

// -------- 1. 约束 --------
CREATE CONSTRAINT IF NOT EXISTS FOR (f:FailureMode) REQUIRE f.entityId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Mechanism) REQUIRE m.mechId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:DesignParam) REQUIRE p.entityId IS UNIQUE;

// -------- 2. 加载节点 --------
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/nodes_failure_mode.csv' AS row
CREATE (:FailureMode {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, detectTime: row.detectTime});

LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/nodes_mechanism.csv' AS row
CREATE (:Mechanism {mechId: row.`mechId:ID`, name: row.name, description: row.description});

LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/nodes_design_param.csv' AS row
CREATE (:DesignParam {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, affectAttributes: row.affectAttributes});

// -------- 3. HAS_SUBTYPE (根→子失效) --------
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_subtype.csv' AS row
MATCH (a:FailureMode {entityId: row.`:START_ID`})
MATCH (b:FailureMode {entityId: row.`:END_ID`})
CREATE (a)-[:HAS_SUBTYPE]->(b);

// -------- 4. CAUSES (机理→失效, 主因) --------
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_causes.csv' AS row
MATCH (m:Mechanism {mechId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (m)-[:CAUSES {description: row.description}]->(f);

// -------- 5. CONTRIBUTES (机理→失效, 辅因) --------
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_contributes.csv' AS row
MATCH (m:Mechanism {mechId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (m)-[:CONTRIBUTES {description: row.description}]->(f);

// -------- 6. INFLUENCES (参数→机理) --------
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_influences.csv' AS row
MATCH (p:DesignParam {entityId: row.`:START_ID`})
MATCH (m:Mechanism {mechId: row.`:END_ID`})
CREATE (p)-[:INFLUENCES {description: row.description}]->(m);

// -------- 7. DIRECTLY_AFFECTS (参数→失效) --------
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_directly_affects.csv' AS row
MATCH (p:DesignParam {entityId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (p)-[:DIRECTLY_AFFECTS {description: row.description}]->(f);

// -------- 8. 机理间关系 (按类型分别执行, 无需APOC插件) --------
// 8a. 机理→机理 EVOLVES_TO
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_evolves_to.csv' AS row
WITH row WHERE row.`:TYPE` = 'EVOLVES_TO'
MATCH (a:Mechanism {mechId: row.`:START_ID`})
MATCH (b:Mechanism {mechId: row.`:END_ID`})
CREATE (a)-[:EVOLVES_TO {description: row.description}]->(b);

// 8b. 机理→机理 CAUSES
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_evolves_to.csv' AS row
WITH row WHERE row.`:TYPE` = 'CAUSES'
MATCH (a:Mechanism {mechId: row.`:START_ID`})
MATCH (b:Mechanism {mechId: row.`:END_ID`})
CREATE (a)-[:CAUSES {description: row.description}]->(b);

// 8c. 机理→机理 CONTRIBUTES
LOAD CSV WITH HEADERS FROM 'file:///swelling_gassing/rels_evolves_to.csv' AS row
WITH row WHERE row.`:TYPE` = 'CONTRIBUTES'
MATCH (a:Mechanism {mechId: row.`:START_ID`})
MATCH (b:Mechanism {mechId: row.`:END_ID`})
CREATE (a)-[:CONTRIBUTES {description: row.description}]->(b);

// ============================================================
// 验证 (可选)
// ============================================================
// 看全图:      MATCH (n)-[r]->(m) RETURN n, r, m
// 从根展开:    MATCH path=(:FailureMode {entityId:'F_SWELL'})-[*1..3]-() RETURN path
// 节点统计:    MATCH (n) RETURN labels(n)[0] AS 类型, count(n) AS 数量
// 关系统计:    MATCH ()-[r]->() RETURN type(r) AS 关系, count(r) AS 数量 ORDER BY 数量 DESC
