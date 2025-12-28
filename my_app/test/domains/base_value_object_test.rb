# frozen_string_literal: true

require "test_helper"

class BaseValueObjectTest < ActiveSupport::TestCase
  # 테스트용 값 객체 클래스
  class EmailAddress < BaseValueObject
    attribute :value, :string

    validates :value, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    def to_s
      value
    end
  end

  class Money < BaseValueObject
    attribute :amount, :decimal
    attribute :currency, :string, default: "KRW"

    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :currency, presence: true
  end

  test "값 객체는 속성을 정의할 수 있다" do
    email = EmailAddress.new(value: "test@example.com")

    assert_equal "test@example.com", email.value
  end

  test "같은 값을 가진 값 객체는 동등하다" do
    email1 = EmailAddress.new(value: "test@example.com")
    email2 = EmailAddress.new(value: "test@example.com")

    assert_equal email1, email2
  end

  test "다른 값을 가진 값 객체는 동등하지 않다" do
    email1 = EmailAddress.new(value: "test1@example.com")
    email2 = EmailAddress.new(value: "test2@example.com")

    assert_not_equal email1, email2
  end

  test "값 객체는 불변이다 (frozen)" do
    email = EmailAddress.new(value: "test@example.com")

    assert email.frozen?
    assert_raises(FrozenError) { email.instance_variable_set(:@value, "new@example.com") }
  end

  test "값 객체는 유효성 검증을 수행할 수 있다" do
    valid_email = EmailAddress.new(value: "test@example.com")
    invalid_email = EmailAddress.new(value: "invalid-email")

    assert valid_email.valid?
    assert_not invalid_email.valid?
  end

  test "값 객체는 해시 키로 사용될 수 있다" do
    email1 = EmailAddress.new(value: "test@example.com")
    email2 = EmailAddress.new(value: "test@example.com")

    hash = { email1 => "user1" }
    hash[email2] = "user2"

    assert_equal 1, hash.size
    assert_equal "user2", hash[email1]
  end

  test "복합 값 객체도 동등성 비교가 가능하다" do
    money1 = Money.new(amount: 10000, currency: "KRW")
    money2 = Money.new(amount: 10000, currency: "KRW")
    money3 = Money.new(amount: 10000, currency: "USD")

    assert_equal money1, money2
    assert_not_equal money1, money3
  end

  test "값 객체는 기본값을 가질 수 있다" do
    money = Money.new(amount: 5000)

    assert_equal "KRW", money.currency
  end
end
