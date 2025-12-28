# frozen_string_literal: true

module Public
  class ContentsController < BaseController
    def index
      @contents = sample_contents
    end

    def show
      @content = sample_contents.find { |c| c[:id] == params[:id].to_i }

      unless @content
        render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
      end
    end

    private

    def sample_contents
      [
        {
          id: 1,
          title: "AI 시대의 비즈니스 전략",
          description: "인공지능이 비즈니스에 미치는 영향과 대응 전략에 대해 알아봅니다.",
          category: "트렌드",
          date: "2024-12-20",
          image: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800"
        },
        {
          id: 2,
          title: "디지털 마케팅 완벽 가이드",
          description: "효과적인 디지털 마케팅 전략 수립을 위한 핵심 가이드입니다.",
          category: "마케팅",
          date: "2024-12-15",
          image: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800"
        },
        {
          id: 3,
          title: "스타트업 성장 전략",
          description: "초기 스타트업이 빠르게 성장하기 위한 핵심 전략을 소개합니다.",
          category: "비즈니스",
          date: "2024-12-10",
          image: "https://images.unsplash.com/photo-1553028826-f4804a6dba3b?w=800"
        },
        {
          id: 4,
          title: "효과적인 팀 빌딩 방법",
          description: "고성과 팀을 만들기 위한 리더십과 조직 문화 구축 방법입니다.",
          category: "HR",
          date: "2024-12-05",
          image: "https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800"
        },
        {
          id: 5,
          title: "데이터 기반 의사결정",
          description: "데이터 분석을 통한 효과적인 비즈니스 의사결정 방법을 알아봅니다.",
          category: "데이터",
          date: "2024-12-01",
          image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800"
        },
        {
          id: 6,
          title: "브랜드 전략 수립하기",
          description: "강력한 브랜드 아이덴티티를 구축하는 방법에 대해 설명합니다.",
          category: "브랜딩",
          date: "2024-11-28",
          image: "https://images.unsplash.com/photo-1493421419110-74f4e85ba126?w=800"
        }
      ]
    end
  end
end
