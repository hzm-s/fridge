# typed: false
require 'domain_helper'

module Team
  RSpec.describe Team do
    describe '#add_member' do
      let(:po) { register_person }
      let(:sm) { register_person }
      let(:new_member) { register_person }

      before do
        @team = described_class.new([])
        @team = @team.add_member(po_member(po.id))
        @team = @team.add_member(sm_member(sm.id))
        8.times do |n|
          dev = register_person
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
        dev = register_person
        @team = @team.add_member(dev_member(dev.id))
        expect { @team.add_member(dev_member(new_member.id)) }
          .to raise_error(TooLargeDevelopmentTeam)
      end
    end

    describe '#available_roles' do
      it do
        team = described_class.new([dev_member(register_person.id)])

        expect(team.available_roles).to match_array [Role::ProductOwner, Role::Developer, Role::ScrumMaster]

        team = team.add_member(po_member(register_person.id))
        expect(team.available_roles).to match_array [Role::Developer, Role::ScrumMaster]

        team = team.add_member(sm_member(register_person.id))
        expect(team.available_roles).to match_array [Role::Developer]

        7.times do
          team = team.add_member(dev_member(register_person.id))
        end
        expect(team.available_roles).to match_array [Role::Developer]

        team = team.add_member(dev_member(register_person.id))
        expect(team.available_roles).to be_empty
      end
    end
  end
end
