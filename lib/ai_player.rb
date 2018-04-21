require 'byebug'
require_relative 'player'

class AIPlayer < Player

  def initialize(name,deck)
    super(name, deck)
    @mrroboto = {}
  end


  def add_players_arr(arr)
    @players = arr.select { |player| player.name != name}
  end


  def get_input
    # debugger
    input = []
    hand.each do |card|
      if mrroboto[card.value] != nil && mrroboto[card.value].length > 0
        input.push(card.value)
        #pop because player that eventually gets asked must surrender all of card.value
        removed_player = mrroboto[card.value].pop
        input.push(removed_player.name)
        return input
      end
    end
    input.push(hand[0].value)
    input.push(players[0].name)
    return input
    # value = gets.chomp.to_sym
    #no prompts. the AI player does everything automatically. from the outside though,
    #it's implemented like player.rb

  end

  def add_memory(value, target_player)
    if target_player.name == name
      return nil
    end
    if mrroboto[value] == nil
      mrroboto[value] = [target_player]
    else
      mrroboto[value].push(target_player)
    end
  end

  def remove_memory(value, target_player)
    if target_player.name == name
      return nil
    end
    if mrroboto[value] !=nil
      mrroboto[value].delete(target_player)
    end
  end


  protected

  attr_reader :players
  attr_accessor :mrroboto


end
