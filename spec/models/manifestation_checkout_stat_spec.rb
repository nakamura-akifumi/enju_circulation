require 'rails_helper'

describe ManifestationCheckoutStat do
  fixtures :manifestation_checkout_stats, :messages

  it 'calculates manifestation count' do
    old_message_count = Message.count
    manifestation_checkout_stats(:one).transition_to!(:started).should be_truthy
    Message.count.should eq old_message_count + 1
    Message.order(created_at: :desc).first.subject.should eq '集計が完了しました'
    manifestation_checkout_stats(:one).current_state.should eq 'completed'
  end
end

# == Schema Information
#
# Table name: manifestation_checkout_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  created_at   :datetime
#  updated_at   :datetime
#  started_at   :datetime
#  completed_at :datetime
#  user_id      :integer
#
