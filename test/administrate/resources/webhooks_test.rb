# frozen_string_literal: true

require 'test_helper'

class WebhooksResourceTest < Minitest::Test
  include ApiTestHelper

  def test_list
    stub_api(:get, 'webhooks', body: paginated_response([
                                                          { id: 'wh1', url: 'https://example.com/hook', events: ['execution.completed'],
                                                            enabled: true, consecutive_failures: 0, created_at: '2024-01-01', updated_at: '2024-01-01' }
                                                        ]))

    items = new_client.webhooks.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::Webhook, items[0]
  end

  def test_get
    stub_api(:get, 'webhooks/wh1', body: {
               data: { id: 'wh1', url: 'https://example.com/hook', events: ['execution.completed'],
                       enabled: true, consecutive_failures: 0, created_at: '2024-01-01', updated_at: '2024-01-01' }
             })

    webhook = new_client.webhooks.get('wh1')
    assert_equal 'wh1', webhook.id
  end

  def test_create
    stub_api(:post, 'webhooks', body: {
               data: { id: 'wh1', url: 'https://example.com/hook', events: ['execution.completed'],
                       enabled: true, consecutive_failures: 0, created_at: '2024-01-01', updated_at: '2024-01-01' }
             })

    webhook = new_client.webhooks.create(url: 'https://example.com/hook', events: ['execution.completed'])
    assert_instance_of Administrate::Models::Webhook, webhook
  end

  def test_update
    stub_api(:patch, 'webhooks/wh1', body: {
               data: { id: 'wh1', url: 'https://example.com/new', events: ['execution.completed'],
                       enabled: true, consecutive_failures: 0, created_at: '2024-01-01', updated_at: '2024-01-02' }
             })

    webhook = new_client.webhooks.update('wh1', url: 'https://example.com/new')
    assert_equal 'https://example.com/new', webhook.url
  end

  def test_delete
    stub_request(:delete, "#{API_BASE}/webhooks/wh1")
      .to_return(status: 204, body: '')
    assert_nil new_client.webhooks.delete('wh1')
  end

  def test_regenerate_secret
    stub_api(:post, 'webhooks/wh1/regenerate_secret', body: {
               data: { id: 'wh1', url: 'https://example.com/hook', events: ['execution.completed'],
                       enabled: true, consecutive_failures: 0, secret: 'new_secret',
                       created_at: '2024-01-01', updated_at: '2024-01-01' }
             })

    webhook = new_client.webhooks.regenerate_secret('wh1')
    assert_equal 'new_secret', webhook.secret
  end
end
