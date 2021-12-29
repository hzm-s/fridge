# typed: false
require 'domain_helper'

module Team
  describe Team do
    describe 'create' do
      it do
        team = described_class.create(name('ABC'))

        aggregate_failures do
          expect(team.id).to_not be_nil
          expect(team.name.to_s).to eq 'ABC'
          expect(team.members).to be_empty
        end
      end
    end

    let(:team) { described_class.create(name('The Team')) }

    describe 'develop' do
      let(:product_id) { Product::Id.create }

      it do
        team.develop(product_id)

        expect(team.product).to eq product_id
      end
    end

    describe 'add member' do
      let(:po) { register_person }
      let(:sm) { register_person }
      let(:new_member) { register_person }

      before do
        team.add_member(po_member(po.id))
        team.add_member(sm_member(sm.id))
        8.times do |n|
          dev = register_person
          team.add_member(dev_member(dev.id))
        end
      end

      it '同じ人は複数参加できないこと' do
        team.add_member(dev_member(new_member.id))
        expect { team.add_member(dev_member(new_member.id)) }
          .to raise_error(AlreadyJoined)
      end

      it '2人目のプロダクトオーナーはエラーになること' do
        expect { team.add_member(po_member(new_member.id)) }
          .to raise_error(TooManyProductOwner)
      end

      it '2人目のプロダクトオーナー(兼務)はエラーになること' do
        expect { team.add_member(team_member(new_member.id, :po, :sm)) }
          .to raise_error(TooManyProductOwner)
      end

      it '2人目のスクラムマスターはエラーになること' do
        expect { team.add_member(sm_member(new_member.id)) }
          .to raise_error(TooManyScrumMaster)
      end

      it '2人目のスクラムマスター(兼務)はエラーになること' do
        expect { team.add_member(team_member(new_member.id, :sm, :dev)) }
          .to raise_error(TooManyScrumMaster)
      end

      it '10人目の開発者はエラーになること' do
        team.add_member(dev_member(register_person.id))
        expect { team.add_member(dev_member(new_member.id)) }
          .to raise_error(TooManyDeveloper)
      end
    end

    describe 'available roles' do
      it do
        expect(team.available_roles).to match_array [Role::ProductOwner, Role::Developer, Role::ScrumMaster]
      end

      it do
        team.add_member(po_member(register_person.id))
        expect(team.available_roles).to match_array [Role::Developer, Role::ScrumMaster]
      end

      it do
        team.add_member(po_member(register_person.id))
        team.add_member(dev_member(register_person.id))
        expect(team.available_roles).to match_array [Role::Developer, Role::ScrumMaster]
      end

      it do
        team.add_member(po_member(register_person.id))
        team.add_member(dev_member(register_person.id))
        team.add_member(sm_member(register_person.id))
        expect(team.available_roles).to match_array [Role::Developer]
      end

      it do
        team.add_member(po_member(register_person.id))
        team.add_member(dev_member(register_person.id))
        team.add_member(sm_member(register_person.id))
        7.times do
          team.add_member(dev_member(register_person.id))
        end
        expect(team.available_roles).to match_array [Role::Developer]
      end

      it do
        team.add_member(po_member(register_person.id))
        team.add_member(dev_member(register_person.id))
        team.add_member(sm_member(register_person.id))
        8.times do
          team.add_member(dev_member(register_person.id))
        end
        expect(team.available_roles).to be_empty
      end

      it do
        team.add_member(team_member(register_person.id, :po, :sm))
        expect(team.available_roles).to match_array [Role::Developer]
      end

      it do
        team.add_member(team_member(register_person.id, :sm, :dev))
        expect(team.available_roles).to match_array [Role::ProductOwner, Role::Developer]
      end
    end
  end
end
