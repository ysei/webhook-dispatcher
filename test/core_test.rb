
require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/core"

class CoreTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher
    @dispatcher = @klass.new
  end

  #
  # 初期化
  #

  def test_initialize__global_default
    @klass.open_timeout = nil
    @klass.read_timeout = nil
    @klass.user_agent   = nil

    wh = @klass.new
    assert_equal(@klass.default_open_timeout, wh.open_timeout)
    assert_equal(@klass.default_read_timeout, wh.read_timeout)
    assert_equal(@klass.default_user_agent,   wh.user_agent)
  end

  def test_initialize__class_default
    @klass.open_timeout = 1
    @klass.read_timeout = 2
    @klass.user_agent   = "3"

    wh = @klass.new
    assert_equal(1,   wh.open_timeout)
    assert_equal(2,   wh.read_timeout)
    assert_equal("3", wh.user_agent)
  end

  def test_initialize__parameter
    @klass.open_timeout = 1
    @klass.read_timeout = 2
    @klass.user_agent   = "3"

    wh = @klass.new(
      :open_timeout => 4,
      :read_timeout => 5,
      :user_agent   => "6")
    assert_equal(4,   wh.open_timeout)
    assert_equal(5,   wh.read_timeout)
    assert_equal("6", wh.user_agent)
  end

  #
  # クラスメソッド
  #

  def test_self_open_timeout
    @klass.open_timeout = 5
    assert_equal(5, @klass.open_timeout)
  end

  def test_self_read_timeout
    @klass.read_timeout = 5
    assert_equal(5, @klass.read_timeout)
  end

  def test_self_user_agent
    @klass.user_agent = "ie"
    assert_equal("ie", @klass.user_agent)
  end

  def test_self_acl
    acl = @klass::Acl.new
    @klass.acl = acl
    assert_equal(acl, @klass.acl)
  end

  def test_self_default_open_timeout
    assert_equal(10, @klass.default_open_timeout)
  end

  def test_self_default_read_timeout
    assert_equal(10, @klass.default_read_timeout)
  end

  def test_self_default_user_agent
    assert_equal(
      "webhook-dispatcher #{@klass::VERSION}",
      @klass.default_user_agent)
  end

  def test_self_default_acl
    acl = @klass.default_acl
    assert_kind_of(@klass::Acl, acl)
    assert_equal(0, acl.size)
  end

  #
  # インスタンスメソッド
  #

  def test_open_timeout
    @dispatcher.open_timeout = 10
    assert_equal(10, @dispatcher.open_timeout)
  end

  def test_read_timeout
    @dispatcher.read_timeout = 10
    assert_equal(10, @dispatcher.read_timeout)
  end

  def test_user_agent
    @dispatcher.user_agent = "firefox"
    assert_equal("firefox", @dispatcher.user_agent)
  end

  def test_acl
    acl = @klass::Acl.new
    @dispatcher.acl = acl
    assert_equal(acl, @dispatcher.acl)
  end
end
