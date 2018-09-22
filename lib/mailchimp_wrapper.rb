require 'dotenv'
require 'mailchimp3'
Dotenv.load

# ENV['MAILCHIMP_APIKEY']

class MailchimpTest
  VERSION = "0.1.0".freeze

  def initialize(api_key)
    @api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])
  end
  ##
  # LISTS CRUD
  ##

  # get lists
  # @param debug [Boolean] print hash to console
  # @return [Hash] answer from server
  def self.get_lists(debug = true)
    api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])

    short_answer = {
      'lists' => [],
      'total_items' => 0
    }
    answer = api.lists.get
    short_answer['total_items'] = answer['total_items']
    short_answer['lists'] = answer['lists'].map do |i|
      {
        'id' => i['id'],
        'web_id' => i['web_id'],
        'name' => i['name']
      }
    end

    debug(short_answer) if debug = true

    short_answer
  end

  def self.debug(hash)
    puts JSON.pretty_generate(hash).gsub(":", " =>")
  end

  # get one list
  # @param debug [Boolean] print hash to console
  # @return [Hash] answer from server
  def self.get_list(list_id = '05d8c607fd', debug=true)
    api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])
    short_answer = {
      'id' => 0,
      'web_id' => 0,
      'name' => 0,
      'stats' => {
        'member_count' => 0,
        'unsubscribe_count' => 0
      }
    }
    answer = api.lists[list_id].get
    short_answer['id'] = answer['id']
    short_answer['web_id'] = answer['web_id']
    short_answer['name'] = answer['name']
    short_answer['stats'] = answer['stats']

    puts JSON.pretty_generate(short_answer).gsub(":", " =>")
    short_answer
  end

  # create a list
  def self.create_list
    api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])
    answer = api.lists.post(
      name: 'Church.IO',
      email_type_option: false,
      permission_reminder: 'signed up on https://church.io',
      contact: {
        company: 'TJRM',
        address1: '123 N. Main',
        city: 'Tulsa',
        state: 'OK',
        zip: '74137',
        country: 'US'
      },
      campaign_defaults: {
        from_name: 'Tim Morgan',
        from_email: 'tim@timmorgan.org',
        subject: 'Hello World',
        language: 'English'
      },
    )

    puts JSON.pretty_generate(answer).gsub(":", " =>")
    answer
  end

  # delete a list
  #
  def self.delete_list(list_id = 'fbb2a98cd4')
    api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])
    answer = api.lists[list_id].delete

    puts JSON.pretty_generate(answer).gsub(":", " =>")
    answer
  end

  ##
  # LIST'S MEMBER CRUD
  ##

  # get list's members
  def self.lists_members(list_id = '05d8c607fd')
    api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])
    short_answer = {
      'list_id' => 0,
      'total_items' => 0,
      'members' => []
    }

    answer = api.lists[list_id].members.get
    short_answer['list_id'] = answer['list_id']
    short_answer['total_items'] = answer['total_items']
    short_answer['members'] = answer['members'].map do |i|
      {
        'id' => i['id'],
        'email_address' => i['email_address'],
        'unique_email_id' => i['unique_email_id']
      }
    end

    puts JSON.pretty_generate(short_answer).gsub(":", " =>")
    short_answer
  end

  ##
  # create new list

  ##
  # add subscribers to Mailchimp

  ##
  # load subscribers from Mailchimp

  ##
  # clone campaign with new subscriber's list
end


# example
MailchimpTest