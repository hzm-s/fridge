# typed: false
require 'rails_helper'

module Team
  RSpec.describe Team do
    describe '#add_member' do
      let(:po) { User::User.create('po', 'po@e.mail') }
      let(:sm) { User::User.create('sm', 'sm@e.mail') }
      let(:new_member) { User::User.create('new member', 'new.member@e.mail') } 

      before do
        @team = described_class.new([])
        @team = @team.add_member(po_member(po.id))
        @team = @team.add_member(sm_member(sm.id))
        8.times do |n|
          dev = User::User.create("dev#{n}", "dev#{n}@e.mail")
          @team = @team.add_member(dev_member(dev.id))
        end
      end

      it '同じ役割では参加できないこと' do
        @team = @team.add_member(dev_member(new_member.id))
        expect { @team.add_member(dev_member(new_member.id)) }
          .to raise_error(AlreadyJoined)
      end

      it '2人目のプロダクトオーナーはエラーになること' do
        expect { @team.add_member(po_member(new_member.id)) }
          .to raise_error(DuplicatedProductOwner)
      end

      it '2人目のスクラムマスターはエラーになること' do
        expect { @team.add_member(sm_member(new_member.id)) }
          .to raise_error(DuplicatedScrumMaster)
      end

      it '10人目の開発者はエラーになること' do
        dev = User::User.create('last dev', 'last.dev@e.mail')
        @team = @team.add_member(dev_member(dev.id))
        expect { @team.add_member(dev_member(new_member.id)) }
          .to raise_error(TooLargeDevelopmentTeam)
      end
    end
  end
end
