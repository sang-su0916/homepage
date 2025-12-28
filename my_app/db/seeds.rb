# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 관리자 시드 데이터
puts "Creating admin users..."

AdminRecord.find_or_create_by!(email: "admin@lbizpartners.com") do |admin|
  admin.password_digest = BCrypt::Password.create("admin123!")
  puts "  Created admin: admin@lbizpartners.com"
end

puts "Admin seed data completed!"

# 포트폴리오 시드 데이터
puts "\nCreating portfolio samples..."

portfolios = [
  {
    title: "글로벌 물류 시스템 구축",
    description: "국내 대기업의 글로벌 물류 네트워크 최적화 프로젝트. SCM 프로세스 개선 및 실시간 재고 관리 시스템 도입으로 물류비 30% 절감 달성.",
    client: "삼성전자",
    published: true
  },
  {
    title: "디지털 트랜스포메이션 전략 수립",
    description: "전통 제조업체의 디지털 전환 로드맵 수립. 스마트팩토리 도입, 데이터 기반 의사결정 체계 구축, 클라우드 마이그레이션 전략 제안.",
    client: "현대자동차",
    published: true
  },
  {
    title: "금융 서비스 UX/UI 혁신",
    description: "모바일 뱅킹 앱 전면 리뉴얼 프로젝트. 사용자 조사 기반 UI 개선으로 앱 사용률 45% 증가, 고객 만족도 대폭 향상.",
    client: "KB국민은행",
    published: true
  },
  {
    title: "AI 기반 고객 서비스 자동화",
    description: "챗봇 및 AI 상담 시스템 구축. 자연어 처리 기술을 활용한 24시간 고객 응대 시스템으로 상담 효율 200% 개선.",
    client: "SK텔레콤",
    published: true
  },
  {
    title: "ESG 경영 컨설팅",
    description: "ESG 경영 체계 수립 및 지속가능경영 보고서 작성 지원. 탄소중립 로드맵 수립, 사회적 가치 측정 체계 구축.",
    client: "포스코",
    published: true
  },
  {
    title: "스타트업 성장 전략 컨설팅",
    description: "시리즈 B 투자 유치를 위한 사업 전략 수립. 시장 분석, 비즈니스 모델 고도화, IR 자료 작성 지원으로 100억 투자 유치 성공.",
    client: "토스",
    published: true
  },
  {
    title: "헬스케어 플랫폼 개발",
    description: "비대면 진료 및 건강관리 통합 플랫폼 기획. 의료진-환자 연결 시스템, 건강 데이터 분석 대시보드 개발.",
    client: "삼성서울병원",
    published: true
  },
  {
    title: "리테일 옴니채널 전략",
    description: "오프라인-온라인 통합 쇼핑 경험 설계. 재고 통합 관리, 매장 픽업 서비스, 개인화 추천 시스템 구축.",
    client: "신세계백화점",
    published: true
  },
  {
    title: "HR 디지털화 프로젝트",
    description: "인사관리 시스템 현대화 및 직원 경험 플랫폼 구축. 성과관리, 교육훈련, 복리후생 통합 시스템 개발.",
    client: "LG전자",
    published: true
  },
  {
    title: "데이터 분석 플랫폼 구축",
    description: "빅데이터 기반 비즈니스 인텔리전스 플랫폼 개발. 실시간 대시보드, 예측 분석, 자동 리포팅 시스템 구현.",
    client: "네이버",
    published: true
  }
]

portfolios.each do |portfolio_data|
  PortfolioRecord.find_or_create_by!(title: portfolio_data[:title]) do |portfolio|
    portfolio.description = portfolio_data[:description]
    portfolio.client = portfolio_data[:client]
    portfolio.published = portfolio_data[:published]
    puts "  Created portfolio: #{portfolio_data[:title]}"
  end
end

puts "Portfolio seed data completed! (#{portfolios.size} items)"

# 블로그 시드 데이터
puts "\nCreating blog post samples..."

blog_posts = [
  {
    title: "2025년 디지털 트랜스포메이션 트렌드 전망",
    excerpt: "AI, 클라우드, 자동화가 이끄는 2025년 기업 디지털 전환의 핵심 트렌드를 분석합니다.",
    content: "## 들어가며\n\n2025년은 디지털 트랜스포메이션의 새로운 전환점이 될 것으로 예상됩니다. 특히 생성형 AI의 급속한 발전과 함께 기업들의 디지털 전략도 크게 변화하고 있습니다.\n\n## 주요 트렌드\n\n### 1. AI 네이티브 비즈니스\n단순한 AI 도입을 넘어, 처음부터 AI를 중심으로 설계된 비즈니스 모델이 등장하고 있습니다.\n\n### 2. 하이퍼오토메이션\nRPA, AI, 머신러닝을 결합한 지능형 자동화가 기업 운영의 핵심이 됩니다.\n\n### 3. 데이터 메시 아키텍처\n분산된 데이터 관리와 도메인 중심의 데이터 거버넌스가 확산됩니다.\n\n## 결론\n\n기업들은 이러한 트렌드에 선제적으로 대응하여 경쟁력을 확보해야 합니다.",
    author: "김영수 파트너",
    category: "디지털 전환",
    published: true,
    published_at: 3.days.ago
  },
  {
    title: "ESG 경영, 선택이 아닌 필수가 된 이유",
    excerpt: "글로벌 기업들의 ESG 경영 사례와 국내 기업이 나아가야 할 방향을 제시합니다.",
    content: "## ESG란 무엇인가?\n\nESG는 Environment(환경), Social(사회), Governance(지배구조)의 약자로, 기업의 지속가능성을 평가하는 핵심 지표입니다.\n\n## 왜 ESG가 중요한가?\n\n### 투자자 관점\n글로벌 투자 기관들이 ESG 평가를 투자 의사결정의 핵심 기준으로 삼고 있습니다.\n\n### 소비자 관점\nMZ세대를 중심으로 가치 소비가 확산되며, 기업의 사회적 책임에 대한 요구가 높아지고 있습니다.\n\n### 규제 관점\nEU의 CSRD, 국내 지속가능경영보고서 의무화 등 규제가 강화되고 있습니다.\n\n## L-BIZ의 ESG 컨설팅\n\n저희는 기업 맞춤형 ESG 전략 수립부터 실행까지 종합적인 컨설팅을 제공합니다.",
    author: "이수진 상무",
    category: "ESG",
    published: true,
    published_at: 1.week.ago
  },
  {
    title: "스타트업 투자 유치 성공 전략 A to Z",
    excerpt: "시리즈 A부터 IPO까지, 단계별 투자 유치 전략과 실전 노하우를 공개합니다.",
    content: "## 투자 유치의 기본 원칙\n\n성공적인 투자 유치를 위해서는 명확한 비즈니스 모델과 성장 가능성을 입증해야 합니다.\n\n## 단계별 전략\n\n### 시드 라운드\n- 팀 역량과 비전 어필\n- MVP(최소 기능 제품) 준비\n- 초기 트랙션 확보\n\n### 시리즈 A\n- PMF(제품-시장 적합성) 증명\n- 매출 성장률 제시\n- 확장 가능한 비즈니스 모델\n\n### 시리즈 B 이상\n- 시장 지배력 강화 전략\n- 수익성 개선 로드맵\n- Exit 전략 제시\n\n## 투자 유치 체크리스트\n\n1. 재무제표 정비\n2. 사업계획서 작성\n3. 피치덱 준비\n4. 투자자 네트워킹",
    author: "박준혁 파트너",
    category: "스타트업",
    published: true,
    published_at: 2.weeks.ago
  },
  {
    title: "데이터 기반 의사결정의 실제 적용 사례",
    excerpt: "데이터 분석을 통해 비즈니스 성과를 개선한 국내외 기업 사례를 살펴봅니다.",
    content: "## 데이터 기반 의사결정이란?\n\n직관이나 경험이 아닌, 데이터 분석 결과를 바탕으로 비즈니스 의사결정을 내리는 방식입니다.\n\n## 성공 사례\n\n### 사례 1: 유통기업 A사\n- 고객 구매 데이터 분석으로 개인화 마케팅 실현\n- 마케팅 ROI 150% 향상\n\n### 사례 2: 제조기업 B사\n- 설비 데이터 기반 예측 정비 도입\n- 다운타임 40% 감소\n\n### 사례 3: 금융기업 C사\n- AI 기반 신용평가 모델 구축\n- 대출 부실률 25% 감소\n\n## 도입 시 고려사항\n\n데이터 품질, 분석 역량, 조직 문화 등 다양한 요소를 종합적으로 고려해야 합니다.",
    author: "최민정 컨설턴트",
    category: "데이터 분석",
    published: true,
    published_at: 3.weeks.ago
  },
  {
    title: "클라우드 마이그레이션 성공을 위한 5가지 핵심 전략",
    excerpt: "온프레미스에서 클라우드로의 성공적인 전환을 위한 전략과 주의점을 알아봅니다.",
    content: "## 클라우드 마이그레이션의 필요성\n\n비용 효율성, 확장성, 민첩성 확보를 위해 클라우드 전환은 필수가 되었습니다.\n\n## 5가지 핵심 전략\n\n### 1. 철저한 현황 분석\n현재 IT 인프라와 애플리케이션을 정확히 파악합니다.\n\n### 2. 적합한 마이그레이션 전략 선택\n- Rehost (Lift & Shift)\n- Replatform\n- Refactor\n- Rebuild\n- Replace\n\n### 3. 보안 및 컴플라이언스 고려\n데이터 보안과 규제 준수 방안을 사전에 마련합니다.\n\n### 4. 단계적 마이그레이션\n중요도와 복잡도에 따라 우선순위를 정해 단계적으로 진행합니다.\n\n### 5. 지속적인 최적화\n마이그레이션 후에도 비용과 성능을 지속적으로 모니터링합니다.",
    author: "정대현 팀장",
    category: "클라우드",
    published: true,
    published_at: 1.month.ago
  },
  {
    title: "조직 문화 혁신, 어떻게 시작할 것인가",
    excerpt: "성공적인 조직 문화 변화를 이끈 기업들의 사례와 실행 방법론을 소개합니다.",
    content: "## 왜 조직 문화 혁신인가?\n\n급변하는 비즈니스 환경에서 유연하고 혁신적인 조직 문화는 기업 생존의 핵심입니다.\n\n## 조직 문화 혁신의 4단계\n\n### 1단계: 현재 문화 진단\n- 직원 설문조사\n- 인터뷰 및 FGI\n- 문화 지표 분석\n\n### 2단계: 목표 문화 정의\n- 비전 및 미션 재정립\n- 핵심 가치 도출\n- 행동 강령 수립\n\n### 3단계: 변화 실행\n- 리더십 코칭\n- 커뮤니케이션 강화\n- 제도 및 프로세스 개선\n\n### 4단계: 정착 및 강화\n- 성과 측정\n- 피드백 수렴\n- 지속적 개선\n\n## 성공의 핵심\n\n경영진의 강력한 의지와 일관된 메시지가 가장 중요합니다.",
    author: "한지영 상무",
    category: "조직 문화",
    published: true,
    published_at: 5.weeks.ago
  },
  {
    title: "고객 경험(CX) 혁신으로 매출 30% 성장한 비결",
    excerpt: "고객 중심 사고를 기반으로 CX를 혁신하고 비즈니스 성과를 창출한 방법을 공유합니다.",
    content: "## 고객 경험이란?\n\n고객이 브랜드와 상호작용하는 모든 접점에서의 총체적인 경험을 의미합니다.\n\n## CX 혁신 프레임워크\n\n### 고객 여정 매핑\n고객이 제품/서비스를 인지하고 구매하고 사용하는 전 과정을 시각화합니다.\n\n### 페인 포인트 발견\n고객 여정에서 불편함이나 불만이 발생하는 지점을 파악합니다.\n\n### 개선 솔루션 설계\n디자인 씽킹 방법론을 활용해 창의적인 해결책을 도출합니다.\n\n### 빠른 실험과 검증\nMVP를 통해 빠르게 테스트하고 피드백을 반영합니다.\n\n## 실제 성과\n\n- 고객 만족도(NPS) 40점 상승\n- 재구매율 25% 증가\n- 매출 30% 성장",
    author: "오승민 파트너",
    category: "고객 경험",
    published: true,
    published_at: 6.weeks.ago
  },
  {
    title: "AI 시대, 인재 전략은 어떻게 바뀌어야 하는가",
    excerpt: "AI가 변화시키는 업무 환경에서 기업이 갖춰야 할 새로운 인재 전략을 제안합니다.",
    content: "## AI가 가져온 변화\n\nAI 기술의 발전으로 많은 업무가 자동화되고, 필요한 인재상도 변화하고 있습니다.\n\n## 새로운 시대의 핵심 역량\n\n### 기술적 역량\n- 데이터 리터러시\n- AI 도구 활용 능력\n- 디지털 협업 역량\n\n### 인간 고유의 역량\n- 창의적 문제해결\n- 비판적 사고\n- 감성 지능\n- 복잡한 의사소통\n\n## 인재 전략의 변화\n\n### 채용\n역량 기반 채용으로 전환, 다양성 확보\n\n### 교육\n지속적 학습 문화 구축, 리스킬링/업스킬링 프로그램\n\n### 평가\n성과 중심 평가에서 성장 중심 평가로\n\n### 조직 구조\n유연한 팀 구성, 프로젝트 기반 협업",
    author: "김영수 파트너",
    category: "HR",
    published: true,
    published_at: 2.months.ago
  }
]

blog_posts.each do |post_data|
  BlogPostRecord.find_or_create_by!(title: post_data[:title]) do |post|
    post.excerpt = post_data[:excerpt]
    post.content = post_data[:content]
    post.author = post_data[:author]
    post.category = post_data[:category]
    post.published = post_data[:published]
    post.published_at = post_data[:published_at]
    puts "  Created blog post: #{post_data[:title]}"
  end
end

puts "Blog post seed data completed! (#{blog_posts.size} items)"
