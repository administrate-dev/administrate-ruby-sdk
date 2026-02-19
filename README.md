# Administrate Ruby SDK

The official Ruby SDK for the [Administrate.dev](https://administrate.dev) REST API.

[Administrate.dev](https://administrate.dev) is AI Agency Management software. It is a monitoring and management platform for AI agencies running n8n and AI automation workflows across multiple clients. It provides a single dashboard to track every workflow, every client, every failure, and all LLM costs, so you can catch problems before clients do and prove the value of your automations.

**Key platform features:**

- **Multi-instance monitoring** -- See all n8n instances across every client in one place
- **Error tracking** -- Real-time failure detection with automatic error categorization
- **LLM cost tracking** -- Connect OpenAI, Anthropic, Azure, and OpenRouter accounts to attribute costs to specific clients
- **Workflow insights** -- Execution counts, success rates, and time-saved ROI reporting
- **Sync health** -- Know instantly when a data sync fails
- **Webhooks & API** -- Full programmatic access for custom integrations

## Installation

Add to your Gemfile:

```ruby
gem 'administrate-sdk'
```

Then run:

```bash
bundle install
```

Or install directly:

```bash
gem install administrate-sdk
```

Requires Ruby 3.1+.

## Quick start

```ruby
require 'administrate-sdk'

client = Administrate.new(api_key: 'sk_live_...')

# Get account info
account = client.account.get
puts "#{account.name} (#{account.plan})"

# List all clients with auto-pagination
client.clients.list.each do |c|
  puts "#{c.name} (#{c.code})"
end

# Check for failed executions across all instances
client.executions.list(errors_only: true).each do |execution|
  puts "#{execution.workflow_name}: #{execution.error_category}"
end

# Get LLM cost summary
costs = client.llm_costs.summary
puts "Total: $#{'%.2f' % (costs.data.summary.total_cost_cents / 100.0)}"
```

## Configuration

```ruby
require 'administrate-sdk'

client = Administrate.new(
  api_key: 'sk_live_...',           # Required. Must start with "sk_live_"
  base_url: 'https://...',          # Default: "https://administrate.dev"
  timeout: 30,                      # Request timeout in seconds. Default: 30
  max_retries: 3                    # Retry attempts for failed requests. Default: 3
)
```

The SDK uses [Faraday](https://lostisland.github.io/faraday/) under the hood. Retry and backoff are handled automatically via the `faraday-retry` middleware.

## API reference

All API keys are created in **Settings > Developers** within Administrate.dev. Tokens have three permission levels: `read`, `write`, and `full`.

### Account

```ruby
# Get current token info and account summary
me = client.account.me
puts "#{me.token.name} (#{me.token.permission})"
puts "#{me.account.name} (#{me.account.plan})"

# Get full account details
account = client.account.get

# Update account settings
account = client.account.update(
  name: 'My Agency',
  billing_email: 'billing@example.com',
  timezone: 'Australia/Brisbane'
)
```

### Clients

Clients represent the companies you manage automations for.

```ruby
# List all clients (auto-paginates)
client.clients.list.each do |c|
  puts "#{c.name} (#{c.code})"
end

# Get a client (includes 7-day metrics)
c = client.clients.get('com_abc123')
puts "#{c.metrics.success_rate}% success, #{c.metrics.time_saved_minutes} min saved"

# Create a client
c = client.clients.create(
  name: 'Acme Corp',
  code: 'acme',
  contact_email: 'ops@acme.com',
  timezone: 'America/New_York'
)

# Update a client
c = client.clients.update('com_abc123', notes: 'Enterprise tier')

# Delete a client (requires full permission)
client.clients.delete('com_abc123')
```

### Instances

Instances are n8n deployments connected to Administrate.

```ruby
# List all instances
client.instances.list.each do |inst|
  puts "#{inst.name} (#{inst.sync_status})"
end

# Filter by client or sync status
client.instances.list(client_id: 'com_abc123', sync_status: 'error').each do |inst|
  puts "#{inst.name}: #{inst.last_sync_error}"
end

# Get an instance (includes 7-day metrics)
inst = client.instances.get('n8n_abc123')
puts "#{inst.metrics.executions_count} executions, #{inst.metrics.success_rate}% success"

# Connect a new n8n instance
inst = client.instances.create(
  client_id: 'com_abc123',
  name: 'Production n8n',
  base_url: 'https://n8n.acme.com',
  api_key: 'n8n_api_key_here'
)

# Trigger a sync
client.instances.sync('n8n_abc123', sync_type: 'all')

# Sync all instances at once
client.instances.sync_all(sync_type: 'workflows')

# Update an instance
inst = client.instances.update('n8n_abc123', name: 'Staging n8n')

# Delete an instance
client.instances.delete('n8n_abc123')
```

### Workflows

```ruby
# List workflows with filters
client.workflows.list(client_id: 'com_abc123', active: true).each do |wf|
  puts "#{wf.name} (active: #{wf.is_active})"
end

# Search by name
client.workflows.list(search: 'onboarding').each do |wf|
  puts wf.name
end

# Get a workflow (includes 7-day metrics)
wf = client.workflows.get('wfl_abc123')
puts "#{wf.metrics.success_rate}% success, #{wf.metrics.time_saved_minutes} min saved"

# Set time-saved estimates (for ROI reporting)
wf = client.workflows.update(
  'wfl_abc123',
  minutes_saved_per_success: 15,
  minutes_saved_per_failure: 5
)
```

### Executions

Executions are read-only records of workflow runs synced from n8n.

```ruby
# List executions with filters
client.executions.list(
  client_id: 'com_abc123',
  status: 'failed',
  start_date: '2025-01-01',
  end_date: '2025-01-31'
).each do |ex|
  puts "#{ex.workflow_name} - #{ex.status} (#{ex.duration_ms}ms)"
end

# Get only errors
client.executions.list(errors_only: true).each do |ex|
  puts "#{ex.error_category}: #{ex.workflow_name}"
end

# Get execution details (includes error message and payload)
ex = client.executions.get('exe_abc123')
puts ex.error_message
puts ex.error_payload
```

### Sync runs

```ruby
# List sync run history
client.sync_runs.list(instance_id: 'n8n_abc123', status: 'failed').each do |run|
  puts "#{run.sync_type} - #{run.status} (#{run.duration_seconds}s)"
end

# Get a specific sync run
run = client.sync_runs.get('syn_abc123')

# Get sync health across all instances
client.sync_runs.health.each do |entry|
  puts "#{entry.instance_name} (#{entry.sync_status})"
  puts "  Workflows last synced: #{entry.workflows.last_synced_at}"
  puts "  Executions last synced: #{entry.executions.last_synced_at}"
end
```

### Users

```ruby
# List team members
client.users.list.each do |user|
  puts "#{user.name} <#{user.email}> (#{user.role})"
end

# Get a user
user = client.users.get('usr_abc123')

# Invite a new team member
invitation = client.users.invite(email: 'new@example.com', role: 'member')
puts invitation.expires_at

# Change a user's role
user = client.users.update('usr_abc123', role: 'admin')

# Remove a user
client.users.delete('usr_abc123')
```

### Webhooks

```ruby
# List webhooks
client.webhooks.list.each do |wh|
  puts "#{wh.url} - #{wh.events.join(', ')} (enabled: #{wh.enabled})"
end

# Create a webhook
wh = client.webhooks.create(
  url: 'https://example.com/hook',
  events: ['execution.failed', 'sync.failed'],
  description: 'Slack failure alerts'
)
puts wh.secret  # Save this -- used to verify webhook signatures

# Update a webhook
wh = client.webhooks.update('whk_abc123', enabled: false)

# Regenerate the signing secret (old secret becomes invalid immediately)
wh = client.webhooks.regenerate_secret('whk_abc123')
puts wh.secret

# Delete a webhook
client.webhooks.delete('whk_abc123')
```

### API tokens

```ruby
# List all tokens
client.api_tokens.list.each do |token|
  puts "#{token.name} (#{token.permission}) - #{token.token_hint}"
end

# Create a token (the plain token is only returned once)
token = client.api_tokens.create(
  name: 'CI/CD Pipeline',
  permission: 'read',
  ip_allowlist: ['10.0.0.0/8'],
  expires_in: '90_days'
)
puts token.token  # sk_live_... -- save this immediately

# Update a token
token = client.api_tokens.update('tok_abc123', name: 'Updated Name')

# Revoke a token
client.api_tokens.delete('tok_abc123')
```

### LLM providers

Connect your AI provider accounts to track costs.

```ruby
# List providers
client.llm_providers.list.each do |provider|
  puts "#{provider.name} (#{provider.provider_type}) - #{provider.sync_status}"
end

# Get a provider (includes 7-day metrics)
provider = client.llm_providers.get('llm_abc123')
puts "#{provider.metrics.total_cost_cents}c, #{provider.metrics.total_tokens} tokens"

# Connect a new provider
provider = client.llm_providers.create(
  name: 'OpenAI Production',
  provider_type: 'openai',  # openai, anthropic, openrouter, or azure
  api_key: 'sk-...',
  organization_id: 'org-...'
)

# Trigger a cost sync
client.llm_providers.sync('llm_abc123')

# Update a provider
provider = client.llm_providers.update('llm_abc123', name: 'OpenAI Staging')

# Delete a provider
client.llm_providers.delete('llm_abc123')
```

### LLM projects

Projects are discovered automatically when syncing a provider. Assign them to clients to attribute costs.

```ruby
# List projects for a provider
client.llm_projects.list('llm_abc123').each do |project|
  puts "#{project.name}: #{project.total_cost_cents}c (#{project.client_name})"
end

# Assign a project to a client
project = client.llm_projects.update(
  'llm_abc123', 'proj_456', client_id: 'com_abc123'
)
```

### LLM costs

```ruby
# Get cost summary (defaults to last 7 days)
costs = client.llm_costs.summary
puts "Total: $#{'%.2f' % (costs.data.summary.total_cost_cents / 100.0)}"
puts "Tokens: #{costs.data.summary.total_tokens}"

# Breakdown by provider
costs.data.providers.each do |p|
  puts "  #{p.name}: $#{'%.2f' % (p.cost_cents / 100.0)}"
end

# Breakdown by model
costs.data.models.each do |m|
  puts "  #{m.model}: $#{'%.2f' % (m.cost_cents / 100.0)}"
end

# Daily trend
costs.data.daily.each do |day|
  puts "  #{day.date}: $#{'%.2f' % (day.cost_cents / 100.0)}"
end

# Custom date range
costs = client.llm_costs.summary(
  start_date: '2025-01-01',
  end_date: '2025-01-31'
)

# Costs by client
client.llm_costs.by_client.data.each do |entry|
  puts "#{entry.name}: $#{'%.2f' % (entry.cost_cents / 100.0)}"
end

# Costs by provider
client.llm_costs.by_provider.data.each do |entry|
  puts "#{entry.name}: $#{'%.2f' % (entry.cost_cents / 100.0)}"
end
```

## Pagination

All `.list` methods return an `Enumerable` iterator that handles pagination automatically. By default, the API returns 25 items per page (max 100).

```ruby
# Auto-paginate through all results
client.clients.list.each do |c|
  puts c.name
end

# Control page size
client.clients.list(per_page: 100).each do |c|
  puts c.name
end

# Get a single page
page = client.clients.list(per_page: 10).first_page
puts "#{page.meta.total} total, #{page.meta.total_pages} pages"
page.each do |c|
  puts c.name
end

# Use any Enumerable method
names = client.clients.list.map(&:name)
active = client.workflows.list.select(&:is_active)
first_five = client.users.list.first(5)
```

## Error handling

The SDK raises typed exceptions for all API errors:

```ruby
require 'administrate-sdk'

client = Administrate.new(api_key: 'sk_live_...')

begin
  c = client.clients.get('com_nonexistent')
rescue Administrate::NotFoundError => e
  puts "Not found: #{e.message}"
rescue Administrate::AuthenticationError
  puts 'Invalid API key'
rescue Administrate::RateLimitError => e
  puts "Rate limited. Retry after #{e.retry_after}s"
rescue Administrate::ValidationError => e
  puts "Invalid params: #{e.body}"
rescue Administrate::APIError => e
  puts "API error #{e.status_code}: #{e.message}"
end
```

**Exception hierarchy:**

| Exception | Status code | Description |
|---|---|---|
| `Administrate::Error` | -- | Base exception for all SDK errors |
| `Administrate::APIError` | Any non-2xx | Base for all HTTP API errors |
| `Administrate::AuthenticationError` | 401 | Invalid or missing API key |
| `Administrate::PermissionDeniedError` | 403 | Insufficient token permissions |
| `Administrate::NotFoundError` | 404 | Resource does not exist |
| `Administrate::ValidationError` | 422 | Invalid request parameters |
| `Administrate::RateLimitError` | 429 | Rate limit exceeded (has `retry_after`) |
| `Administrate::InternalServerError` | 5xx | Server-side error |
| `Administrate::ConnectionError` | -- | Failed to connect to the API |
| `Administrate::TimeoutError` | -- | Request timed out |

All `APIError` subclasses expose `status_code`, `response` (the raw Faraday response), and `body` (parsed JSON or text).

## Retries

The SDK automatically retries failed requests with exponential backoff:

- **429 (rate limited)** -- Retries after the duration specified in the `Retry-After` header
- **5xx (server errors)** -- Retries with exponential backoff (0.5s, 1s, 2s, ...)
- **Connection errors and timeouts** -- Retried with the same backoff schedule

By default, the SDK retries up to 3 times. Set `max_retries: 0` to disable:

```ruby
client = Administrate.new(api_key: 'sk_live_...', max_retries: 0)
```

## Requirements

- Ruby 3.1+
- [faraday](https://lostisland.github.io/faraday/) >= 2.0
- [faraday-retry](https://github.com/lostisland/faraday-retry) >= 2.0

## License

MIT
