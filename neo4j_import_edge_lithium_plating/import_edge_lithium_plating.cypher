// ============================================================
// 边缘析锂知识图谱 - Neo4j Cypher导入脚本（重构版）
// 
// 关系体系:
//   F_EDGE --[HAS_SUBTYPE]--> 子失效
//   子失效 --[PRIMARY_MECHANISM]--> 主机理
//   子失效 --[SECONDARY_MECHANISM]--> 辅机理
//   参数  --[INFLUENCES]--> 机理
//   参数  --[DIRECTLY_AFFECTS]--> 子失效
//   机理  --[CAUSES]--> 机理 (因果)
//   机理  --[CONTRIBUTES]--> 机理 (辅助贡献)
//   机理  --[EVOLVES_TO]--> 机理 (演化)
//
// 节点: 43个 (8 FailureMode + 11 Mechanism + 24 DesignParam)
// 关系: 107条
// ============================================================

// -------- 1. 约束 --------
CREATE CONSTRAINT IF NOT EXISTS FOR (f:FailureMode) REQUIRE f.entityId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Mechanism) REQUIRE m.mechId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:DesignParam) REQUIRE p.entityId IS UNIQUE;

// -------- 2. 失效模式节点 (1根节点 + 7子节点) --------
CREATE (:FailureMode {entityId:'F_EDGE', name:'边缘析锂', entityType:'失效模式(大类)', detectTime:'一级分类'});
CREATE (:FailureMode {entityId:'F013', name:'极片边缘析锂', entityType:'失效模式', detectTime:'检测时机:"充电后拆解"'});
CREATE (:FailureMode {entityId:'F014', name:'负极尾部两折边缘析锂', entityType:'失效模式', detectTime:'检测时机:"循环后拆解"'});
CREATE (:FailureMode {entityId:'F015', name:'极耳胶纸边缘析锂', entityType:'失效模式', detectTime:'检测时机:"循环后拆解"'});
CREATE (:FailureMode {entityId:'F018', name:'OH边缘析锂', entityType:'失效模式', detectTime:'检测时机:"充电后拆解"'});
CREATE (:FailureMode {entityId:'F019', name:'极耳位极片边缘月牙形析锂', entityType:'失效模式', detectTime:'检测时机:"循环后拆解"'});
CREATE (:FailureMode {entityId:'F023', name:'负极单双面交界处析锂', entityType:'失效模式', detectTime:'检测时机:"循环后拆解"'});
CREATE (:FailureMode {entityId:'F034', name:'叠片顶部极耳位边缘析锂', entityType:'失效模式', detectTime:'检测时机:"充电后拆解"'});

// -------- 3. 机理节点 (11) --------
CREATE (:Mechanism {mechId:'M001', name:'锂离子沉积过电位不足', description:'负极电位接近或低于锂沉积电位（0V vs. Li+/Li），导致金属锂在负极表面沉积'});
CREATE (:Mechanism {mechId:'M002', name:'局部电流密度集中', description:'极片边缘、缺陷处或对齐不良区域的电流密度显著高于平均，导致局部过电位过大'});
CREATE (:Mechanism {mechId:'M003', name:'离子扩散动力学受限', description:'锂离子在电极材料固相或电解液中传输速率不足，造成浓差极化'});
CREATE (:Mechanism {mechId:'M004', name:'电解液浸润不良', description:'电极孔隙未被电解液充分填充，形成高阻抗界面，影响离子传输'});
CREATE (:Mechanism {mechId:'M005', name:'SEI持续生长消耗活性锂', description:'循环中固体电解质界面（SEI）不断破裂和修复，不可逆消耗活性锂离子'});
CREATE (:Mechanism {mechId:'M011', name:'负极体积膨胀应力', description:'嵌锂过程中负极材料（特别是含硅材料）体积膨胀产生内应力'});
CREATE (:Mechanism {mechId:'M015', name:'电解液耗尽', description:'长期循环中电解液被副反应不断消耗，最终导致界面干涸、阻抗急剧上升'});
CREATE (:Mechanism {mechId:'M020', name:'极片内应力集中', description:'制造或循环过程中极片内部应力分布不均，导致变形、褶皱或开裂'});
CREATE (:Mechanism {mechId:'M024', name:'锂枝晶生长', description:'析出的锂金属形成枝晶状结构，可能刺穿隔膜导致内短路'});
CREATE (:Mechanism {mechId:'M039', name:'电解液分解产物堆积', description:'电解液分解产生的固体产物在电极表面或隔膜孔隙中堆积，阻塞离子通道'});
CREATE (:Mechanism {mechId:'M040', name:'锂离子浓度极化', description:'高倍率下电极表面与体相锂离子浓度差异过大，导致电位急剧变化'});


// -------- 4. 设计参数节点 (24) --------
CREATE (:DesignParam {entityId:'P018', name:'负极极片宽度', entityType:'设计参数', affectAttributes:'影响方向:"电流分布"'});
CREATE (:DesignParam {entityId:'P021', name:'负极双面厚度_辊压后', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散距离"'});
CREATE (:DesignParam {entityId:'P029', name:'负极Si总含量_单层上层', entityType:'设计参数', affectAttributes:'影响方向:"容量/膨胀"'});
CREATE (:DesignParam {entityId:'P033', name:'负极Si总含量_下层', entityType:'设计参数', affectAttributes:'影响方向:"容量/膨胀"'});
CREATE (:DesignParam {entityId:'P035', name:'负极Si总占比_整体', entityType:'设计参数', affectAttributes:'影响方向:"综合性能"'});
CREATE (:DesignParam {entityId:'P037', name:'负极克容量', entityType:'设计参数', affectAttributes:'影响方向:"容量发挥"'});
CREATE (:DesignParam {entityId:'P038', name:'负极压实密度', entityType:'设计参数', affectAttributes:'影响方向:"离子扩散/接触"'});
CREATE (:DesignParam {entityId:'P039', name:'负极面密度', entityType:'设计参数', affectAttributes:'影响方向:"容量均匀性"'});
CREATE (:DesignParam {entityId:'P040', name:'负极延展', entityType:'设计参数', affectAttributes:'影响方向:"尺寸变化"'});
CREATE (:DesignParam {entityId:'P041', name:'负极单双面压实比', entityType:'设计参数', affectAttributes:'影响方向:"结构均匀性"'});
CREATE (:DesignParam {entityId:'P044', name:'正极极片宽度', entityType:'设计参数', affectAttributes:'影响方向:"电流分布"'});
CREATE (:DesignParam {entityId:'P059', name:'隔膜宽度', entityType:'设计参数', affectAttributes:'影响方向:"安全余量"'});
CREATE (:DesignParam {entityId:'P061', name:'隔膜厚度_基材加涂层', entityType:'设计参数', affectAttributes:'影响方向:"安全性/阻抗"'});
CREATE (:DesignParam {entityId:'P064', name:'隔膜涂层厚度_陶瓷加涂胶', entityType:'设计参数', affectAttributes:'影响方向:"热稳定性/粘接"'});
CREATE (:DesignParam {entityId:'P067', name:'注液量_均值', entityType:'设计参数', affectAttributes:'影响方向:"界面润湿"'});
CREATE (:DesignParam {entityId:'P068', name:'保液量_下限', entityType:'设计参数', affectAttributes:'影响方向:"循环寿命"'});
CREATE (:DesignParam {entityId:'P096', name:'AC_OH', entityType:'设计参数', affectAttributes:'影响方向:"对齐精度"'});
CREATE (:DesignParam {entityId:'P097', name:'SA_OH', entityType:'设计参数', affectAttributes:'影响方向:"对齐精度"'});
CREATE (:DesignParam {entityId:'P098', name:'PJ_GAP', entityType:'设计参数', affectAttributes:'影响方向:"极片间隙"'});
CREATE (:DesignParam {entityId:'P099', name:'PA_Gap', entityType:'设计参数', affectAttributes:'影响方向:"极片间隙"'});
CREATE (:DesignParam {entityId:'P107', name:'化成压力', entityType:'设计参数', affectAttributes:'影响方向:"界面接触"'});
CREATE (:DesignParam {entityId:'P113', name:'负极过量_NP比', entityType:'设计参数', affectAttributes:'影响方向:"析锂风险"'});
CREATE (:DesignParam {entityId:'P114', name:'充电电流', entityType:'设计参数', affectAttributes:'影响方向:"快充能力"'});
CREATE (:DesignParam {entityId:'P122', name:'隔膜孔径', entityType:'设计参数', affectAttributes:'影响方向:"离子传输"'});

// -------- 5. HAS_SUBTYPE: 根节点→子失效 (7条) --------
MATCH (root:FailureMode {entityId:'F_EDGE'}), (f:FailureMode {entityId:'F013'}) CREATE (root)-[:HAS_SUBTYPE]->(f);
MATCH (root:FailureMode {entityId:'F_EDGE'}), (f:FailureMode {entityId:'F014'}) CREATE (root)-[:HAS_SUBTYPE]->(f);
MATCH (root:FailureMode {entityId:'F_EDGE'}), (f:FailureMode {entityId:'F015'}) CREATE (root)-[:HAS_SUBTYPE]->(f);
MATCH (root:FailureMode {entityId:'F_EDGE'}), (f:FailureMode {entityId:'F018'}) CREATE (root)-[:HAS_SUBTYPE]->(f);
MATCH (root:FailureMode {entityId:'F_EDGE'}), (f:FailureMode {entityId:'F019'}) CREATE (root)-[:HAS_SUBTYPE]->(f);
MATCH (root:FailureMode {entityId:'F_EDGE'}), (f:FailureMode {entityId:'F023'}) CREATE (root)-[:HAS_SUBTYPE]->(f);
MATCH (root:FailureMode {entityId:'F_EDGE'}), (f:FailureMode {entityId:'F034'}) CREATE (root)-[:HAS_SUBTYPE]->(f);

// -------- 6. PRIMARY_MECHANISM: 子失效→主机理 (7条) --------
MATCH (f:FailureMode {entityId:'F013'}), (m:Mechanism {mechId:'M002'}) CREATE (f)-[:PRIMARY_MECHANISM {description:'极片边缘电流密度集中是直线析锂的主要驱动'}]->(m);
MATCH (f:FailureMode {entityId:'F014'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:PRIMARY_MECHANISM {description:'两折区域内应力集中导致局部接触不良引发析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F015'}), (m:Mechanism {mechId:'M002'}) CREATE (f)-[:PRIMARY_MECHANISM {description:'胶纸边缘处电流密度突变是析锂主因'}]->(m);
MATCH (f:FailureMode {entityId:'F018'}), (m:Mechanism {mechId:'M002'}) CREATE (f)-[:PRIMARY_MECHANISM {description:'OH区域对齐偏差导致局部电流密度过大'}]->(m);
MATCH (f:FailureMode {entityId:'F019'}), (m:Mechanism {mechId:'M002'}) CREATE (f)-[:PRIMARY_MECHANISM {description:'极耳位几何突变导致电流密度集中形成月牙形析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F023'}), (m:Mechanism {mechId:'M020'}) CREATE (f)-[:PRIMARY_MECHANISM {description:'单双面交界处压实比突变导致应力集中引发析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F034'}), (m:Mechanism {mechId:'M002'}) CREATE (f)-[:PRIMARY_MECHANISM {description:'叠片顶部极耳位对齐偏差导致电流密度集中'}]->(m);


// -------- 7. SECONDARY_MECHANISM: 子失效→辅机理 (25条) --------
MATCH (f:FailureMode {entityId:'F013'}), (m:Mechanism {mechId:'M001'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'边缘过电位不足辅助促进析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F013'}), (m:Mechanism {mechId:'M003'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'边缘区域扩散受限加剧局部极化'}]->(m);
MATCH (f:FailureMode {entityId:'F013'}), (m:Mechanism {mechId:'M024'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'初始析锂后枝晶生长使问题恶化'}]->(m);
MATCH (f:FailureMode {entityId:'F014'}), (m:Mechanism {mechId:'M002'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'两折区域同时存在电流密度不均'}]->(m);
MATCH (f:FailureMode {entityId:'F014'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'硅膨胀导致两折区域结构应力加剧'}]->(m);
MATCH (f:FailureMode {entityId:'F014'}), (m:Mechanism {mechId:'M005'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'循环中SEI反复破裂消耗活性锂加剧析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F014'}), (m:Mechanism {mechId:'M039'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'分解产物堆积阻碍离子传输'}]->(m);
MATCH (f:FailureMode {entityId:'F015'}), (m:Mechanism {mechId:'M004'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'胶纸边缘电解液浸润不良'}]->(m);
MATCH (f:FailureMode {entityId:'F015'}), (m:Mechanism {mechId:'M003'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'胶纸区域离子扩散受限'}]->(m);
MATCH (f:FailureMode {entityId:'F015'}), (m:Mechanism {mechId:'M005'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'SEI生长消耗活性锂使析锂恶化'}]->(m);
MATCH (f:FailureMode {entityId:'F015'}), (m:Mechanism {mechId:'M015'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'边缘电解液优先耗尽加剧析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F018'}), (m:Mechanism {mechId:'M004'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'OH区域边缘浸润不良'}]->(m);
MATCH (f:FailureMode {entityId:'F018'}), (m:Mechanism {mechId:'M001'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'OH区域过电位不足辅助析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F018'}), (m:Mechanism {mechId:'M015'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'OH边缘电解液优先耗尽'}]->(m);
MATCH (f:FailureMode {entityId:'F019'}), (m:Mechanism {mechId:'M040'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'极耳位大电流浓度极化加剧'}]->(m);
MATCH (f:FailureMode {entityId:'F019'}), (m:Mechanism {mechId:'M003'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'极耳位离子扩散受限'}]->(m);
MATCH (f:FailureMode {entityId:'F019'}), (m:Mechanism {mechId:'M005'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'SEI反复破裂加剧月牙形析锂'}]->(m);
MATCH (f:FailureMode {entityId:'F019'}), (m:Mechanism {mechId:'M024'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'析锂后枝晶生长扩展月牙形区域'}]->(m);
MATCH (f:FailureMode {entityId:'F019'}), (m:Mechanism {mechId:'M039'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'分解产物堆积加剧离子传输受阻'}]->(m);
MATCH (f:FailureMode {entityId:'F023'}), (m:Mechanism {mechId:'M002'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'交界处电流密度分布不均'}]->(m);
MATCH (f:FailureMode {entityId:'F023'}), (m:Mechanism {mechId:'M011'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'硅膨胀导致交界处应力加剧'}]->(m);
MATCH (f:FailureMode {entityId:'F023'}), (m:Mechanism {mechId:'M039'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'交界处产物堆积阻碍离子传输'}]->(m);
MATCH (f:FailureMode {entityId:'F034'}), (m:Mechanism {mechId:'M040'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'叠片顶部大电流浓度极化'}]->(m);
MATCH (f:FailureMode {entityId:'F034'}), (m:Mechanism {mechId:'M004'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'叠片顶部浸润不良'}]->(m);
MATCH (f:FailureMode {entityId:'F034'}), (m:Mechanism {mechId:'M024'}) CREATE (f)-[:SECONDARY_MECHANISM {description:'析锂后枝晶生长加剧'}]->(m);

// -------- 8. CAUSES / CONTRIBUTES / EVOLVES_TO: 机理间关系 (7条) --------
MATCH (a:Mechanism {mechId:'M001'}), (b:Mechanism {mechId:'M024'}) CREATE (a)-[:EVOLVES_TO {description:'过电位不足引发的析锂进一步演化为枝晶生长'}]->(b);
MATCH (a:Mechanism {mechId:'M002'}), (b:Mechanism {mechId:'M001'}) CREATE (a)-[:CAUSES {description:'局部电流密度集中导致局部过电位不足'}]->(b);
MATCH (a:Mechanism {mechId:'M024'}), (b:Mechanism {mechId:'M039'}) CREATE (a)-[:CONTRIBUTES {description:'枝晶生长伴随SEI破裂产生分解产物堆积'}]->(b);
MATCH (a:Mechanism {mechId:'M005'}), (b:Mechanism {mechId:'M015'}) CREATE (a)-[:CONTRIBUTES {description:'SEI持续生长消耗电解液加速电解液耗尽'}]->(b);
MATCH (a:Mechanism {mechId:'M011'}), (b:Mechanism {mechId:'M020'}) CREATE (a)-[:CONTRIBUTES {description:'体积膨胀产生的应力在边缘区域形成内应力集中'}]->(b);
MATCH (a:Mechanism {mechId:'M003'}), (b:Mechanism {mechId:'M001'}) CREATE (a)-[:CONTRIBUTES {description:'扩散受限使表面锂离子浓度降低加剧过电位不足'}]->(b);
MATCH (a:Mechanism {mechId:'M040'}), (b:Mechanism {mechId:'M001'}) CREATE (a)-[:CONTRIBUTES {description:'浓度极化使负极表面电位下降加剧过电位不足'}]->(b);


// -------- 9. INFLUENCES: 参数→机理 (45条) --------
MATCH (p:DesignParam {entityId:'P113'}), (m:Mechanism {mechId:'M001'}) CREATE (p)-[:INFLUENCES {description:'NP比不足时负极过电位降低导致析锂电位'}]->(m);
MATCH (p:DesignParam {entityId:'P114'}), (m:Mechanism {mechId:'M001'}) CREATE (p)-[:INFLUENCES {description:'充电电流过大导致负极电位快速下降'}]->(m);
MATCH (p:DesignParam {entityId:'P038'}), (m:Mechanism {mechId:'M001'}) CREATE (p)-[:INFLUENCES {description:'压实密度过高限制锂离子嵌入动力学'}]->(m);
MATCH (p:DesignParam {entityId:'P037'}), (m:Mechanism {mechId:'M001'}) CREATE (p)-[:INFLUENCES {description:'负极克容量过高时接收锂离子能力不足易析锂'}]->(m);
MATCH (p:DesignParam {entityId:'P018'}), (m:Mechanism {mechId:'M002'}) CREATE (p)-[:INFLUENCES {description:'极片宽度决定边缘电流分布均匀性'}]->(m);
MATCH (p:DesignParam {entityId:'P044'}), (m:Mechanism {mechId:'M002'}) CREATE (p)-[:INFLUENCES {description:'正极极片宽度与负极配合决定边缘对齐电流分布'}]->(m);
MATCH (p:DesignParam {entityId:'P096'}), (m:Mechanism {mechId:'M002'}) CREATE (p)-[:INFLUENCES {description:'AC_OH对齐精度影响边缘电流密度'}]->(m);
MATCH (p:DesignParam {entityId:'P097'}), (m:Mechanism {mechId:'M002'}) CREATE (p)-[:INFLUENCES {description:'SA_OH对齐精度影响边缘电流密度'}]->(m);
MATCH (p:DesignParam {entityId:'P098'}), (m:Mechanism {mechId:'M002'}) CREATE (p)-[:INFLUENCES {description:'PJ_GAP间隙影响边缘区域电流集中'}]->(m);
MATCH (p:DesignParam {entityId:'P099'}), (m:Mechanism {mechId:'M002'}) CREATE (p)-[:INFLUENCES {description:'PA_Gap间隙影响极片边缘电流分布'}]->(m);
MATCH (p:DesignParam {entityId:'P059'}), (m:Mechanism {mechId:'M002'}) CREATE (p)-[:INFLUENCES {description:'隔膜宽度余量不足时边缘离子传输路径异常'}]->(m);
MATCH (p:DesignParam {entityId:'P038'}), (m:Mechanism {mechId:'M003'}) CREATE (p)-[:INFLUENCES {description:'压实密度过高使固相扩散路径增长'}]->(m);
MATCH (p:DesignParam {entityId:'P021'}), (m:Mechanism {mechId:'M003'}) CREATE (p)-[:INFLUENCES {description:'极片厚度增大使锂离子扩散距离增加'}]->(m);
MATCH (p:DesignParam {entityId:'P122'}), (m:Mechanism {mechId:'M003'}) CREATE (p)-[:INFLUENCES {description:'隔膜孔径影响离子传输通道'}]->(m);
MATCH (p:DesignParam {entityId:'P039'}), (m:Mechanism {mechId:'M003'}) CREATE (p)-[:INFLUENCES {description:'面密度过高增加扩散距离'}]->(m);
MATCH (p:DesignParam {entityId:'P061'}), (m:Mechanism {mechId:'M003'}) CREATE (p)-[:INFLUENCES {description:'隔膜厚度增大增加离子传输阻抗'}]->(m);
MATCH (p:DesignParam {entityId:'P067'}), (m:Mechanism {mechId:'M004'}) CREATE (p)-[:INFLUENCES {description:'注液量不足导致边缘区域浸润不良'}]->(m);
MATCH (p:DesignParam {entityId:'P068'}), (m:Mechanism {mechId:'M004'}) CREATE (p)-[:INFLUENCES {description:'保液量不足导致循环后边缘干涸'}]->(m);
MATCH (p:DesignParam {entityId:'P038'}), (m:Mechanism {mechId:'M004'}) CREATE (p)-[:INFLUENCES {description:'压实密度过高使孔隙率下降电解液难渗透'}]->(m);
MATCH (p:DesignParam {entityId:'P064'}), (m:Mechanism {mechId:'M004'}) CREATE (p)-[:INFLUENCES {description:'隔膜涂层厚度影响边缘区域浸润均匀性'}]->(m);
MATCH (p:DesignParam {entityId:'P107'}), (m:Mechanism {mechId:'M004'}) CREATE (p)-[:INFLUENCES {description:'化成压力不足影响初始界面浸润均匀性'}]->(m);
MATCH (p:DesignParam {entityId:'P029'}), (m:Mechanism {mechId:'M005'}) CREATE (p)-[:INFLUENCES {description:'硅含量高导致体积变化大SEI反复破裂修复'}]->(m);
MATCH (p:DesignParam {entityId:'P033'}), (m:Mechanism {mechId:'M005'}) CREATE (p)-[:INFLUENCES {description:'下层硅含量影响SEI破裂程度'}]->(m);
MATCH (p:DesignParam {entityId:'P035'}), (m:Mechanism {mechId:'M005'}) CREATE (p)-[:INFLUENCES {description:'整体硅占比越高SEI生长消耗活性锂越多'}]->(m);

MATCH (p:DesignParam {entityId:'P114'}), (m:Mechanism {mechId:'M005'}) CREATE (p)-[:INFLUENCES {description:'大电流充电加剧SEI破裂和重建'}]->(m);
MATCH (p:DesignParam {entityId:'P038'}), (m:Mechanism {mechId:'M005'}) CREATE (p)-[:INFLUENCES {description:'压实密度过高使颗粒间应力增大加剧SEI破裂'}]->(m);
MATCH (p:DesignParam {entityId:'P029'}), (m:Mechanism {mechId:'M011'}) CREATE (p)-[:INFLUENCES {description:'硅含量增加导致体积膨胀加剧'}]->(m);
MATCH (p:DesignParam {entityId:'P033'}), (m:Mechanism {mechId:'M011'}) CREATE (p)-[:INFLUENCES {description:'下层硅含量影响整体膨胀应力'}]->(m);
MATCH (p:DesignParam {entityId:'P035'}), (m:Mechanism {mechId:'M011'}) CREATE (p)-[:INFLUENCES {description:'整体硅占比决定综合膨胀程度'}]->(m);
MATCH (p:DesignParam {entityId:'P040'}), (m:Mechanism {mechId:'M011'}) CREATE (p)-[:INFLUENCES {description:'负极延展性影响膨胀后应力释放'}]->(m);
MATCH (p:DesignParam {entityId:'P067'}), (m:Mechanism {mechId:'M015'}) CREATE (p)-[:INFLUENCES {description:'初始注液量不足加速电解液耗尽'}]->(m);
MATCH (p:DesignParam {entityId:'P068'}), (m:Mechanism {mechId:'M015'}) CREATE (p)-[:INFLUENCES {description:'保液量低导致循环后电解液更快耗尽'}]->(m);
MATCH (p:DesignParam {entityId:'P038'}), (m:Mechanism {mechId:'M015'}) CREATE (p)-[:INFLUENCES {description:'压实密度过高减少孔隙内电解液储量'}]->(m);
MATCH (p:DesignParam {entityId:'P041'}), (m:Mechanism {mechId:'M020'}) CREATE (p)-[:INFLUENCES {description:'单双面压实比不均导致应力集中'}]->(m);
MATCH (p:DesignParam {entityId:'P040'}), (m:Mechanism {mechId:'M020'}) CREATE (p)-[:INFLUENCES {description:'延展差异导致极片内应力分布不均'}]->(m);
MATCH (p:DesignParam {entityId:'P038'}), (m:Mechanism {mechId:'M020'}) CREATE (p)-[:INFLUENCES {description:'压实密度过高增加极片刚性应力'}]->(m);
MATCH (p:DesignParam {entityId:'P113'}), (m:Mechanism {mechId:'M024'}) CREATE (p)-[:INFLUENCES {description:'NP比不足时析锂量增大更易形成枝晶'}]->(m);
MATCH (p:DesignParam {entityId:'P114'}), (m:Mechanism {mechId:'M024'}) CREATE (p)-[:INFLUENCES {description:'大电流充电加剧锂沉积不均匀促进枝晶生长'}]->(m);
MATCH (p:DesignParam {entityId:'P038'}), (m:Mechanism {mechId:'M024'}) CREATE (p)-[:INFLUENCES {description:'压实密度过高使锂沉积不均匀促进枝晶形核'}]->(m);
MATCH (p:DesignParam {entityId:'P067'}), (m:Mechanism {mechId:'M039'}) CREATE (p)-[:INFLUENCES {description:'注液量不足时分解产物浓度更高更易堆积'}]->(m);
MATCH (p:DesignParam {entityId:'P068'}), (m:Mechanism {mechId:'M039'}) CREATE (p)-[:INFLUENCES {description:'保液量低导致产物无法有效稀释而堆积'}]->(m);
MATCH (p:DesignParam {entityId:'P122'}), (m:Mechanism {mechId:'M039'}) CREATE (p)-[:INFLUENCES {description:'隔膜孔径小时更易被分解产物堵塞'}]->(m);
MATCH (p:DesignParam {entityId:'P114'}), (m:Mechanism {mechId:'M040'}) CREATE (p)-[:INFLUENCES {description:'大电流充电加剧表面浓度极化'}]->(m);
MATCH (p:DesignParam {entityId:'P021'}), (m:Mechanism {mechId:'M040'}) CREATE (p)-[:INFLUENCES {description:'厚极片使体相与表面浓度差增大'}]->(m);
MATCH (p:DesignParam {entityId:'P039'}), (m:Mechanism {mechId:'M040'}) CREATE (p)-[:INFLUENCES {description:'高面密度增加浓差极化程度'}]->(m);

// -------- 10. DIRECTLY_AFFECTS: 参数→子失效 (18条) --------
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'NP比不足直接导致极片边缘析锂风险'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F014'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'NP比不足时尾部两折区域更易析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F015'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'NP比不足时胶纸边缘区域析锂风险增大'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F018'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'NP比不足时OH边缘析锂风险增大'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F019'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'NP比不足时极耳位月牙形析锂风险增大'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F023'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'NP比不足时单双面交界处析锂加剧'}]->(f);
MATCH (p:DesignParam {entityId:'P113'}), (f:FailureMode {entityId:'F034'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'NP比不足时叠片顶部边缘析锂风险增大'}]->(f);
MATCH (p:DesignParam {entityId:'P096'}), (f:FailureMode {entityId:'F018'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'AC_OH对齐偏差直接导致OH边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P097'}), (f:FailureMode {entityId:'F018'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'SA_OH对齐偏差直接导致OH边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P098'}), (f:FailureMode {entityId:'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'PJ_GAP过小直接导致极片边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P099'}), (f:FailureMode {entityId:'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'PA_Gap过小直接导致极片边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P041'}), (f:FailureMode {entityId:'F023'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'单双面压实比不均直接导致交界处析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P096'}), (f:FailureMode {entityId:'F034'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'AC_OH偏差直接导致叠片顶部边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P114'}), (f:FailureMode {entityId:'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'大电流充电直接加剧极片边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P114'}), (f:FailureMode {entityId:'F019'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'大电流充电直接导致极耳位边缘月牙形析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P114'}), (f:FailureMode {entityId:'F034'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'大电流充电直接加剧叠片顶部边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P044'}), (f:FailureMode {entityId:'F013'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'正极极片宽度与负极不匹配直接导致边缘析锂'}]->(f);
MATCH (p:DesignParam {entityId:'P044'}), (f:FailureMode {entityId:'F034'}) CREATE (p)-[:DIRECTLY_AFFECTS {description:'正极宽度偏差直接影响叠片顶部边缘对齐导致析锂'}]->(f);

// ============ 完成 ============
// 节点: 43个 (8 FailureMode含根 + 11 Mechanism + 24 DesignParam)
// 关系: 7 HAS_SUBTYPE + 7 PRIMARY_MECHANISM + 25 SECONDARY_MECHANISM
//       + 7 CAUSES/CONTRIBUTES/EVOLVES_TO + 45 INFLUENCES + 18 DIRECTLY_AFFECTS
//       = 109条
