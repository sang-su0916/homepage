# frozen_string_literal: true

# 유스케이스의 기반 클래스
# 유스케이스는 단일 비즈니스 작업을 캡슐화합니다.
class BaseUseCase
  # Result 객체: 유스케이스 실행 결과를 표현
  class Result
    attr_reader :data, :errors

    def initialize(success:, data: nil, errors: {})
      @success = success
      @data = data
      @errors = errors
      freeze
    end

    def success?
      @success
    end

    def failure?
      !success?
    end

    # 성공 결과 생성
    def self.success(data = nil)
      new(success: true, data: data)
    end

    # 실패 결과 생성 (errors는 해시)
    def self.failure(errors)
      new(success: false, errors: errors)
    end
  end

  # 유스케이스 실행
  def call(...)
    raise NotImplementedError, "#{self.class}#call 메서드를 구현해야 합니다."
  end

  private

  # 성공 결과 반환 헬퍼
  def success(data = nil)
    Result.success(data)
  end

  # 실패 결과 반환 헬퍼 (errors는 해시)
  def failure(errors)
    Result.failure(errors)
  end

  # 값이 비어있는지 확인
  def blank?(value)
    value.nil? || value.to_s.strip.empty?
  end
end
