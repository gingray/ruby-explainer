## Description
Basically app take existing ruby code parse it to AST and rebuild it. In the way that each method call or line call are wrapped with `puts/` to log all execution process.  
Sometimes I need to execute in console some peace of existing code to understand how it works.  
Example: 
```ruby
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
```  
will transform to  
```ruby
class MyPlayerClass
  attr_reader(:player, :heal_service, :hit_service)

  def initialize(player, heal_service: GenericHeal.new, hit_service: GenericHit.new)
    (puts(["\nLOG arguments ", "player=", player, "heal_service=", heal_service, "hit_service=", hit_service, "\n"].join))
    (tmpz = @player = player; puts(["\n[", self, "] result of call ", "@player = player", ": ", tmpz, "\n"].join); tmpz)
    (tmpz = @heal_service = heal_service; puts(["\n[", self, "] result of call ", "@heal_service = heal_service", ": ", tmpz, "\n"].join); tmpz)
    (tmpz = @hit_service = hit_service; puts(["\n[", self, "] result of call ", "@hit_service = hit_service", ": ", tmpz, "\n"].join); tmpz)
  end

  def call(heal_amount, hit_crit_chance, &block)
    (puts(["\nLOG arguments ", "heal_amount=", heal_amount, "hit_crit_chance=", hit_crit_chance, "block=", block, "\n"].join))
    (tmpz = if rand < 0.5
      heal_me(heal_amount)
    else
      hit_creep(hit_crit_chance)
    end; puts(["\n[", self, "] result of call ", "if rand < 0.5\n  heal_me(heal_amount)\nelse\n  hit_creep(hit_crit_chance)\nend", ": ", tmpz, "\n"].join); tmpz)
    (tmpz = block.call(player); puts(["\n[", self, "] result of call ", "block.call(player)", ": ", tmpz, "\n"].join); tmpz)
  end
  private

  def heal_me(amount)
    (puts(["\nLOG arguments ", "amount=", amount, "\n"].join))
    (tmpz = service.call(amount); puts(["\n[", self, "] result of call ", "service.call(amount)", ": ", tmpz, "\n"].join); tmpz)
  end

  def hit_creep(amount)
    (puts(["\nLOG arguments ", "amount=", amount, "\n"].join))
    (tmpz = service.call(amount); puts(["\n[", self, "] result of call ", "service.call(amount)", ": ", tmpz, "\n"].join); tmpz)
  end
end
```

Current state it's just POC