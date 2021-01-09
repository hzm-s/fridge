# typed: false
class TeamRolesValidator < ActiveModel::EachValidator
  def validate_each(model, attr, value)
    role_strs = Array(value)

    if role_strs.all?(&:blank?)
      model.errors.add(attr, I18n.t('errors.messages.blank'))
      return
    end

    roles = role_strs.reject(&:blank?).map { |str| Team::Role.from_string(str) }
    begin
      object = Team::RoleSet.new(roles)
    rescue ArgumentError => e
      model.errors.add(attr, I18n.t('domain.errors.team.invalid_multiple_roles'))
    else
      store_domain_object(model, attr, object)
    end
  end

  private

  def store_domain_object(model, attr, object)
    return unless model.respond_to?(:domain_objects)

    model.domain_objects = Hash(model.domain_objects).merge(attr => object)
  end
end
