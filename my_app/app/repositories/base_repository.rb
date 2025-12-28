# frozen_string_literal: true

# 레포지토리의 기반 클래스
# 레포지토리는 도메인 엔티티의 영속성을 담당합니다.
class BaseRepository
  class << self
    # 직접 인스턴스화 방지 (서브클래스에서만 인스턴스화)
    def new
      if self == BaseRepository
        raise NotImplementedError, "BaseRepository는 직접 인스턴스화할 수 없습니다. 서브클래스를 사용하세요."
      end
      super
    end
  end

  # 모든 엔티티 조회
  def find_all
    raise NotImplementedError, "#{self.class}#find_all 메서드를 구현해야 합니다."
  end

  # ID로 엔티티 조회
  def find_by_id(id)
    raise NotImplementedError, "#{self.class}#find_by_id 메서드를 구현해야 합니다."
  end

  # 엔티티 저장 (생성 또는 업데이트)
  def save(entity)
    raise NotImplementedError, "#{self.class}#save 메서드를 구현해야 합니다."
  end

  # 엔티티 삭제
  def delete(id)
    raise NotImplementedError, "#{self.class}#delete 메서드를 구현해야 합니다."
  end
end
