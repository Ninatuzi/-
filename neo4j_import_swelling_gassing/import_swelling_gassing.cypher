// ============================================================
// 膨胀鼓气知识图谱 - Neo4j Cypher导入脚本（完整版）
// 因果链: 设计参数 → 机理 → 失效模式 (含直接影响路径)
// 节点: 55个 (17 FailureMode + 11 Mechanism + 27 DesignParam)
// 关系: 206条 (83 HAS_MECHANISM + 63 INFLUENCED_BY + 38 DIRECTLY_AFFECTS + 22 reserved)
// ============================================================

// -------- 1. 创建约束和索引 --------
CREATE CONSTRAINT IF NOT EXISTS FOR (f:FailureMode) REQUIRE f.entityId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Mechanism) REQUIRE m.mechId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:DesignParam) REQUIRE p.entityId IS UNIQUE;

// -------- 2. 创建失效模式节点 (17) --------
CREATE (:FailureMode {entityId:'F036', name:'高温储存鼓气', entityType:'失效模式', detectTime:'检测时机:"高温存储后"'});
CREATE (:FailureMode {entityId:'F043', name:'常温循环膨胀失效', entityType:'失效模式', detectTime:'检测时机:"循环后"'});
CREATE (:FailureMode {entityId:'F044', name:'45℃循环膨胀失效', entityType:'失效模式', detectTime:'检测时机:"高温循环后"'});
CREATE (:FailureMode {entityId:'F045', name:'循环变形', entityType:'失效模式', detectTime:'检测时机:"循环后"'});
CREATE (:FailureMode {entityId:'F046', name:'电芯顶底部出现鼓包', entityType:'失效模式', detectTime:'检测时机:"满电状态"'});
CREATE (:FailureMode {entityId:'F047', name:'浅充浅放厚度膨胀恶化', entityType:'失效模式', detectTime:'检测时机:"循环后"'});
CREATE (:FailureMode {entityId:'F048', name:'循环锅盖变形', entityType:'失效模式', detectTime:'检测时机:"循环后"'});
CREATE (:FailureMode {entityId:'F066', name:'满电变形', entityType:'失效模式', detectTime:'检测时机:"满电状态"'});
CREATE (:FailureMode {entityId:'F082', name:'高温Interval循环鼓气', entityType:'失效模式', detectTime:'检测时机:"高温间隔循环"'});
CREATE (:FailureMode {entityId:'F086', name:'18℃循环膨胀失效', entityType:'失效模式', detectTime:'检测时机:"中温循环"'});
CREATE (:FailureMode {entityId:'F099', name:'12℃循环膨胀OOF', entityType:'失效模式', detectTime:'检测时机:"低温循环"'});
CREATE (:FailureMode {entityId:'F103', name:'电芯涨液', entityType:'失效模式', detectTime:'检测时机:"满电状态"'});
CREATE (:FailureMode {entityId:'F113', name:'极限高温储存鼓气', entityType:'失效模式', detectTime:'检测时机:"极限高温存储"'});
CREATE (:FailureMode {entityId:'F115', name:'55℃循环400T鼓气', entityType:'失效模式', detectTime:'检测时机:"高温循环"'});
CREATE (:FailureMode {entityId:'F144', name:'45℃高温interval鼓气', entityType:'失效模式', detectTime:'检测时机:"高温间隔循环"'});
CREATE (:FailureMode {entityId:'F145', name:'55℃高温interval鼓气', entityType:'失效模式', detectTime:'检测时机:"高温间隔循环"'});
CREATE (:FailureMode {entityId:'F152', name:'析锂导致鼓气', entityType:'失效模式', detectTime:'检测时机:"析锂后存储"'});


// -------- 3. 创建机理节点 (11) --------
CREATE (:Mechanism {mechId:'M006', name:'正极与电解液氧化还原反应', description:'高电压下正极材料催化电解液溶剂氧化分解，产气产热'});
CREATE (:Mechanism {mechId:'M011', name:'负极体积膨胀应力', description:'嵌锂过程中负极材料（特别是含硅材料）体积膨胀产生内应力'});
CREATE (:Mechanism {mechId:'M012', name:'界面副反应产气', description:'多种界面化学反应（如电解液分解、水分反应等）产生CO₂、C₂H₄等气体'});
CREATE (:Mechanism {mechId:'M016', name:'析锂产物与电解液反应', description:'沉积的金属锂与电解液剧烈反应，产热产气，可能引发热失控'});
CREATE (:Mechanism {mechId:'M020', name:'极片内应力集中', description:'制造或循环过程中极片内部应力分布不均，导致变形、褶皱或开裂'});
CREATE (:Mechanism {mechId:'M021', name:'正极释氧反应', description:'高电压或高温下正极材料晶格释放氧气，加剧电解液氧化'});
CREATE (:Mechanism {mechId:'M022', name:'电解液热分解', description:'高温下电解液组分发生热分解反应，产气产热'});
CREATE (:Mechanism {mechId:'M023', name:'SEI重构过程', description:'高温或高电压下原有SEI破坏，重新形成更厚或不稳定的SEI膜'});
CREATE (:Mechanism {mechId:'M027', name:'电解液氧化分解', description:'电解液在高电压下发生氧化反应，生成气体和固体产物'});
CREATE (:Mechanism {mechId:'M028', name:'电解液还原分解', description:'电解液在低电位下（如负极表面）发生还原反应，消耗活性锂并生成SEI'});
CREATE (:Mechanism {mechId:'M037', name:'产气压力积累', description:'内部产气导致压力升高，当超过外壳承受极限时发生鼓包或变形'});

// -------- 4. 创建设计参数节点 (27) --------
CREATE (:DesignParam {entityId:'P014', name:'充电限制电压', entityType:'设计参数', affectAttributes:'影响方向:"能量密度/安全性"'});
CREATE (:DesignParam {entityId:'P021', name:'负极双面厚度_辊压后', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散距离"'});
CREATE (:DesignParam {entityId:'P029', name:'负极Si总含量_单层上层', entityType:'设计参数', affectAttributes:'影响方向:"容量/膨胀"'});
CREATE (:DesignParam {entityId:'P033', name:'负极Si总含量_下层', entityType:'设计参数', affectAttributes:'影响方向:"容量/膨胀"'});
CREATE (:DesignParam {entityId:'P035', name:'负极Si总占比_整体', entityType:'设计参数', affectAttributes:'影响方向:"综合性能"'});
CREATE (:DesignParam {entityId:'P038', name:'负极压实密度', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散/接触"'});
CREATE (:DesignParam {entityId:'P039', name:'负极面密度', entityType:'设计参数', affectAttributes:'影响方向:"容量均匀性"'});
CREATE (:DesignParam {entityId:'P040', name:'负极延展', entityType:'设计参数', affectAttributes:'影响方向:"尺寸变化"'});
CREATE (:DesignParam {entityId:'P041', name:'负极单双面压实比', entityType:'设计参数', affectAttributes:'影响方向:"结构均匀性"'});
CREATE (:DesignParam {entityId:'P047', name:'正极双面厚度_辊压后', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散距离"'});
CREATE (:DesignParam {entityId:'P053', name:'正极配方', entityType:'设计参数', affectAttributes:'影响方向:"材料体系"'});
CREATE (:DesignParam {entityId:'P056', name:'正极压实密度', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散/接触"'});
CREATE (:DesignParam {entityId:'P057', name:'正极面密度', entityType:'设计参数', affectAttributes:'影响方向:"容量均匀性"'});
CREATE (:DesignParam {entityId:'P066', name:'电解液物料编码', entityType:'设计参数', affectAttributes:'影响方向:"配方体系"'});
CREATE (:DesignParam {entityId:'P067', name:'注液量_均值', entityType:'设计参数', affectAttributes:'影响方向:"界面润湿"'});
CREATE (:DesignParam {entityId:'P068', name:'保液量_下限', entityType:'设计参数', affectAttributes:'影响方向:"循环寿命"'});
CREATE (:DesignParam {entityId:'P078', name:'铝塑膜厚度', entityType:'设计参数', affectAttributes:'影响方向:"机械保护"'});
CREATE (:DesignParam {entityId:'P079', name:'冲坑总深度', entityType:'设计参数', affectAttributes:'影响方向:"内部空间"'});
CREATE (:DesignParam {entityId:'P092', name:'电芯层数_负极', entityType:'设计参数', affectAttributes:'影响方向:"容量设计"'});
CREATE (:DesignParam {entityId:'P105', name:'水分含量控制', entityType:'设计参数', affectAttributes:'影响方向:"可靠性"'});
CREATE (:DesignParam {entityId:'P106', name:'陈化条件', entityType:'设计参数', affectAttributes:'影响方向:"SEI形成"'});
CREATE (:DesignParam {entityId:'P107', name:'化成压力', entityType:'设计参数', affectAttributes:'影响方向:"界面接触"'});
CREATE (:DesignParam {entityId:'P108', name:'化成温度', entityType:'设计参数', affectAttributes:'影响方向:"SEI质量"'});
CREATE (:DesignParam {entityId:'P113', name:'负极过量_NP比', entityType:'设计参数', affectAttributes:'影响方向:"析锂风险"'});
CREATE (:DesignParam {entityId:'P114', name:'充电电流', entityType:'设计参数', affectAttributes:'影响方向:"快充能力"'});
CREATE (:DesignParam {entityId:'P116', name:'充电上限电压', entityType:'设计参数', affectAttributes:'影响方向:"能量密度/安全性"'});
CREATE (:DesignParam {entityId:'P117', name:'水分含量', entityType:'设计参数', affectAttributes:'影响方向:"可靠性"'});


// -------- 5. 创建关系: 失效模式 -[HAS_MECHANISM]-> 机理 (83条) --------
// F036 高温储存鼓气
MATCH (f:FailureMode {entityId:'F036'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F036'}), (m:Mechanism {mechId:'M022'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F036'}), (m:Mechanism {mechId:'M006'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F036'}), (m:Mechanism {mechId:'M023'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F036'}), (m:Mechanism {mechId:'M027'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F036'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F043 常温循环膨胀失效
MATCH (f:FailureMode {entityId:'F043'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F043'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F043'}), (m:Mechanism {mechId:'M028'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F043'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F043'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F044 45℃循环膨胀失效
MATCH (f:FailureMode {entityId:'F044'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F044'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F044'}), (m:Mechanism {mechId:'M022'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F044'}), (m:Mechanism {mechId:'M006'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F044'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F044'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F045 循环变形
MATCH (f:FailureMode {entityId:'F045'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F045'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F045'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F045'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F046 电芯顶底部出现鼓包
MATCH (f:FailureMode {entityId:'F046'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F046'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F046'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F046'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F047 浅充浅放厚度膨胀恶化
MATCH (f:FailureMode {entityId:'F047'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F047'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F047'}), (m:Mechanism {mechId:'M028'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F047'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F048 循环锅盖变形
MATCH (f:FailureMode {entityId:'F048'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F048'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F048'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F048'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F066 满电变形
MATCH (f:FailureMode {entityId:'F066'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F066'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F066'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F082 高温Interval循环鼓气
MATCH (f:FailureMode {entityId:'F082'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F082'}), (m:Mechanism {mechId:'M022'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F082'}), (m:Mechanism {mechId:'M006'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F082'}), (m:Mechanism {mechId:'M027'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F082'}), (m:Mechanism {mechId:'M023'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F082'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);


// F086 18℃循环膨胀失效
MATCH (f:FailureMode {entityId:'F086'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F086'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F086'}), (m:Mechanism {mechId:'M028'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F086'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F099 12℃循环膨胀OOF
MATCH (f:FailureMode {entityId:'F099'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F099'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F099'}), (m:Mechanism {mechId:'M028'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F099'}), (m:Mechanism {mechId:'M016'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F099'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F103 电芯涨液
MATCH (f:FailureMode {entityId:'F103'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F103'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F103'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F103'}), (m:Mechanism {mechId:'M028'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F113 极限高温储存鼓气
MATCH (f:FailureMode {entityId:'F113'}), (m:Mechanism {mechId:'M022'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F113'}), (m:Mechanism {mechId:'M021'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F113'}), (m:Mechanism {mechId:'M006'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F113'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F113'}), (m:Mechanism {mechId:'M027'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F113'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F115 55℃循环400T鼓气
MATCH (f:FailureMode {entityId:'F115'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F115'}), (m:Mechanism {mechId:'M022'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F115'}), (m:Mechanism {mechId:'M006'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F115'}), (m:Mechanism {mechId:'M027'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F115'}), (m:Mechanism {mechId:'M023'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F115'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F144 45℃高温interval鼓气
MATCH (f:FailureMode {entityId:'F144'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F144'}), (m:Mechanism {mechId:'M022'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F144'}), (m:Mechanism {mechId:'M006'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F144'}), (m:Mechanism {mechId:'M027'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F144'}), (m:Mechanism {mechId:'M023'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F144'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F145 55℃高温interval鼓气
MATCH (f:FailureMode {entityId:'F145'}), (m:Mechanism {mechId:'M022'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F145'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F145'}), (m:Mechanism {mechId:'M021'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F145'}), (m:Mechanism {mechId:'M006'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F145'}), (m:Mechanism {mechId:'M027'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F145'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F152 析锂导致鼓气
MATCH (f:FailureMode {entityId:'F152'}), (m:Mechanism {mechId:'M016'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F152'}), (m:Mechanism {mechId:'M012'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F152'}), (m:Mechanism {mechId:'M037'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F152'}), (m:Mechanism {mechId:'M028'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);


// -------- 6. 创建关系: 机理 -[INFLUENCED_BY]-> 设计参数 (63条) --------
// M006 正极与电解液氧化还原反应
MATCH (m:Mechanism {mechId:'M006'}), (p:DesignParam {entityId:'P116'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电上限电压越高正极氧化电解液越剧烈'}]->(p);
MATCH (m:Mechanism {mechId:'M006'}), (p:DesignParam {entityId:'P014'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电限制电压高加速正极催化电解液氧化'}]->(p);
MATCH (m:Mechanism {mechId:'M006'}), (p:DesignParam {entityId:'P053'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极配方决定催化电解液氧化的活性'}]->(p);
MATCH (m:Mechanism {mechId:'M006'}), (p:DesignParam {entityId:'P066'}) CREATE (m)-[:INFLUENCED_BY {influence:'电解液配方决定抗氧化分解能力'}]->(p);
MATCH (m:Mechanism {mechId:'M006'}), (p:DesignParam {entityId:'P067'}) CREATE (m)-[:INFLUENCED_BY {influence:'注液量大时可参与氧化的电解液总量更多'}]->(p);

// M011 负极体积膨胀应力
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P029'}) CREATE (m)-[:INFLUENCED_BY {influence:'硅含量增加导致体积膨胀加剧'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P033'}) CREATE (m)-[:INFLUENCED_BY {influence:'下层硅含量影响整体膨胀应力'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P035'}) CREATE (m)-[:INFLUENCED_BY {influence:'整体硅占比决定综合膨胀程度'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P040'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极延展性影响膨胀后应力释放'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高使颗粒间膨胀应力增大'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P039'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极面密度越高膨胀绝对量越大'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P021'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极厚度越大膨胀绝对变形量越大'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P092'}) CREATE (m)-[:INFLUENCED_BY {influence:'电芯层数越多膨胀累积越大'}]->(p);

// M012 界面副反应产气
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P066'}) CREATE (m)-[:INFLUENCED_BY {influence:'电解液配方决定副反应产气倾向'}]->(p);
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P117'}) CREATE (m)-[:INFLUENCED_BY {influence:'水分含量高加剧界面副反应产气'}]->(p);
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P105'}) CREATE (m)-[:INFLUENCED_BY {influence:'水分含量控制不良导致副反应产气增加'}]->(p);
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P116'}) CREATE (m)-[:INFLUENCED_BY {influence:'高电压加速界面副反应产气'}]->(p);
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P014'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电限制电压高加剧界面副反应'}]->(p);
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P108'}) CREATE (m)-[:INFLUENCED_BY {influence:'化成温度影响初始SEI质量从而影响后续产气'}]->(p);
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P106'}) CREATE (m)-[:INFLUENCED_BY {influence:'陈化条件影响SEI稳定性从而影响产气'}]->(p);
MATCH (m:Mechanism {mechId:'M012'}), (p:DesignParam {entityId:'P067'}) CREATE (m)-[:INFLUENCED_BY {influence:'注液量影响副反应规模'}]->(p);

// M016 析锂产物与电解液反应
MATCH (m:Mechanism {mechId:'M016'}), (p:DesignParam {entityId:'P113'}) CREATE (m)-[:INFLUENCED_BY {influence:'NP比不足时析锂风险增大后续析锂产物反应产气'}]->(p);
MATCH (m:Mechanism {mechId:'M016'}), (p:DesignParam {entityId:'P114'}) CREATE (m)-[:INFLUENCED_BY {influence:'大电流充电导致析锂后金属锂与电解液反应产气'}]->(p);
MATCH (m:Mechanism {mechId:'M016'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高促进析锂从而增加析锂产物反应'}]->(p);
MATCH (m:Mechanism {mechId:'M016'}), (p:DesignParam {entityId:'P066'}) CREATE (m)-[:INFLUENCED_BY {influence:'电解液配方影响与析锂产物反应剧烈程度'}]->(p);

// M020 极片内应力集中
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高增加极片刚性应力导致变形'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度过高导致极片内应力不均'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P041'}) CREATE (m)-[:INFLUENCED_BY {influence:'单双面压实比不均导致应力集中变形'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P040'}) CREATE (m)-[:INFLUENCED_BY {influence:'延展差异导致极片内应力分布不均'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P079'}) CREATE (m)-[:INFLUENCED_BY {influence:'冲坑深度影响电芯内部空间约束和变形模式'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P092'}) CREATE (m)-[:INFLUENCED_BY {influence:'层数多时各层应力累积导致整体变形'}]->(p);


// M021 正极释氧反应
MATCH (m:Mechanism {mechId:'M021'}), (p:DesignParam {entityId:'P053'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极配方决定高温高压下释氧倾向'}]->(p);
MATCH (m:Mechanism {mechId:'M021'}), (p:DesignParam {entityId:'P116'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电上限电压高加速正极释氧'}]->(p);
MATCH (m:Mechanism {mechId:'M021'}), (p:DesignParam {entityId:'P014'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电限制电压高促进正极晶格释氧'}]->(p);
MATCH (m:Mechanism {mechId:'M021'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度影响颗粒间应力加剧释氧'}]->(p);

// M022 电解液热分解
MATCH (m:Mechanism {mechId:'M022'}), (p:DesignParam {entityId:'P066'}) CREATE (m)-[:INFLUENCED_BY {influence:'电解液配方决定热分解温度和产气量'}]->(p);
MATCH (m:Mechanism {mechId:'M022'}), (p:DesignParam {entityId:'P117'}) CREATE (m)-[:INFLUENCED_BY {influence:'水分含量高降低电解液热稳定性'}]->(p);
MATCH (m:Mechanism {mechId:'M022'}), (p:DesignParam {entityId:'P105'}) CREATE (m)-[:INFLUENCED_BY {influence:'水分含量控制差降低电解液热稳定性'}]->(p);
MATCH (m:Mechanism {mechId:'M022'}), (p:DesignParam {entityId:'P067'}) CREATE (m)-[:INFLUENCED_BY {influence:'注液量多时高温分解产气总量更大'}]->(p);

// M023 SEI重构过程
MATCH (m:Mechanism {mechId:'M023'}), (p:DesignParam {entityId:'P108'}) CREATE (m)-[:INFLUENCED_BY {influence:'化成温度影响初始SEI质量决定后续重构程度'}]->(p);
MATCH (m:Mechanism {mechId:'M023'}), (p:DesignParam {entityId:'P106'}) CREATE (m)-[:INFLUENCED_BY {influence:'陈化条件不佳导致SEI不稳定更易重构产气'}]->(p);
MATCH (m:Mechanism {mechId:'M023'}), (p:DesignParam {entityId:'P066'}) CREATE (m)-[:INFLUENCED_BY {influence:'电解液配方影响SEI组分和重构时产气量'}]->(p);
MATCH (m:Mechanism {mechId:'M023'}), (p:DesignParam {entityId:'P116'}) CREATE (m)-[:INFLUENCED_BY {influence:'高电压加速SEI破坏和重构'}]->(p);
MATCH (m:Mechanism {mechId:'M023'}), (p:DesignParam {entityId:'P029'}) CREATE (m)-[:INFLUENCED_BY {influence:'硅含量高导致体积变化大SEI反复重构产气'}]->(p);
MATCH (m:Mechanism {mechId:'M023'}), (p:DesignParam {entityId:'P035'}) CREATE (m)-[:INFLUENCED_BY {influence:'整体硅占比高加剧SEI反复重构'}]->(p);

// M027 电解液氧化分解
MATCH (m:Mechanism {mechId:'M027'}), (p:DesignParam {entityId:'P116'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电上限电压高直接加速电解液氧化分解'}]->(p);
MATCH (m:Mechanism {mechId:'M027'}), (p:DesignParam {entityId:'P014'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电限制电压高促进电解液氧化'}]->(p);
MATCH (m:Mechanism {mechId:'M027'}), (p:DesignParam {entityId:'P066'}) CREATE (m)-[:INFLUENCED_BY {influence:'电解液配方决定氧化分解电位和产气量'}]->(p);
MATCH (m:Mechanism {mechId:'M027'}), (p:DesignParam {entityId:'P053'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极配方影响界面催化氧化分解'}]->(p);
MATCH (m:Mechanism {mechId:'M027'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度高使局部电位不均加速氧化'}]->(p);

// M028 电解液还原分解
MATCH (m:Mechanism {mechId:'M028'}), (p:DesignParam {entityId:'P066'}) CREATE (m)-[:INFLUENCED_BY {influence:'电解液配方决定还原分解电位和产气量'}]->(p);
MATCH (m:Mechanism {mechId:'M028'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极压实密度过高使局部电位异常促进还原分解'}]->(p);
MATCH (m:Mechanism {mechId:'M028'}), (p:DesignParam {entityId:'P114'}) CREATE (m)-[:INFLUENCED_BY {influence:'大电流充电使负极电位过低加速还原分解'}]->(p);
MATCH (m:Mechanism {mechId:'M028'}), (p:DesignParam {entityId:'P113'}) CREATE (m)-[:INFLUENCED_BY {influence:'NP比不足时负极电位更低加速还原分解产气'}]->(p);
MATCH (m:Mechanism {mechId:'M028'}), (p:DesignParam {entityId:'P108'}) CREATE (m)-[:INFLUENCED_BY {influence:'化成温度影响初始SEI质量决定后续还原分解程度'}]->(p);
MATCH (m:Mechanism {mechId:'M028'}), (p:DesignParam {entityId:'P106'}) CREATE (m)-[:INFLUENCED_BY {influence:'陈化条件不佳使SEI不稳定后续还原分解增多'}]->(p);

// M037 产气压力积累
MATCH (m:Mechanism {mechId:'M037'}), (p:DesignParam {entityId:'P078'}) CREATE (m)-[:INFLUENCED_BY {influence:'铝塑膜厚度决定承受内部压力的极限'}]->(p);
MATCH (m:Mechanism {mechId:'M037'}), (p:DesignParam {entityId:'P079'}) CREATE (m)-[:INFLUENCED_BY {influence:'冲坑深度影响内部空间和压力分布'}]->(p);
MATCH (m:Mechanism {mechId:'M037'}), (p:DesignParam {entityId:'P092'}) CREATE (m)-[:INFLUENCED_BY {influence:'层数多时膨胀和产气累积压力更大'}]->(p);
MATCH (m:Mechanism {mechId:'M037'}), (p:DesignParam {entityId:'P047'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极厚度影响整体膨胀量和压力积累'}]->(p);
MATCH (m:Mechanism {mechId:'M037'}), (p:DesignParam {entityId:'P021'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极厚度影响整体膨胀量和压力积累'}]->(p);
MATCH (m:Mechanism {mechId:'M037'}), (p:DesignParam {entityId:'P057'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极面密度高增加膨胀产气总量'}]->(p);
MATCH (m:Mechanism {mechId:'M037'}), (p:DesignParam {entityId:'P039'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极面密度高增加膨胀产气总量'}]->(p);


// -------- 7. 创建关系: 设计参数 -[DIRECTLY_AFFECTS]-> 失效模式 (38条) --------
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F043'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致常温循环膨胀加剧'}]->(f);
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F044'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致高温循环膨胀加剧'}]->(f);
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F045'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致循环变形'}]->(f);
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F047'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致浅充浅放膨胀恶化'}]->(f);
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F048'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致循环锅盖变形'}]->(f);
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F066'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致满电变形'}]->(f);
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F086'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致18℃循环膨胀'}]->(f);
MATCH (p:DesignParam {entityId:'P029'}), (f:FailureMode {entityId:'F099'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'硅含量高直接导致低温循环膨胀OOF'}]->(f);
MATCH (p:DesignParam {entityId:'P035'}), (f:FailureMode {entityId:'F043'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'整体硅占比高直接加剧常温循环膨胀'}]->(f);
MATCH (p:DesignParam {entityId:'P035'}), (f:FailureMode {entityId:'F044'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'整体硅占比高直接加剧高温循环膨胀'}]->(f);
MATCH (p:DesignParam {entityId:'P035'}), (f:FailureMode {entityId:'F066'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'整体硅占比高直接加剧满电变形'}]->(f);
MATCH (p:DesignParam {entityId:'P078'}), (f:FailureMode {entityId:'F036'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝塑膜厚度不足直接导致高温鼓气时外壳鼓包'}]->(f);
MATCH (p:DesignParam {entityId:'P078'}), (f:FailureMode {entityId:'F046'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝塑膜厚度不足直接导致顶底部鼓包'}]->(f);
MATCH (p:DesignParam {entityId:'P078'}), (f:FailureMode {entityId:'F082'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝塑膜厚度不足直接导致高温间隔循环鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P078'}), (f:FailureMode {entityId:'F113'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝塑膜厚度不足直接导致极限高温鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P078'}), (f:FailureMode {entityId:'F115'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝塑膜厚度不足直接导致55℃循环鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P078'}), (f:FailureMode {entityId:'F144'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝塑膜厚度不足直接导致45℃interval鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P078'}), (f:FailureMode {entityId:'F145'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝塑膜厚度不足直接导致55℃interval鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P116'}), (f:FailureMode {entityId:'F036'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'充电上限电压高直接加剧高温储存产气鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P116'}), (f:FailureMode {entityId:'F082'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'充电上限电压高直接加剧高温interval鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P116'}), (f:FailureMode {entityId:'F113'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'充电上限电压高直接加剧极限高温鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P116'}), (f:FailureMode {entityId:'F115'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'充电上限电压高直接加剧55℃循环鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P116'}), (f:FailureMode {entityId:'F144'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'充电上限电压高直接加剧45℃interval鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P116'}), (f:FailureMode {entityId:'F145'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'充电上限电压高直接加剧55℃interval鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F099'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'NP比不足直接导致低温析锂后膨胀'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F152'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'NP比不足直接导致析锂鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P114'}), (f:FailureMode {entityId:'F099'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'大电流充电直接加剧低温析锂后膨胀'}]->(f);
MATCH (p:DesignParam {entityId:'P114'}), (f:FailureMode {entityId:'F152'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'大电流充电直接加剧析锂导致鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P067'}), (f:FailureMode {entityId:'F103'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'注液量过多直接导致电芯涨液'}]->(f);
MATCH (p:DesignParam {entityId:'P092'}), (f:FailureMode {entityId:'F043'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'层数多直接导致膨胀累积加剧常温循环膨胀'}]->(f);
MATCH (p:DesignParam {entityId:'P092'}), (f:FailureMode {entityId:'F044'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'层数多直接导致膨胀累积加剧高温循环膨胀'}]->(f);
MATCH (p:DesignParam {entityId:'P092'}), (f:FailureMode {entityId:'F046'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'层数多直接导致膨胀累积产生顶底部鼓包'}]->(f);
MATCH (p:DesignParam {entityId:'P105'}), (f:FailureMode {entityId:'F036'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'水分控制不良直接加剧高温储存产气'}]->(f);
MATCH (p:DesignParam {entityId:'P105'}), (f:FailureMode {entityId:'F113'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'水分控制不良直接加剧极限高温储存鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P066'}), (f:FailureMode {entityId:'F036'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'电解液配方抗氧化性差直接导致高温储存鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P066'}), (f:FailureMode {entityId:'F082'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'电解液配方不良直接导致高温interval鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P066'}), (f:FailureMode {entityId:'F113'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'电解液配方不良直接导致极限高温鼓气'}]->(f);
MATCH (p:DesignParam {entityId:'P066'}), (f:FailureMode {entityId:'F115'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'电解液配方不良直接导致55℃循环鼓气'}]->(f);

// -------- 完成 --------
// 总计: 节点 55个 (17 FailureMode + 11 Mechanism + 27 DesignParam)
//        关系 184条 (83 HAS_MECHANISM + 63 INFLUENCED_BY + 38 DIRECTLY_AFFECTS)
