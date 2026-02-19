# frozen_string_literal: true

require 'test_helper'

class AccountResourceTest < Minitest::Test
  include ApiTestHelper

  def test_me
    stub_api(:get, 'me', body: {
               token: { name: 'My Token', permission: 'full_access', expires_at: nil },
               account: { id: 'acc_1', name: 'Test Account', plan: 'pro' }
             })

    result = new_client.account.me
    assert_instance_of Administrate::Models::MeResponse, result
    assert_equal 'My Token', result.token.name
    assert_equal 'acc_1', result.account.id
  end

  def test_get
    stub_api(:get, 'account', body: {
               data: { id: 'acc_1', name: 'Test', slug: 'test', plan: 'pro', plan_name: 'Pro',
                       on_trial: false, created_at: '2024-01-01', updated_at: '2024-01-01' }
             })

    result = new_client.account.get
    assert_instance_of Administrate::Models::Account, result
    assert_equal 'acc_1', result.id
    assert_equal 'Test', result.name
  end

  def test_update
    stub_api(:patch, 'account', body: {
               data: { id: 'acc_1', name: 'Updated', slug: 'test', plan: 'pro', plan_name: 'Pro',
                       on_trial: false, created_at: '2024-01-01', updated_at: '2024-01-02' }
             })

    result = new_client.account.update(name: 'Updated')
    assert_instance_of Administrate::Models::Account, result
    assert_equal 'Updated', result.name
  end
end
