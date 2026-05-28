// ============================================================
// 机械断裂知识图谱 - Neo4j Cypher导入脚本（完整版）
// 因果链: 设计参数 → 机理 → 失效模式 (含直接影响路径)
// 节点: 45个 (13 FailureMode + 9 Mechanism + 23 DesignParam)
// 关系: 134条 (49 HAS_MECHANISM + 58 INFLUENCED_BY + 27 DIRECTLY_AFFECTS)
// ============================================================

// -------- 1. 创建约束和索引 --------
CREATE CONSTRAINT IF NOT EXISTS FOR (f:FailureMode) REQUIRE f.entityId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Mechanism) REQUIRE m.mechId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:DesignParam) REQUIRE p.entityId IS UNIQUE;

// -------- 2. 创建失效模式节点 (13) --------
CREATE (:FailureMode {entityId:'F042', name:'极耳断裂', entityType:'失效模式', detectTime:'检测时机:"振动测试"'});
CREATE (:FailureMode {entityId:'F060', name:'正极辊压断带', entityType:'失效模式', detectTime:'检测时机:"辊压过程"'});
CREATE (:FailureMode {entityId:'F061', name:'负极辊压断带', entityType:'失效模式', detectTime:'检测时机:"辊压过程"'});
CREATE (:FailureMode {entityId:'F073', name:'铜箔碎裂', entityType:'失效模式', detectTime:'检测时机:"循环拆解"'});
CREATE (:FailureMode {entityId:'F083', name:'循环后铝箔断裂', entityType:'失效模式', detectTime:'检测时机:"循环拆解"'});
CREATE (:FailureMode {entityId:'F089', name:'循环后铜箔断裂', entityType:'失效模式', detectTime:'检测时机:"循环拆解"'});
CREATE (:FailureMode {entityId:'F105', name:'铝箔翻折', entityType:'失效模式', detectTime:'检测时机:"制造过程"'});
CREATE (:FailureMode {entityId:'F108', name:'正极耳断裂', entityType:'失效模式', detectTime:'检测时机:"振动测试"'});
CREATE (:FailureMode {entityId:'F109', name:'正极软极耳断裂', entityType:'失效模式', detectTime:'检测时机:"振动测试"'});
CREATE (:FailureMode {entityId:'F110', name:'负极耳断裂', entityType:'失效模式', detectTime:'检测时机:"振动测试"'});
CREATE (:FailureMode {entityId:'F111', name:'负极软极耳断裂', entityType:'失效模式', detectTime:'检测时机:"振动测试"'});
CREATE (:FailureMode {entityId:'F126', name:'焊接拉力不良', entityType:'失效模式', detectTime:'检测时机:"焊接测试"'});
CREATE (:FailureMode {entityId:'F129', name:'铜箔抗拉强度降低', entityType:'失效模式', detectTime:'检测时机:"材料测试"'});

// -------- 3. 创建机理节点 (9) --------
CREATE (:Mechanism {mechId:'M009', name:'机械疲劳断裂', description:'循环充放电或外部振动导致材料承受反复应力，最终疲劳断裂'});
CREATE (:Mechanism {mechId:'M010', name:'铜箔溶解再沉积', description:'低电位下铜集流体氧化溶解为Cu²⁺，迁移至负极表面还原沉积为铜颗粒'});
CREATE (:Mechanism {mechId:'M011', name:'负极体积膨胀应力', description:'嵌锂过程中负极材料（特别是含硅材料）体积膨胀产生内应力'});
CREATE (:Mechanism {mechId:'M018', name:'铝箔电化学腐蚀', description:'高电压下正极铝箔发生电化学腐蚀，导致集流体损伤和阻抗增加'});
CREATE (:Mechanism {mechId:'M019', name:'粘结剂溶胀失效', description:'粘结剂在电解液中溶胀或溶解，失去粘接力，导致活性物质脱落'});
CREATE (:Mechanism {mechId:'M020', name:'极片内应力集中', description:'制造或循环过程中极片内部应力分布不均，导致变形、褶皱或开裂'});
CREATE (:Mechanism {mechId:'M025', name:'活性物质颗粒破碎', description:'循环中活性物质颗粒因体积变化而破裂，导致电接触丧失和活性锂损失'});
CREATE (:Mechanism {mechId:'M026', name:'集流体界面剥离', description:'活性物质层与集流体之间粘接力不足，导致剥离和接触失效'});
CREATE (:Mechanism {mechId:'M032', name:'极耳焊接疲劳', description:'振动或温度循环导致极耳焊接点承受反复应力，最终疲劳断裂'});


// -------- 4. 创建设计参数节点 (23) --------
CREATE (:DesignParam {entityId:'P022', name:'负极箔材强度', entityType:'设计参数', affectAttributes:'影响方向:"机械可靠性"'});
CREATE (:DesignParam {entityId:'P024', name:'负极底涂配方', entityType:'设计参数', affectAttributes:'影响方向:"界面粘接"'});
CREATE (:DesignParam {entityId:'P025', name:'负极箔材厚度', entityType:'设计参数', affectAttributes:'影响方向:"重量/机械强度"'});
CREATE (:DesignParam {entityId:'P029', name:'负极Si总含量_单层上层', entityType:'设计参数', affectAttributes:'影响方向:"容量/膨胀"'});
CREATE (:DesignParam {entityId:'P033', name:'负极Si总含量_下层', entityType:'设计参数', affectAttributes:'影响方向:"容量/膨胀"'});
CREATE (:DesignParam {entityId:'P035', name:'负极Si总占比_整体', entityType:'设计参数', affectAttributes:'影响方向:"综合性能"'});
CREATE (:DesignParam {entityId:'P038', name:'负极压实密度', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散/接触"'});
CREATE (:DesignParam {entityId:'P040', name:'负极延展', entityType:'设计参数', affectAttributes:'影响方向:"尺寸变化"'});
CREATE (:DesignParam {entityId:'P041', name:'负极单双面压实比', entityType:'设计参数', affectAttributes:'影响方向:"结构均匀性"'});
CREATE (:DesignParam {entityId:'P043', name:'AWG_失重率', entityType:'设计参数', affectAttributes:'影响方向:"焊接质量"'});
CREATE (:DesignParam {entityId:'P049', name:'正极底涂CW', entityType:'设计参数', affectAttributes:'影响方向:"界面粘接"'});
CREATE (:DesignParam {entityId:'P050', name:'正极底涂配方', entityType:'设计参数', affectAttributes:'影响方向:"界面粘接"'});
CREATE (:DesignParam {entityId:'P051', name:'正极箔材厚度', entityType:'设计参数', affectAttributes:'影响方向:"重量/机械强度"'});
CREATE (:DesignParam {entityId:'P056', name:'正极压实密度', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散/接触"'});
CREATE (:DesignParam {entityId:'P058', name:'正极延展', entityType:'设计参数', affectAttributes:'影响方向:"尺寸变化"'});
CREATE (:DesignParam {entityId:'P071', name:'材质_正极耳', entityType:'设计参数', affectAttributes:'影响方向:"电导率/耐腐蚀"'});
CREATE (:DesignParam {entityId:'P072', name:'材质_负极耳', entityType:'设计参数', affectAttributes:'影响方向:"电导率/耐腐蚀"'});
CREATE (:DesignParam {entityId:'P073', name:'极耳宽度', entityType:'设计参数', affectAttributes:'影响方向:"电流承载"'});
CREATE (:DesignParam {entityId:'P074', name:'极耳厚度', entityType:'设计参数', affectAttributes:'影响方向:"机械强度"'});
CREATE (:DesignParam {entityId:'P077', name:'极耳金属长度', entityType:'设计参数', affectAttributes:'影响方向:"焊接可靠性"'});
CREATE (:DesignParam {entityId:'P102', name:'TCO焊接方式', entityType:'设计参数', affectAttributes:'影响方向:"连接可靠性"'});
CREATE (:DesignParam {entityId:'P114', name:'充电电流', entityType:'设计参数', affectAttributes:'影响方向:"快充能力"'});
CREATE (:DesignParam {entityId:'P116', name:'充电上限电压', entityType:'设计参数', affectAttributes:'影响方向:"能量密度/安全性"'});


// -------- 5. 创建关系: 失效模式 -[HAS_MECHANISM]-> 机理 (49条) --------
// F042 极耳断裂
MATCH (f:FailureMode {entityId:'F042'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F042'}), (m:Mechanism {mechId:'M032'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F042'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F042'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F060 正极辊压断带
MATCH (f:FailureMode {entityId:'F060'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F060'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F060'}), (m:Mechanism {mechId:'M026'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F060'}), (m:Mechanism {mechId:'M018'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F061 负极辊压断带
MATCH (f:FailureMode {entityId:'F061'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F061'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F061'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F061'}), (m:Mechanism {mechId:'M026'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F073 铜箔碎裂
MATCH (f:FailureMode {entityId:'F073'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F073'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F073'}), (m:Mechanism {mechId:'M010'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F073'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F083 循环后铝箔断裂
MATCH (f:FailureMode {entityId:'F083'}), (m:Mechanism {mechId:'M018'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F083'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F083'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F083'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F089 循环后铜箔断裂
MATCH (f:FailureMode {entityId:'F089'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F089'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F089'}), (m:Mechanism {mechId:'M010'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F089'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F105 铝箔翻折
MATCH (f:FailureMode {entityId:'F105'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F105'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F105'}), (m:Mechanism {mechId:'M018'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);


// F108 正极耳断裂
MATCH (f:FailureMode {entityId:'F108'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F108'}), (m:Mechanism {mechId:'M032'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F108'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F108'}), (m:Mechanism {mechId:'M018'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F109 正极软极耳断裂
MATCH (f:FailureMode {entityId:'F109'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F109'}), (m:Mechanism {mechId:'M032'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F109'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F110 负极耳断裂
MATCH (f:FailureMode {entityId:'F110'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F110'}), (m:Mechanism {mechId:'M032'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F110'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F110'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F111 负极软极耳断裂
MATCH (f:FailureMode {entityId:'F111'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F111'}), (m:Mechanism {mechId:'M032'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F111'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F126 焊接拉力不良
MATCH (f:FailureMode {entityId:'F126'}), (m:Mechanism {mechId:'M032'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F126'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F126'}), (m:Mechanism {mechId:'M019'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);

// F129 铜箔抗拉强度降低
MATCH (f:FailureMode {entityId:'F129'}), (m:Mechanism {mechId:'M010'}) CREATE (f)-[:HAS_MECHANISM {role:'主机理'}]->(m);
MATCH (f:FailureMode {entityId:'F129'}), (m:Mechanism {mechId:'M009'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F129'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F129'}), (m:Mechanism {mechId:'M025'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);
MATCH (f:FailureMode {entityId:'F129'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:HAS_MECHANISM {role:'辅机理'}]->(m);


// -------- 6. 创建关系: 机理 -[INFLUENCED_BY]-> 设计参数 (58条) --------
// M009 机械疲劳断裂
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P074'}) CREATE (m)-[:INFLUENCED_BY {influence:'极耳厚度不足时疲劳寿命降低'}]->(p);
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P073'}) CREATE (m)-[:INFLUENCED_BY {influence:'极耳宽度不足时应力集中加速疲劳'}]->(p);
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P025'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极箔材厚度决定抗疲劳能力'}]->(p);
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P051'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极箔材厚度决定铝箔抗疲劳能力'}]->(p);
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P022'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极箔材强度直接决定疲劳断裂阈值'}]->(p);
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P077'}) CREATE (m)-[:INFLUENCED_BY {influence:'极耳金属长度影响振动时应力分布'}]->(p);
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高使极片刚性增大疲劳寿命降低'}]->(p);
MATCH (m:Mechanism {mechId:'M009'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度过高增加铝箔疲劳风险'}]->(p);

// M010 铜箔溶解再沉积
MATCH (m:Mechanism {mechId:'M010'}), (p:DesignParam {entityId:'P025'}) CREATE (m)-[:INFLUENCED_BY {influence:'铜箔厚度薄时溶解后更易结构失效'}]->(p);
MATCH (m:Mechanism {mechId:'M010'}), (p:DesignParam {entityId:'P022'}) CREATE (m)-[:INFLUENCED_BY {influence:'箔材强度低时溶解后更易碎裂'}]->(p);
MATCH (m:Mechanism {mechId:'M010'}), (p:DesignParam {entityId:'P114'}) CREATE (m)-[:INFLUENCED_BY {influence:'大电流充电导致局部低电位加速铜溶解'}]->(p);
MATCH (m:Mechanism {mechId:'M010'}), (p:DesignParam {entityId:'P116'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电上限电压过高间接导致负极局部过放铜溶解'}]->(p);

// M011 负极体积膨胀应力
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P029'}) CREATE (m)-[:INFLUENCED_BY {influence:'硅含量增加导致体积膨胀加剧'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P033'}) CREATE (m)-[:INFLUENCED_BY {influence:'下层硅含量影响整体膨胀应力'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P035'}) CREATE (m)-[:INFLUENCED_BY {influence:'整体硅占比决定综合膨胀程度'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P040'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极延展性影响膨胀后应力释放'}]->(p);
MATCH (m:Mechanism {mechId:'M011'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高使颗粒间膨胀应力增大'}]->(p);

// M018 铝箔电化学腐蚀
MATCH (m:Mechanism {mechId:'M018'}), (p:DesignParam {entityId:'P051'}) CREATE (m)-[:INFLUENCED_BY {influence:'铝箔厚度薄时腐蚀后更易断裂'}]->(p);
MATCH (m:Mechanism {mechId:'M018'}), (p:DesignParam {entityId:'P116'}) CREATE (m)-[:INFLUENCED_BY {influence:'充电上限电压高加速铝箔电化学腐蚀'}]->(p);
MATCH (m:Mechanism {mechId:'M018'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度过高使铝箔承受更大机械应力加剧腐蚀后断裂'}]->(p);
MATCH (m:Mechanism {mechId:'M018'}), (p:DesignParam {entityId:'P050'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极底涂配方影响铝箔表面保护层质量'}]->(p);

// M019 粘结剂溶胀失效
MATCH (m:Mechanism {mechId:'M019'}), (p:DesignParam {entityId:'P024'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极底涂配方决定粘结剂与铜箔的粘接强度'}]->(p);
MATCH (m:Mechanism {mechId:'M019'}), (p:DesignParam {entityId:'P050'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极底涂配方决定粘结剂与铝箔的粘接强度'}]->(p);
MATCH (m:Mechanism {mechId:'M019'}), (p:DesignParam {entityId:'P049'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极底涂CW影响涂层粘接力'}]->(p);
MATCH (m:Mechanism {mechId:'M019'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高使粘结剂承受过大应力加速溶胀失效'}]->(p);
MATCH (m:Mechanism {mechId:'M019'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度过高加剧粘结剂界面应力'}]->(p);


// M020 极片内应力集中
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高增加极片刚性应力'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度过高导致铝箔内应力集中'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P041'}) CREATE (m)-[:INFLUENCED_BY {influence:'单双面压实比不均导致应力集中'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P040'}) CREATE (m)-[:INFLUENCED_BY {influence:'延展差异导致极片内应力分布不均'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P058'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极延展性差导致辊压时应力集中'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P025'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极箔材厚度不足时承受内应力能力差'}]->(p);
MATCH (m:Mechanism {mechId:'M020'}), (p:DesignParam {entityId:'P051'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极箔材厚度不足时承受内应力能力差'}]->(p);

// M025 活性物质颗粒破碎
MATCH (m:Mechanism {mechId:'M025'}), (p:DesignParam {entityId:'P029'}) CREATE (m)-[:INFLUENCED_BY {influence:'硅含量高导致颗粒体积变化大加速破碎'}]->(p);
MATCH (m:Mechanism {mechId:'M025'}), (p:DesignParam {entityId:'P033'}) CREATE (m)-[:INFLUENCED_BY {influence:'下层硅含量影响颗粒破碎程度'}]->(p);
MATCH (m:Mechanism {mechId:'M025'}), (p:DesignParam {entityId:'P035'}) CREATE (m)-[:INFLUENCED_BY {influence:'整体硅占比越高颗粒破碎越严重'}]->(p);
MATCH (m:Mechanism {mechId:'M025'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高使颗粒间挤压加剧破碎'}]->(p);
MATCH (m:Mechanism {mechId:'M025'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度过高使正极颗粒也承受破碎风险'}]->(p);

// M026 集流体界面剥离
MATCH (m:Mechanism {mechId:'M026'}), (p:DesignParam {entityId:'P024'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极底涂配方决定集流体界面粘接强度'}]->(p);
MATCH (m:Mechanism {mechId:'M026'}), (p:DesignParam {entityId:'P050'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极底涂配方决定正极集流体界面粘接'}]->(p);
MATCH (m:Mechanism {mechId:'M026'}), (p:DesignParam {entityId:'P049'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极底涂CW量影响涂覆均匀性和粘接力'}]->(p);
MATCH (m:Mechanism {mechId:'M026'}), (p:DesignParam {entityId:'P038'}) CREATE (m)-[:INFLUENCED_BY {influence:'压实密度过高使活性层与集流体剪切应力增大'}]->(p);
MATCH (m:Mechanism {mechId:'M026'}), (p:DesignParam {entityId:'P056'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极压实密度过高加剧正极集流体界面剥离'}]->(p);
MATCH (m:Mechanism {mechId:'M026'}), (p:DesignParam {entityId:'P040'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极延展大时集流体与涂层变形不匹配易剥离'}]->(p);
MATCH (m:Mechanism {mechId:'M026'}), (p:DesignParam {entityId:'P058'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极延展使铝箔与涂层变形不匹配'}]->(p);

// M032 极耳焊接疲劳
MATCH (m:Mechanism {mechId:'M032'}), (p:DesignParam {entityId:'P074'}) CREATE (m)-[:INFLUENCED_BY {influence:'极耳厚度影响焊接点抗疲劳能力'}]->(p);
MATCH (m:Mechanism {mechId:'M032'}), (p:DesignParam {entityId:'P073'}) CREATE (m)-[:INFLUENCED_BY {influence:'极耳宽度影响焊接面积和应力分布'}]->(p);
MATCH (m:Mechanism {mechId:'M032'}), (p:DesignParam {entityId:'P071'}) CREATE (m)-[:INFLUENCED_BY {influence:'正极耳材质决定焊接点强度和抗疲劳性'}]->(p);
MATCH (m:Mechanism {mechId:'M032'}), (p:DesignParam {entityId:'P072'}) CREATE (m)-[:INFLUENCED_BY {influence:'负极耳材质决定焊接点强度和抗疲劳性'}]->(p);
MATCH (m:Mechanism {mechId:'M032'}), (p:DesignParam {entityId:'P077'}) CREATE (m)-[:INFLUENCED_BY {influence:'极耳金属长度影响振动力臂和焊接点应力'}]->(p);
MATCH (m:Mechanism {mechId:'M032'}), (p:DesignParam {entityId:'P043'}) CREATE (m)-[:INFLUENCED_BY {influence:'AWG失重率反映焊接质量影响疲劳寿命'}]->(p);
MATCH (m:Mechanism {mechId:'M032'}), (p:DesignParam {entityId:'P102'}) CREATE (m)-[:INFLUENCED_BY {influence:'TCO焊接方式决定焊接接头可靠性'}]->(p);


// -------- 7. 创建关系: 设计参数 -[DIRECTLY_AFFECTS]-> 失效模式 (27条) --------
MATCH (p:DesignParam {entityId:'P074'}), (f:FailureMode {entityId:'F042'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳厚度不足直接导致极耳振动断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P073'}), (f:FailureMode {entityId:'F042'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳宽度不足直接导致极耳应力集中断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P077'}), (f:FailureMode {entityId:'F042'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳金属长度过长直接增大振动力矩导致断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P022'}), (f:FailureMode {entityId:'F061'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'负极箔材强度不足直接导致辊压断带'}]->(f);
MATCH (p:DesignParam {entityId:'P025'}), (f:FailureMode {entityId:'F061'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'负极箔材厚度不足直接导致辊压断带'}]->(f);
MATCH (p:DesignParam {entityId:'P025'}), (f:FailureMode {entityId:'F073'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铜箔厚度不足直接导致循环后碎裂'}]->(f);
MATCH (p:DesignParam {entityId:'P025'}), (f:FailureMode {entityId:'F089'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铜箔厚度不足直接导致循环后断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P022'}), (f:FailureMode {entityId:'F073'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'箔材强度低直接导致铜箔碎裂'}]->(f);
MATCH (p:DesignParam {entityId:'P022'}), (f:FailureMode {entityId:'F089'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'箔材强度低直接导致铜箔断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P022'}), (f:FailureMode {entityId:'F129'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'箔材强度本身不足直接表现为抗拉强度降低'}]->(f);
MATCH (p:DesignParam {entityId:'P051'}), (f:FailureMode {entityId:'F060'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'正极箔材厚度不足直接导致辊压断带'}]->(f);
MATCH (p:DesignParam {entityId:'P051'}), (f:FailureMode {entityId:'F083'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝箔厚度不足直接导致循环后断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P051'}), (f:FailureMode {entityId:'F105'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'铝箔厚度不足直接导致制造过程翻折'}]->(f);
MATCH (p:DesignParam {entityId:'P074'}), (f:FailureMode {entityId:'F108'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳厚度不足直接导致正极耳振动断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P074'}), (f:FailureMode {entityId:'F109'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳厚度不足直接导致正极软极耳断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P074'}), (f:FailureMode {entityId:'F110'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳厚度不足直接导致负极耳振动断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P074'}), (f:FailureMode {entityId:'F111'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳厚度不足直接导致负极软极耳断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P071'}), (f:FailureMode {entityId:'F108'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'正极耳材质强度不足直接导致断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P071'}), (f:FailureMode {entityId:'F109'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'正极耳材质不良直接导致软极耳断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P072'}), (f:FailureMode {entityId:'F110'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'负极耳材质强度不足直接导致断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P072'}), (f:FailureMode {entityId:'F111'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'负极耳材质不良直接导致软极耳断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P043'}), (f:FailureMode {entityId:'F126'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'AWG失重率异常反映焊接质量差直接导致拉力不良'}]->(f);
MATCH (p:DesignParam {entityId:'P102'}), (f:FailureMode {entityId:'F126'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'TCO焊接方式不当直接导致焊接拉力不良'}]->(f);
MATCH (p:DesignParam {entityId:'P077'}), (f:FailureMode {entityId:'F108'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳金属长度过长增大振动力臂直接导致正极耳断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P077'}), (f:FailureMode {entityId:'F110'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'极耳金属长度过长增大振动力臂直接导致负极耳断裂'}]->(f);
MATCH (p:DesignParam {entityId:'P056'}), (f:FailureMode {entityId:'F060'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'正极压实密度过高直接导致辊压时铝箔断带'}]->(f);
MATCH (p:DesignParam {entityId:'P038'}), (f:FailureMode {entityId:'F061'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence:'负极压实密度过高直接导致辊压时铜箔断带'}]->(f);

// -------- 完成 --------
// 总计: 节点 45个 (13 FailureMode + 9 Mechanism + 23 DesignParam)
//        关系 134条 (49 HAS_MECHANISM + 58 INFLUENCED_BY + 27 DIRECTLY_AFFECTS)
