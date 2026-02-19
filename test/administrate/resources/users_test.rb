# frozen_string_literal: true

require 'test_helper'

class UsersResourceTest < Minitest::Test
  include ApiTestHelper

  def test_list
    stub_api(:get, 'users', body: paginated_response([
                                                       { id: 'u1', email: 'a@example.com', role: 'admin', joined_at: '2024-01-01' }
                                                     ]))

    items = new_client.users.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::User, items[0]
    assert_equal 'u1', items[0].id
  end

  def test_get
    stub_api(:get, 'users/u1', body: {
               data: { id: 'u1', email: 'a@example.com', role: 'admin', joined_at: '2024-01-01' }
             })

    user = new_client.users.get('u1')
    assert_instance_of Administrate::Models::User, user
    assert_equal 'u1', user.id
  end

  def test_invite
    stub_api(:post, 'users/invite', body: {
               data: { id: 1, email: 'new@example.com', role: 'member', expires_at: '2024-02-01', created_at: '2024-01-01' }
             })

    invitation = new_client.users.invite(email: 'new@example.com', role: 'member')
    assert_instance_of Administrate::Models::Invitation, invitation
    assert_equal 'new@example.com', invitation.email
  end

  def test_update
    stub_api(:patch, 'users/u1', body: {
               data: { id: 'u1', email: 'a@example.com', role: 'owner', joined_at: '2024-01-01' }
             })

    user = new_client.users.update('u1', role: 'owner')
    assert_instance_of Administrate::Models::User, user
    assert_equal 'owner', user.role
  end

  def test_delete
    stub_request(:delete, "#{API_BASE}/users/u1")
      .to_return(status: 204, body: '')
    assert_nil new_client.users.delete('u1')
  end
end
