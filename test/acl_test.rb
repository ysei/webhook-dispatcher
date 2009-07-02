
require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/core"
require "webhook-dispatcher/acl"

class AclTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl
    @acl   = @klass.new
  end

  def test_intialize
    acl = @klass.new
    assert_equal(0, acl.size)
  end

  #
  # クラスメソッド
  #

  def test_self_with__none
    acl = @klass.with { }
    assert_equal(0, acl.size)
  end

  def test_self_with__allow_and_deny
    acl = @klass.with {
      allow :all
      deny  :all
    }
    assert_equal(2, acl.size)
  end

  def test_self_with__without_block
    assert_raise(ArgumentError) {
      @klass.with
    }
  end

  def test_self_allow_all
    assert_equal(
      @klass.with { allow :all },
      @klass.allow_all)
  end

  def test_self_deny_all
    assert_equal(
      @klass.with { deny :all },
      @klass.deny_all)
  end

  #
  # インスタンスメソッド
  #

  def test_equal__empty
    a, b = @klass.new, @klass.new
    assert_equal(true, (a == b))
  end

  def test_equal__same_size_but_not_equal
    a, b = @klass.new, @klass.new
    a.add_allow(:addr => "127.0.0.0/8")
    b.add_deny(:addr => "127.0.0.0/8")
    assert_equal(false, (a == b))
  end

  def test_equal__same
    a, b = @klass.new, @klass.new
    a.add_allow(:addr => "127.0.0.0/8")
    b.add_allow(:addr => "127.0.0.0/8")
    assert_equal(true, (a == b))
  end

  def test_equal__other_class
    assert_equal(false, (@klass.new == nil))
  end

  def test_add_allow
    assert_equal(0, @acl.size)
    @acl.add_allow(:addr => "0.0.0.0/0")
    assert_equal(1, @acl.size)
    @acl.add_allow(:addr => "0.0.0.0/0")
    assert_equal(2, @acl.size)
  end

  def test_add_deny
    assert_equal(0, @acl.size)
    @acl.add_deny(:addr => "0.0.0.0/0")
    assert_equal(1, @acl.size)
    @acl.add_deny(:addr => "0.0.0.0/0")
    assert_equal(2, @acl.size)
  end

  def test_with__none
    @acl.with { }
    assert_equal(0, @acl.size)
  end

  def test_with__allow
    @acl.with { allow :all }
    assert_equal(1, @acl.size)
  end

  def test_with__deny
    @acl.with { deny :all }
    assert_equal(1, @acl.size)
  end

  def test_with__without_block
    assert_raise(ArgumentError) {
      @acl.with
    }
  end

  def test_allow?
    assert_equal(true, @acl.allow?("127.0.0.1"))
    @acl.add_deny(:addr => "127.0.0.0/8")
    assert_equal(false, @acl.allow?("127.0.0.1"))
    @acl.add_allow(:addr => "127.0.0.0/8")
    assert_equal(true, @acl.allow?("127.0.0.1"))
  end

  def test_deny?
    assert_equal(false, @acl.deny?("127.0.0.1"))
    @acl.add_deny(:addr => "127.0.0.0/8")
    assert_equal(true, @acl.deny?("127.0.0.1"))
    @acl.add_allow(:addr => "127.0.0.0/8")
    assert_equal(false, @acl.deny?("127.0.0.1"))
  end

  def test_complex1
    @acl.with {
      deny  :all
      allow :addr => "127.0.0.0/8"
    }

    assert_equal(false, @acl.allow?("126.255.255.255"))
    assert_equal(true,  @acl.allow?("127.0.0.0"))
    assert_equal(true,  @acl.allow?("127.255.255.255"))
    assert_equal(false, @acl.allow?("128.0.0.0"))
  end

  def test_complex2
    @acl.with {
      deny  :all
      allow :addr => "192.168.1.0/24"
      allow :addr => "192.168.3.0/24"
      deny  :addr => "192.168.1.127"
    }

    assert_equal(false, @acl.allow?("192.168.0.0"))
    assert_equal(true,  @acl.allow?("192.168.1.0"))
    assert_equal(false, @acl.allow?("192.168.1.127"))
    assert_equal(true,  @acl.allow?("192.168.1.255"))
    assert_equal(false, @acl.allow?("192.168.2.0"))
    assert_equal(true,  @acl.allow?("192.168.3.0"))
    assert_equal(true,  @acl.allow?("192.168.3.255"))
  end
end
