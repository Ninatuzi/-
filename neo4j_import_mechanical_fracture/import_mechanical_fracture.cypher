// ============================================================
// 机械断裂知识图谱 - Neo4j LOAD CSV 导入脚本
//
// 关系体系:
//   F_FRAC --[HAS_SUBTYPE]--> 子失效
//   机理   --[CAUSES]--> 失效 (主因)
//   机理   --[CONTRIBUTES]--> 失效 (辅因)
//   参数   --[INFLUENCES]--> 机理
//   参数   --[DIRECTLY_AFFECTS]--> 失效
//   机理   --[CAUSES|CONTRIBUTES|EVOLVES_TO]--> 机理 (机理间关系)
//
// 节点: 46个 (14 FailureMode + 9 Mechanism + 23 DesignParam)
// 关系: 147条
// ============================================================

// -------- 1. 约束 --------
CREATE CONSTRAINT IF NOT EXISTS FOR (f:FailureMode) REQUIRE f.entityId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Mechanism) REQUIRE m.mechId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:DesignParam) REQUIRE p.entityId IS UNIQUE;

// -------- 2. 加载节点 --------
LOAD CSV WITH HEADERS FROM 'file:///nodes_failure_mode.csv' AS row
CREATE (:FailureMode {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, detectTime: row.detectTime});

LOAD CSV WITH HEADERS FROM 'file:///nodes_mechanism.csv' AS row
CREATE (:Mechanism {mechId: row.`mechId:ID`, name: row.name, description: row.description});

LOAD CSV WITH HEADERS FROM 'file:///nodes_design_param.csv' AS row
CREATE (:DesignParam {entityId: row.`entityId:ID`, name: row.name, entityType: row.entityType, affectAttributes: row.affectAttributes});

// -------- 3. 加载关系: HAS_SUBTYPE --------
LOAD CSV WITH HEADERS FROM 'file:///rels_subtype.csv' AS row
MATCH (a:FailureMode {entityId: row.`:START_ID`})
MATCH (b:FailureMode {entityId: row.`:END_ID`})
CREATE (a)-[:HAS_SUBTYPE]->(b);

// -------- 4. 加载关系: CAUSES (机理→失效) --------
LOAD CSV WITH HEADERS FROM 'file:///rels_causes.csv' AS row
MATCH (m:Mechanism {mechId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (m)-[:CAUSES {description: row.description}]->(f);

// -------- 5. 加载关系: CONTRIBUTES (机理→失效) --------
LOAD CSV WITH HEADERS FROM 'file:///rels_contributes.csv' AS row
MATCH (m:Mechanism {mechId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (m)-[:CONTRIBUTES {description: row.description}]->(f);

// -------- 6. 加载关系: 机理间 CAUSES/CONTRIBUTES/EVOLVES_TO --------
LOAD CSV WITH HEADERS FROM 'file:///rels_evolves_to.csv' AS row
MATCH (a:Mechanism {mechId: row.`:START_ID`})
MATCH (b:Mechanism {mechId: row.`:END_ID`})
CALL apoc.create.relationship(a, row.`:TYPE`, {description: row.description}, b) YIELD rel
RETURN count(rel);

// -------- 7. 加载关系: INFLUENCES (参数→机理) --------
LOAD CSV WITH HEADERS FROM 'file:///rels_influences.csv' AS row
MATCH (p:DesignParam {entityId: row.`:START_ID`})
MATCH (m:Mechanism {mechId: row.`:END_ID`})
CREATE (p)-[:INFLUENCES {description: row.description}]->(m);

// -------- 8. 加载关系: DIRECTLY_AFFECTS (参数→失效) --------
LOAD CSV WITH HEADERS FROM 'file:///rels_directly_affects.csv' AS row
MATCH (p:DesignParam {entityId: row.`:START_ID`})
MATCH (f:FailureMode {entityId: row.`:END_ID`})
CREATE (p)-[:DIRECTLY_AFFECTS {description: row.description}]->(f);
