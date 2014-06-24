# -*- encoding: utf-8 -*-
require 'spec_helper'

describe UserCheckoutStat do
  fixtures :user_checkout_stats

  it "calculates user count" do
    user_checkout_stats(:one).transition_to!(:started).should be_true
  end
end

# == Schema Information
#
# Table name: user_checkout_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  state        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#

