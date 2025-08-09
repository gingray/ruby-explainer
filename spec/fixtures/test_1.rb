# frozen_string_literal: true

class MyPlayerClass
  attr_reader :player, :heal_service, :hit_service
  def initialize(player, heal_service: GenericHeal.new, hit_service: GenericHit.new)
    @player = player
    @heal_service = heal_service
    @hit_service = hit_service
  end

  def call(heal_amount, hit_crit_chance, &block)
    if rand < 0.5
      heal_me(heal_amount)
    else
      hit_creep(hit_crit_chance)
    end
    block.call(player)
  end

  private
  def heal_me(amount)
    service.call(amount)
  end

  def hit_creep(amount)
    service.call(amount)
  end
end
