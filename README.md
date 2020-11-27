## Local Development

### Step 1

```
bundle install
rails db:create
rails development_setup:perform
```

### Step 2

`rails credentials:edit --environment=test`

```
stripe:
  private_key: sk_test_123
  public_key: pk_test_123
  signing_secret: 123abc
```

`rails credentials:edit --environment=development`

```
stripe:
  private_key: sk_test_123
  public_key: pk_test_123
  signing_secret: 123abc
```

`rails credentials:edit`

```
digitalocean:
  access_key_id: 123abc
  secret_access_key: 123abc
  region: nyc3
  bucket: 123abc

sendgrid:
  username: apikey
  password: 123abc

stripe:
  private_key: sk_live_123
  public_key: pk_live_123
  signing_secret: 123abc
```

### Step 3

`foreman start`

## Tests

```
rails t
rails test:system
```