# typed: false
require 'rails_helper'

module Product
  RSpec.describe Product do
    describe '#add_team_member' do
      let(:product) { described_class.create('abc') }
      let(:po) { User::User.create('po', 'po@e.mail') }
      let(:sm) { User::User.create('sm', 'sm@e.mail') }
      let(:new_member) { User::User.create('new member', 'new.member@e.mail') } 

      before do
        product.add_team_member(po_member(po.id))
        product.add_team_member(sm_member(sm.id))
        9.times do |n|
          dev = User::User.create("dev#{n}", "dev#{n}@e.mail")
          product.add_team_member(dev_member(dev.id))
        end
      end

      it '2人目のプロダクトオーナーはエラーになること' do
        expect { product.add_team_member(po_member(new_member.id)) }
          .to raise_error(Team::DuplicateProductOwnerError)
      end

      it '2人目のスクラムマスターはエラーになること' do
        expect { product.add_team_member(sm_member(new_member.id)) }
          .to raise_error(Team::DuplicateScrumMasterError)
      end

      it '10人目の開発者はエラーになること' do
        expect { product.add_team_member(dev_member(new_member.id)) }
          .to raise_error(Team::LargeDevelopmentTeamError)
      end
    end
  end
end
