# frozen_string_literal: true

# 값 객체의 기반 클래스
# 값 객체는 불변(immutable)이며, 값 기반으로 동등성을 비교합니다.
class BaseValueObject
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  def initialize(**kwargs)
    super
    freeze
  end

  # 값 기반 동등성 비교
  def ==(other)
    return false unless other.is_a?(self.class)
    comparable_attributes == other.comparable_attributes
  end

  alias eql? ==

  # 해시 키로 사용될 수 있도록 hash 메서드 정의
  def hash
    comparable_attributes.hash
  end

  # 비교에 사용할 속성들
  def comparable_attributes
    attributes.except("id").compact
  end

  # 속성을 해시로 반환
  def attributes
    super.compact
  end

  # 새 값으로 복사본 생성 (불변성 유지)
  def with(**new_attributes)
    self.class.new(**attributes.symbolize_keys.merge(new_attributes))
  end
end
