# frozen_string_literal: true

# 도메인 엔티티의 기반 클래스
# 엔티티는 고유 식별자(id)를 가지며, id 기반으로 동등성을 비교합니다.
class BaseEntity
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :id, :integer

  # id 기반 동등성 비교
  def ==(other)
    return false unless other.is_a?(self.class)
    id.present? && id == other.id
  end

  alias eql? ==

  # 해시 키로 사용될 수 있도록 hash 메서드 정의
  def hash
    id.hash
  end

  # 속성을 해시로 반환
  def attributes
    parent_attrs = begin
      super
    rescue NoMethodError
      {}
    end
    parent_attrs.is_a?(Hash) ? parent_attrs.compact : {}
  end

  # 새 속성으로 복사본 생성
  def with(**new_attributes)
    self.class.new(**attributes.symbolize_keys.merge(new_attributes))
  end
end
