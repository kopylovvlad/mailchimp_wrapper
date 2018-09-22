require 'dotenv'
require 'mailchimp3'
Dotenv.load


class MailchimpWrapper
  VERSION = "0.1.0".freeze
  attr_accessor :debug
  attr_reader :api

  def initialize(api_key, debug)
    @api = MailChimp3.new(basic_auth_key: api_key)
    @debug = debug
  end

  ##
  # LISTS CRUD
  ##

  # get lists
  # @return [Hash] answer from server
  def get_lists
    answer = @api.lists.get
    short_answer = {
      'total_items' => answer['total_items']
    }
    short_answer['lists'] = answer['lists'].map do |i|
      i.slice('id', 'web_id', 'name')
    end

    pp(short_answer) if @debug == true
    short_answer
  end

  # get one list
  # @param list_id [String] id
  # @return [Hash] answer from server
  def get_list(list_id = '05d8c607fd')
    answer = @api.lists[list_id].get
    short_answer = answer.slice('id', 'web_id', 'name', 'stats')

    pp(short_answer) if @debug == true
    short_answer
  end

  # create a list
  # @param hash [Hash] data about new list
  # @return [Hash] answer from server
  def create_list(hash = {})
    answer = @api.lists.post(
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

    pp(answer) if @debug == true
    answer
  end

  # delete a list
  # @param list_id [String] id
  # @return [Boolean] answer from server
  def delete_list(list_id = 'fbb2a98cd4')
    api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])
    answer = api.lists[list_id].delete

    pp(answer) if @debug == true
    answer
  end

  ##
  # LIST'S MEMBER CRUD
  ##

  # get list's members
  # @param list_id [String] id
  # @return [Hash] answer from server
  def get_list_members(list_id = '05d8c607fd')
    api = MailChimp3.new(basic_auth_key: ENV['MAILCHIMP_APIKEY'])

    answer = api.lists[list_id].members.get
    short_answer = {
      'list_id' => answer['list_id'],
      'total_items' => answer['total_items']
    }
    short_answer['members'] = answer['members'].map do |i|
      i.slice('id', 'email_address', 'unique_email_id')
    end

    pp(short_answer) if @debug == true
    short_answer
  end

  # get list's member
  # @param list_id [String] list id
  # @param member_id [String] member id
  # @return [Hash] answer from server
  def get_list_member(list_id = '05d8c607fd',
                      member_id = '571a81bf307adf68f4b016a2ae499ef1')
    answer = @api.lists[list_id].members[member_id].get
    short_answer = answer
                   .slice('id', 'email_address', 'unique_email_id', 'status')

    pp(short_answer) if @debug == true
    short_answer
  end

  # add member to list
  # @param list_id [String] list id
  # @param member [Hash] data about new member
  # @return [Hash] answer from server
  def create_list_member(list_id = '05d8c607fd', hash = {})
    answer = @api.lists[list_id].members.post(
      email_address: "zxcxcvxcv1@tmail.com",
      status: 'subscribed'
    )

    pp(answer) if @debug == true
    answer
  end

  # add members to list
  # @param list_id [String] list id
  # @param hash [Hash] data about new members
  # @return [Hash] answer from server
  def create_list_members(list_id = '05d8c607fd', hash = {})
    answer = @api.lists[list_id].post(
      members: [
        {
          email_address: "zxcxcvxcv2@tmail.com",
          status: 'subscribed'
        },
        {
          email_address: "zxcxcvxcv3@tmail.com",
          status: 'subscribed'
        }
      ],
      update_existing: false
    )

    pp(answer) if @debug == true
    answer
  end

  # delete member from list
  # @param list_id [String] list id
  # @param member_id [String] member id
  # @return [Boolean] answer from server
  def delete_list_member(list_id = '05d8c607fd',
                         member_id = '7f2effe9e6b371add87d4d980a0b8c97')
    answer = @api.lists[list_id].members[member_id].delete
    pp(answer) if @debug == true
    answer
  end

  ##
  # Campaign
  ##

  # get campaigns
  # @return [Hash] answer from server
  def get_campaigns
    answer = @api.campaigns.get
    short_answer = {
      'total_items' => answer['total_items']
    }
    puts answer
    short_answer['campaigns'] = answer['campaigns'].map do |i|
      h = i.slice('id', 'web_id', 'type', 'status', 'emails_sent')
      h['title'] = i['settings']['title']
      h
    end

    pp(short_answer) if @debug == true
    short_answer
  end

  # get campaign
  # @param campaign_id [String] campaign id
  # @return [Hash] answer from server
  def get_campaign(campaign_id = '490b7bf7ba')
    answer = @api.campaigns[campaign_id].get
    short_answer = answer.slice('id', 'web_id', 'type', 'status', 'emails_sent')
    pp(short_answer) if @debug == true
    short_answer
  end

  # create campaign
  # @param hash [Hash] data
  # @return [Boolean] answer from server
  def create_campaign(hash = {})
    answer = @api.campaigns.post(
      type: 'regular',
      recipients: {
        list_id: '05d8c607fd'
      },
      settings: {
        title: 'my new campaigns #1'
      }
    )

    pp(answer) if @debug == true
    answer
  end

  # delete campaign
  # @param campaign_id [String] id
  # @return [Boolean] answer from server
  def delete_campaign(campaign_id = 'e77d13b63b')
    answer = @api.campaigns[campaign_id].delete
    pp(answer) if @debug == true
    answer
  end

  # TODO: clone campaign
  # TODO: send campaign

  private

  def pp(hash)
    puts JSON.pretty_generate(hash).gsub(":", " =>")
  end
end

