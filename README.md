# Bulkforce

[![Build Status](https://travis-ci.org/propertybase/bulkforce.png?branch=master)](https://travis-ci.org/propertybase/bulkforce) [![Coverage Status](https://coveralls.io/repos/propertybase/bulkforce/badge.png?branch=master)](https://coveralls.io/r/propertybase/bulkforce) [![Code Climate](https://codeclimate.com/github/propertybase/bulkforce.png)](https://codeclimate.com/github/propertybase/bulkforce) [![Dependency Status](https://gemnasium.com/propertybase/bulkforce.png)](https://gemnasium.com/propertybase/bulkforce) [![Gem Version](https://badge.fury.io/rb/bulkforce.png)](http://badge.fury.io/rb/bulkforce)

This is a fork of the originial [Executrix](http://github.com/propertybase/executrix) gem with some breaking API changes. In the long term, this gem will replace Executrix.

It is a Ruby MRI 2.1+ gem only.

## Overview

Bulkforce is a simple ruby gem for connecting to and using the [Salesforce Bulk API](http://www.salesforce.com/us/developer/docs/api_asynch/index.htm). This gem only supports the functionality provided by the bulk API.

## Installation

~~~ sh
$ sudo gem install bulkforce
~~~

## How to use

After requiring using this gem is simple and straight forward.

~~~ ruby
require "bulkforce"
~~~

### Authentication

The authentication is heavily inspired by [Restforce](https://github.com/ejholmes/restforce)

### Session ID and instance

If you already have a session id and a instance you can directly authenticate against Salesforce:

~~~ ruby
salesforce = Bulkforce.new(
  session_id: "YOUR_SESSION_ID",
  instance: "YOUR_INSTANCE",
)
~~~

#### Username/Password/Security Token

Bulkforce supports basic authentication via username, password and security token.

~~~ ruby
salesforce = Bulkforce.new(
  username: "YOUR_SALESFORCE_USERNAME",
  password: "YOUR_SALESFORCE_PASSWORD",
  security_token: "YOUR_SALESFORCE_TOKEN,
)
~~~

#### OAuth

You can also authenticate via OAuth. Therefore you need the `client_id`, `client_secret` and `refresh_token`.

~~~ ruby
salesforce = Bulkforce.new(
  client_id: "YOUR_CLIENT_ID",
  client_secret: "YOUR_CLIENT_SECRET",
  refresh_token: "YOUR_REFRESH_TOKEN,
)
~~~

#### Priority

If you define credentials for multiple authentication methods, the following priority applies:

  - Session ID
  - OAuth
  - User/Password/Security Token

#### ENV variables

You can also define the credentials in Environment variables which are as following:

~~~
SALESFORCE_API_VERSION=...
SALESFORCE_USERNAME=...
SALESFORCE_PASSWORD=...
SALESFORCE_SECURITY_TOKEN=...
SALESFORCE_HOST=...
SALESFORCE_CLIENT_ID=...
SALESFORCE_CLIENT_SECRET=...
SALESFORCE_INSTANCE=...
SALESFORCE_REFRESH_TOKEN=...
~~~

Afterwards you can just instantiate the client:

~~~ ruby
Bulkforce.new
~~~

### Sandbox

To use the bulkforce against your salesforce sandbox, change the host to `test.salesforce.com`

~~~ ruby
salesforce = Bulkforce.new(
  # credentials
  host: "test.salesforce.com",
)
~~~

### OrgId

After you created the client object you can fetch the OrgId via `org_id`.

This will fetch the 15 digit OrgId.

~~~ ruby
salesforce.org_id # "00D50000000IehZ"
~~~

### Operations

~~~ ruby
# Insert
new_account = {"name" => "Test Account", "type" => "Other"} # Add as many fields per record as needed.
records_to_insert = []
records_to_insert << new_account # You can add as many records as you want here, just keep in mind that Salesforce has governor limits.
result = salesforce.insert("Account", records_to_insert)
puts "reference to the bulk job: #{result.inspect}"
~~~

~~~ ruby
# Update
updated_account = {"name" => "Test Account -- Updated", "id" => "a00A0001009zA2m"} # Nearly identical to an insert, but we need to pass the salesforce id.
records_to_update = []
records_to_update.push(updated_account)
salesforce.update("Account", records_to_update)
~~~

~~~ ruby
# Upsert
upserted_account = {"name" => "Test Account -- Upserted", "External_Field_Name" => "123456"} # Fields to be updated. External field must be included
records_to_upsert = []
records_to_upsert.push(upserted_account)
salesforce.upsert("Account", records_to_upsert, "External_Field_Name") # Note that upsert accepts an extra parameter for the external field name
~~~

~~~ ruby
# Delete
deleted_account = {"id" => "a00A0001009zA2m"} # We only specify the id of the records to delete
records_to_delete = []
records_to_delete.push(deleted_account)
salesforce.delete("Account", records_to_delete)
~~~

~~~ ruby
# Query
res = salesforce.query("Account", "select id, name, createddate from Account limit 3") # We just need to pass the sobject name and the query string
puts res.result.records.inspect
~~~

## File Upload

For file uploads, just add a `File` object to the binary columns.
~~~ ruby
attachment = {"ParentId" => "00Kk0001908kqkDEAQ", "Name" => "attachment.pdf", "Body" => File.new("tmp/attachment.pdf")}
records_to_insert = []
records_to_insert << attachment
salesforce.insert("Attachment", records_to_insert)
~~~

### Query status

The above examples all return immediately after sending the data to the Bulk API. If you want to wait, until the batch finished, call the final_status method on the batch-reference.

~~~ ruby
new_account = {"name" => "Test Account", "type" => "Other"} # Add as many fields per record as needed.
records_to_insert = []
records_to_insert << new_account # You can add as many records as you want here, just keep in mind that Salesforce has governor limits.
batch_reference = salesforce.insert("Account", records_to_insert)
results = batch_reference.final_status
puts "the results: #{results.inspect}"
~~~

Additionally you cann pass in a block to query the current state of the batch job:

~~~ ruby
new_account = {"name" => "Test Account", "type" => "Other"} # Add as many fields per record as needed.
records_to_insert = []
records_to_insert << new_account # You can add as many records as you want here, just keep in mind that Salesforce has governor limits.
batch_reference = salesforce.insert("Account", records_to_insert)
results = batch_reference.final_status do |status|
  puts "running: #{status.inspect}"
end
puts "the results: #{results.inspect}"
~~~

The block will yield every 2 seconds, but you can also specify the poll interval:

~~~ ruby
new_account = {"name" => "Test Account", "type" => "Other"} # Add as many fields per record as needed.
records_to_insert = []
records_to_insert << new_account # You can add as many records as you want here, just keep in mind that Salesforce has governor limits.
batch_reference = salesforce.insert("Account", records_to_insert)
poll_interval = 10
results = batch_reference.final_status(poll_interval) do |status|
  puts "running: #{status.inspect}"
end
puts "the results: #{results.inspect}"
~~~

## Copyright

Copyright (c) 2012 Jorge Valdivia.
Copyright (c) 2015 Leif Gensert, [Propertybase GmbH](http://propertybase.com)
