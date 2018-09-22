# MailchimpWrapper

It is just example of usage mailchimp API by [mailchimp3 gem](https://github.com/seven1m/mailchimp3)

## Usage
Set MAILCHIMP_APIKEY to .env-file
```bash
MAILCHIMP_APIKEY=123
```

## Example of usage
For all methods see [lib/mailchimp_wrapper.rb](https://github.com/kopylovvlad/mailchimp_wrapper/blob/master/lib/mailchimp_wrapper.rb)
```bash
item = MailchimpWrapper.new(ENV['MAILCHIMP_APIKEY'], true)
item.get_lists
```

## Mailchimp doc
[link](https://developer.mailchimp.com/documentation/mailchimp/reference/campaigns/#%20)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
