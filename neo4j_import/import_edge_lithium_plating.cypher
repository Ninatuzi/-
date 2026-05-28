// ============================================================
// 边缘析锂知识图谱 - Neo4j Cypher导入脚本
// 因果链: 设计参数 → 机理 → 失效模式 (含直接影响路径)
// ============================================================

// -------- 1. 创建约束和索引 --------
CREATE CONSTRAINT IF NOT EXISTS FOR (f:FailureMode) REQUIRE f.entityId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Mechanism) REQUIRE m.mechId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:DesignParam) REQUIRE p.entityId IS UNIQUE;

// -------- 2. 创建失效模式节点 --------
CREATE (f:FailureMode {entityId: 'F013', name: '极片边缘析锂', entityType: '失效模式', detectTime: '检测时机:"充电后拆解"'});
CREATE (f:FailureMode {entityId: 'F014', name: '负极尾部两折边缘析锂', entityType: '失效模式', detectTime: '检测时机:"循环后拆解"'});
CREATE (f:FailureMode {entityId: 'F015', name: '极耳胶纸边缘析锂', entityType: '失效模式', detectTime: '检测时机:"循环后拆解"'});
CREATE (f:FailureMode {entityId: 'F018', name: 'OH边缘析锂', entityType: '失效模式', detectTime: '检测时机:"充电后拆解"'});
CREATE (f:FailureMode {entityId: 'F019', name: '极耳位极片边缘月牙形析锂', entityType: '失效模式', detectTime: '检测时机:"循环后拆解"'});
CREATE (f:FailureMode {entityId: 'F023', name: '负极单双面交界处析锂', entityType: '失效模式', detectTime: '检测时机:"循环后拆解"'});
CREATE (f:FailureMode {entityId: 'F034', name: '叠片顶部极耳位边缘析锂', entityType: '失效模式', detectTime: '检测时机:"充电后拆解"'});

// -------- 3. 创建机理节点 --------
CREATE (m:Mechanism {mechId: 'M001', name: '锂离子沉积过电位不足', description: '负极电位接近或低于锂沉积电位（0V vs. Li+/Li），导致金属锂在负极表面沉积'});
CREATE (m:Mechanism {mechId: 'M002', name: '局部电流密度集中', description: '极片边缘、缺陷处或对齐不良区域的电流密度显著高于平均，导致局部过电位过大'});
CREATE (m:Mechanism {mechId: 'M003', name: '离子扩散动力学受限', description: '锂离子在电极材料固相或电解液中传输速率不足，造成浓差极化'});
CREATE (m:Mechanism {mechId: 'M004', name: '电解液浸润不良', description: '电极孔隙未被电解液充分填充，形成高阻抗界面，影响离子传输'});
CREATE (m:Mechanism {mechId: 'M011', name: '负极体积膨胀应力', description: '嵌锂过程中负极材料（特别是含硅材料）体积膨胀产生内应力'});
CREATE (m:Mechanism {mechId: 'M020', name: '极片内应力集中', description: '制造或循环过程中极片内部应力分布不均，导致变形、褶皱或开裂'});
CREATE (m:Mechanism {mechId: 'M040', name: '锂离子浓度极化', description: '高倍率下电极表面与体相锂离子浓度差异过大，导致电位急剧变化'});

// -------- 4. 创建设计参数节点 --------
CREATE (p:DesignParam {entityId: 'P018', name: '负极极片宽度', entityType: '设计参数', affectAttributes: '影响方向:"电流分布"'});
CREATE (p:DesignParam {entityId: 'P021', name: '负极双面厚度_辊压后', entityType: '设计参数', affectAttributes: '影响方向:"离子扩散距离"'});
CREATE (p:DesignParam {entityId: 'P029', name: '负极Si总含量_单层上层', entityType: '设计参数', affectAttributes: '影响方向:"容量/膨胀"'});
CREATE (p:DesignParam {entityId: 'P033', name: '负极Si总含量_下层', entityType: '设计参数', affectAttributes: '影响方向:"容量/膨胀"'});
CREATE (p:DesignParam {entityId: 'P035', name: '负极Si总占比_整体', entityType: '设计参数', affectAttributes: '影响方向:"综合性能"'});
CREATE (p:DesignParam {entityId: 'P038', name: '负极压实密度', entityType: '设计参数', affectAttributes: '影响方向:"离子扩散/接触"'});
CREATE (p:DesignParam {entityId: 'P039', name: '负极面密度', entityType: '设计参数', affectAttributes: '影响方向:"容量均匀性"'});
CREATE (p:DesignParam {entityId: 'P040', name: '负极延展', entityType: '设计参数', affectAttributes: '影响方向:"尺寸变化"'});
CREATE (p:DesignParam {entityId: 'P041', name: '负极单双面压实比', entityType: '设计参数', affectAttributes: '影响方向:"结构均匀性"'});
CREATE (p:DesignParam {entityId: 'P059', name: '隔膜宽度', entityType: '设计参数', affectAttributes: '影响方向:"安全余量"'});
CREATE (p:DesignParam {entityId: 'P067', name: '注液量_均值', entityType: '设计参数', affectAttributes: '影响方向:"界面润湿"'});
CREATE (p:DesignParam {entityId: 'P068', name: '保液量_下限', entityType: '设计参数', affectAttributes: '影响方向:"循环寿命"'});
CREATE (p:DesignParam {entityId: 'P096', name: 'AC_OH', entityType: '设计参数', affectAttributes: '影响方向:"对齐精度"'});
CREATE (p:DesignParam {entityId: 'P097', name: 'SA_OH', entityType: '设计参数', affectAttributes: '影响方向:"对齐精度"'});
CREATE (p:DesignParam {entityId: 'P098', name: 'PJ_GAP', entityType: '设计参数', affectAttributes: '影响方向:"极片间隙"'});
CREATE (p:DesignParam {entityId: 'P099', name: 'PA_Gap', entityType: '设计参数', affectAttributes: '影响方向:"极片间隙"'});
CREATE (p:DesignParam {entityId: 'P113', name: '负极过量_NP比', entityType: '设计参数', affectAttributes: '影响方向:"析锂风险"'});
CREATE (p:DesignParam {entityId: 'P114', name: '充电电流', entityType: '设计参数', affectAttributes: '影响方向:"快充能力"'});
CREATE (p:DesignParam {entityId: 'P122', name: '隔膜孔径', entityType: '设计参数', affectAttributes: '影响方向:"离子传输"'});

// -------- 5. 创建关系: 失效模式 -[HAS_MECHANISM]-> 机理 --------
// F013 极片边缘析锂
MATCH (f:FailureMode {entityId: 'F013'}), (m:Mechanism {mechId: 'M002'}) CREATE (f)-[:HAS_MECHANISM {role: '主机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F013'}), (m:Mechanism {mechId: 'M001'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F013'}), (m:Mechanism {mechId: 'M003'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);

// F014 负极尾部两折边缘析锂
MATCH (f:FailureMode {entityId: 'F014'}), (m:Mechanism {mechId: 'M020'}) CREATE (f)-[:HAS_MECHANISM {role: '主机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F014'}), (m:Mechanism {mechId: 'M002'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F014'}), (m:Mechanism {mechId: 'M011'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);

// F015 极耳胶纸边缘析锂
MATCH (f:FailureMode {entityId: 'F015'}), (m:Mechanism {mechId: 'M002'}) CREATE (f)-[:HAS_MECHANISM {role: '主机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F015'}), (m:Mechanism {mechId: 'M004'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F015'}), (m:Mechanism {mechId: 'M003'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);

// F018 OH边缘析锂
MATCH (f:FailureMode {entityId: 'F018'}), (m:Mechanism {mechId: 'M002'}) CREATE (f)-[:HAS_MECHANISM {role: '主机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F018'}), (m:Mechanism {mechId: 'M004'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F018'}), (m:Mechanism {mechId: 'M001'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);

// F019 极耳位极片边缘月牙形析锂
MATCH (f:FailureMode {entityId: 'F019'}), (m:Mechanism {mechId: 'M002'}) CREATE (f)-[:HAS_MECHANISM {role: '主机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F019'}), (m:Mechanism {mechId: 'M040'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F019'}), (m:Mechanism {mechId: 'M003'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);

// F023 负极单双面交界处析锂
MATCH (f:FailureMode {entityId: 'F023'}), (m:Mechanism {mechId: 'M020'}) CREATE (f)-[:HAS_MECHANISM {role: '主机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F023'}), (m:Mechanism {mechId: 'M002'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F023'}), (m:Mechanism {mechId: 'M011'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);

// F034 叠片顶部极耳位边缘析锂
MATCH (f:FailureMode {entityId: 'F034'}), (m:Mechanism {mechId: 'M002'}) CREATE (f)-[:HAS_MECHANISM {role: '主机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F034'}), (m:Mechanism {mechId: 'M040'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);
MATCH (f:FailureMode {entityId: 'F034'}), (m:Mechanism {mechId: 'M004'}) CREATE (f)-[:HAS_MECHANISM {role: '辅机理'}]->(m);

// -------- 6. 创建关系: 机理 -[INFLUENCED_BY]-> 设计参数 --------
// M001 锂离子沉积过电位不足
MATCH (m:Mechanism {mechId: 'M001'}), (p:DesignParam {entityId: 'P113'}) CREATE (m)-[:INFLUENCED_BY {influence: 'NP比不足时负极过电位降低导致析锂电位'}]->(p);
MATCH (m:Mechanism {mechId: 'M001'}), (p:DesignParam {entityId: 'P114'}) CREATE (m)-[:INFLUENCED_BY {influence: '充电电流过大导致负极电位快速下降'}]->(p);
MATCH (m:Mechanism {mechId: 'M001'}), (p:DesignParam {entityId: 'P038'}) CREATE (m)-[:INFLUENCED_BY {influence: '压实密度过高限制锂离子嵌入动力学'}]->(p);

// M002 局部电流密度集中
MATCH (m:Mechanism {mechId: 'M002'}), (p:DesignParam {entityId: 'P018'}) CREATE (m)-[:INFLUENCED_BY {influence: '极片宽度决定边缘电流分布均匀性'}]->(p);
MATCH (m:Mechanism {mechId: 'M002'}), (p:DesignParam {entityId: 'P096'}) CREATE (m)-[:INFLUENCED_BY {influence: 'AC_OH对齐精度影响边缘电流密度'}]->(p);
MATCH (m:Mechanism {mechId: 'M002'}), (p:DesignParam {entityId: 'P097'}) CREATE (m)-[:INFLUENCED_BY {influence: 'SA_OH对齐精度影响边缘电流密度'}]->(p);
MATCH (m:Mechanism {mechId: 'M002'}), (p:DesignParam {entityId: 'P098'}) CREATE (m)-[:INFLUENCED_BY {influence: 'PJ_GAP间隙影响边缘区域电流集中'}]->(p);
MATCH (m:Mechanism {mechId: 'M002'}), (p:DesignParam {entityId: 'P099'}) CREATE (m)-[:INFLUENCED_BY {influence: 'PA_Gap间隙影响极片边缘电流分布'}]->(p);
MATCH (m:Mechanism {mechId: 'M002'}), (p:DesignParam {entityId: 'P059'}) CREATE (m)-[:INFLUENCED_BY {influence: '隔膜宽度余量不足时边缘离子传输路径异常'}]->(p);

// M003 离子扩散动力学受限
MATCH (m:Mechanism {mechId: 'M003'}), (p:DesignParam {entityId: 'P038'}) CREATE (m)-[:INFLUENCED_BY {influence: '压实密度过高使固相扩散路径增长'}]->(p);
MATCH (m:Mechanism {mechId: 'M003'}), (p:DesignParam {entityId: 'P021'}) CREATE (m)-[:INFLUENCED_BY {influence: '极片厚度增大使锂离子扩散距离增加'}]->(p);
MATCH (m:Mechanism {mechId: 'M003'}), (p:DesignParam {entityId: 'P122'}) CREATE (m)-[:INFLUENCED_BY {influence: '隔膜孔径影响离子传输通道'}]->(p);
MATCH (m:Mechanism {mechId: 'M003'}), (p:DesignParam {entityId: 'P039'}) CREATE (m)-[:INFLUENCED_BY {influence: '面密度过高增加扩散距离'}]->(p);

// M004 电解液浸润不良
MATCH (m:Mechanism {mechId: 'M004'}), (p:DesignParam {entityId: 'P067'}) CREATE (m)-[:INFLUENCED_BY {influence: '注液量不足导致边缘区域浸润不良'}]->(p);
MATCH (m:Mechanism {mechId: 'M004'}), (p:DesignParam {entityId: 'P068'}) CREATE (m)-[:INFLUENCED_BY {influence: '保液量不足导致循环后边缘干涸'}]->(p);
MATCH (m:Mechanism {mechId: 'M004'}), (p:DesignParam {entityId: 'P038'}) CREATE (m)-[:INFLUENCED_BY {influence: '压实密度过高使孔隙率下降电解液难渗透'}]->(p);

// M011 负极体积膨胀应力
MATCH (m:Mechanism {mechId: 'M011'}), (p:DesignParam {entityId: 'P029'}) CREATE (m)-[:INFLUENCED_BY {influence: '硅含量增加导致体积膨胀加剧'}]->(p);
MATCH (m:Mechanism {mechId: 'M011'}), (p:DesignParam {entityId: 'P033'}) CREATE (m)-[:INFLUENCED_BY {influence: '下层硅含量影响整体膨胀应力'}]->(p);
MATCH (m:Mechanism {mechId: 'M011'}), (p:DesignParam {entityId: 'P035'}) CREATE (m)-[:INFLUENCED_BY {influence: '整体硅占比决定综合膨胀程度'}]->(p);
MATCH (m:Mechanism {mechId: 'M011'}), (p:DesignParam {entityId: 'P040'}) CREATE (m)-[:INFLUENCED_BY {influence: '负极延展性影响膨胀后应力释放'}]->(p);

// M020 极片内应力集中
MATCH (m:Mechanism {mechId: 'M020'}), (p:DesignParam {entityId: 'P041'}) CREATE (m)-[:INFLUENCED_BY {influence: '单双面压实比不均导致应力集中'}]->(p);
MATCH (m:Mechanism {mechId: 'M020'}), (p:DesignParam {entityId: 'P040'}) CREATE (m)-[:INFLUENCED_BY {influence: '延展差异导致极片内应力分布不均'}]->(p);
MATCH (m:Mechanism {mechId: 'M020'}), (p:DesignParam {entityId: 'P038'}) CREATE (m)-[:INFLUENCED_BY {influence: '压实密度过高增加极片刚性应力'}]->(p);

// M040 锂离子浓度极化
MATCH (m:Mechanism {mechId: 'M040'}), (p:DesignParam {entityId: 'P114'}) CREATE (m)-[:INFLUENCED_BY {influence: '大电流充电加剧表面浓度极化'}]->(p);
MATCH (m:Mechanism {mechId: 'M040'}), (p:DesignParam {entityId: 'P021'}) CREATE (m)-[:INFLUENCED_BY {influence: '厚极片使体相与表面浓度差增大'}]->(p);
MATCH (m:Mechanism {mechId: 'M040'}), (p:DesignParam {entityId: 'P039'}) CREATE (m)-[:INFLUENCED_BY {influence: '高面密度增加浓差极化程度'}]->(p);

// -------- 7. 创建关系: 设计参数 -[DIRECTLY_AFFECTS]-> 失效模式 --------
MATCH (p:DesignParam {entityId: 'P113'}), (f:FailureMode {entityId: 'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'NP比不足直接导致极片边缘析锂风险'}]->(f);
MATCH (p:DesignParam {entityId: 'P113'}), (f:FailureMode {entityId: 'F014'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'NP比不足时尾部两折区域更易析锂'}]->(f);
MATCH (p:DesignParam {entityId: 'P113'}), (f:FailureMode {entityId: 'F018'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'NP比不足时OH边缘析锂风险增大'}]->(f);
MATCH (p:DesignParam {entityId: 'P096'}), (f:FailureMode {entityId: 'F018'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'AC_OH对齐偏差直接导致OH边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId: 'P097'}), (f:FailureMode {entityId: 'F018'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'SA_OH对齐偏差直接导致OH边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId: 'P098'}), (f:FailureMode {entityId: 'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'PJ_GAP过小直接导致极片边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId: 'P099'}), (f:FailureMode {entityId: 'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'PA_Gap过小直接导致极片边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId: 'P041'}), (f:FailureMode {entityId: 'F023'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: '单双面压实比不均直接导致交界处析锂'}]->(f);
MATCH (p:DesignParam {entityId: 'P096'}), (f:FailureMode {entityId: 'F034'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: 'AC_OH偏差直接导致叠片顶部边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId: 'P114'}), (f:FailureMode {entityId: 'F019'}) CREATE (p)-[:DIRECTLY_AFFECTS {influence: '大电流充电直接导致极耳位边缘析锂'}]->(f);

// -------- 完成 --------
// 统计: 节点 33个 (7个FailureMode + 7个Mechanism + 19个DesignParam)
//        关系 57条 (21条HAS_MECHANISM + 26条INFLUENCED_BY + 10条DIRECTLY_AFFECTS)
